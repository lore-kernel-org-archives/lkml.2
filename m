Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab1JCBqI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 21:46:08 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42359 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab1JCBqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 21:46:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Serge Hallyn <serge@hallyn.com>,
        akpm@osdl.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        containers@lists.linux-foundation.org, dhowells@redhat.com,
        rdunlap@xenotime.net, kernel-hardening@lists.openwall.com
References: <1314993400-6910-1-git-send-email-serge@hallyn.com>
	<1314993400-6910-4-git-send-email-serge@hallyn.com>
	<20110926191737.GA4562@albatros> <20110927132157.GB3111@sergelap>
	<20110927155659.GA22532@albatros> <20111001170047.GA2935@sergelap>
Date: Sun, 02 Oct 2011 18:46:06 -0700
In-Reply-To: <20111001170047.GA2935@sergelap> (Serge E. Hallyn's message of
	"Sat, 1 Oct 2011 12:00:47 -0500")
Message-ID: <m1aa9i4zkx.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19rUF9qaFg9hsSRyuP9+BsngM96dvpI3wY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: lkml.org]
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.8 RDNS_NONE Delivered to internal network by a host with no rDNS
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *******;"Serge E. Hallyn" <serge.hallyn@canonical.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 01/15] add Documentation/namespaces/user_namespace.txt (v3)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge.hallyn@canonical.com> writes:

> Quoting Vasiliy Kulikov (segoon@openwall.com):
>> On Tue, Sep 27, 2011 at 08:21 -0500, Serge E. Hallyn wrote:
>> > > First, the patches by design expose much kernel code to unprivileged
>> > > userspace processes.  This code doesn't expect malformed data (e.g. VFS,
>> > > specific filesystems, block layer, char drivers, sysadmin part of LSMs,
>> > > etc. etc.).  By relaxing permission rules you greatly increase attack
>> > > surface of the kernel from unprivileged users.  Are you (or somebody
>> > > else) planning to audit this code?

Well in theory this codes does expose this code to unprivileged user
space in a way that increases the attack surface.    However right now
there are a lot of cases where because the kernel lacks a sufficient
mechanism people are just given root provileges so that can get things
done.  Network manager controlling the network stack as an unprivileged
user.  Random filesystems on usb sticks being mounted and unmounted
automatically when the usb sticks are inserted and removed.

I completely agree that auditing and looking at the code is necessary I
think most of what will happen is that we will start directly supporting
how the kernel is actually used in the real world.  Which should
actually reduce our level of vulnerability, because we give up the
delusion that large classes of operations don't need careful
attention because only root can perform them.   Operations which the
user space authors turn around and write a suid binary for and
unprivileged user space performs those operations all day long.

>> > I had wanted to (but didn't) propose a discussion at ksummit about how
>> > best to approach the filesystem code.  That's not even just for user
>> > namespaces - patches have been floated in the past to make mount an
>> > unprivileged operation depending on the FS and the user's permission
>> > over the device and target.
>> 
>> This is a dangerous operation by itself.
>
> Of course it is :)  And it's been a while since it has been brought up,
> but it *was* quite well thought through and throrougly discussed - see
> i.e. https://lkml.org/lkml/2008/1/8/131
>
> Oh, that's right.  In the end the reason it didn't go in had to do with
> the ability for an unprivileged user to prevent a privileged user from
> unmounting trees by leaving a busy mount in a hidden namespace.
>
> Eric, in the past we didn't know what to do about that, but I wonder
> if setns could be used in some clever way to solve it from userspace.

Oh.  That is a good objection.  I had not realized that unprivileged
mounts had that problem.

Still the solution is straight forward.  If the concern is that an
unprivileged user can prevent a privileged user from unmounting trees,
we need to require that a forced unmount of the filesystem triggers a
revoke on all open files.  sysfs and proc already support revoke at the
per file level so we can safely remove modules, we just need to extend
that support to the forced unmount case.

This is problem that actually needs to be solved for ordinary file
systems as well because of hot pluggable usb drives.  For filesystems
like ext4 it is more difficult because we need a solution that does
not sacrafice performance in the common case.  I was talking to 
Ted Tso a bit about this at plumbers conf.  It happens that hot unplug
of usb devices with mount filesystems are currently a non-ending source
of subtle bugs in the extN code.

The one implementation detail that sounds a bit trick is what to do
about mount structures in mount namespaces when we forcibly unmount
a filesystem.  That could get a bit complicated but if that is the only
hang up I'm certain we can figure something out.

Eric
