Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab1JCTxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 15:53:54 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46855 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458Ab1JCTxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 15:53:39 -0400
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
	<m1aa9i4zkx.fsf@fess.ebiederm.org>
Date: Mon, 03 Oct 2011 12:53:48 -0700
In-Reply-To: <m1aa9i4zkx.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Sun, 02 Oct 2011 18:46:06 -0700")
Message-ID: <m1zkhh3l83.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/8vL3YLfpiCk7HlE/HmxCRABq7yVCDPKY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: lkml.org]
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.8 RDNS_NONE Delivered to internal network by a host with no rDNS
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *******;"Serge E. Hallyn" <serge.hallyn@canonical.com>
X-Spam-Relay-Country: **
Subject: Re: [PATCH 01/15] add Documentation/namespaces/user_namespace.txt (v3)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> "Serge E. Hallyn" <serge.hallyn@canonical.com> writes:
>
>> Quoting Vasiliy Kulikov (segoon@openwall.com):
>>> On Tue, Sep 27, 2011 at 08:21 -0500, Serge E. Hallyn wrote:
>>> > > First, the patches by design expose much kernel code to unprivileged
>>> > > userspace processes.  This code doesn't expect malformed data (e.g. VFS,
>>> > > specific filesystems, block layer, char drivers, sysadmin part of LSMs,
>>> > > etc. etc.).  By relaxing permission rules you greatly increase attack
>>> > > surface of the kernel from unprivileged users.  Are you (or somebody
>>> > > else) planning to audit this code?
>
> Well in theory this codes does expose this code to unprivileged user
> space in a way that increases the attack surface.    However right now
> there are a lot of cases where because the kernel lacks a sufficient
> mechanism people are just given root provileges so that can get things
> done.  Network manager controlling the network stack as an unprivileged
> user.  Random filesystems on usb sticks being mounted and unmounted
> automatically when the usb sticks are inserted and removed.
>
> I completely agree that auditing and looking at the code is necessary I
> think most of what will happen is that we will start directly supporting
> how the kernel is actually used in the real world.  Which should
> actually reduce our level of vulnerability, because we give up the
> delusion that large classes of operations don't need careful
> attention because only root can perform them.   Operations which the
> user space authors turn around and write a suid binary for and
> unprivileged user space performs those operations all day long.
>
>>> > I had wanted to (but didn't) propose a discussion at ksummit about how
>>> > best to approach the filesystem code.  That's not even just for user
>>> > namespaces - patches have been floated in the past to make mount an
>>> > unprivileged operation depending on the FS and the user's permission
>>> > over the device and target.
>>> 
>>> This is a dangerous operation by itself.
>>
>> Of course it is :)  And it's been a while since it has been brought up,
>> but it *was* quite well thought through and throrougly discussed - see
>> i.e. https://lkml.org/lkml/2008/1/8/131
>>
>> Oh, that's right.  In the end the reason it didn't go in had to do with
>> the ability for an unprivileged user to prevent a privileged user from
>> unmounting trees by leaving a busy mount in a hidden namespace.
>>
>> Eric, in the past we didn't know what to do about that, but I wonder
>> if setns could be used in some clever way to solve it from userspace.
>
> Oh.  That is a good objection.  I had not realized that unprivileged
> mounts had that problem.

I just re-read the discussion you are referring to and that wasn't
it.  Fuse already has something like a revoke in it's umount -f
implementation.

Eric
