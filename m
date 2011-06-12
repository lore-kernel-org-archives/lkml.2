Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab1FLPe7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 11:34:59 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:49759 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab1FLPeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 11:34:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>, James Morris <jmorris@namei.org>
References: <1306930476-1899-1-git-send-email-lucas.demarchi@profusion.mobi>
	<BANLkTin6CP-A+UsGXyu9wb7U34wEN7DKsw@mail.gmail.com>
	<m18vtkq57c.fsf@fess.ebiederm.org>
	<BANLkTimcPweT-HONEtVDn3mD2a6dUGDEYA@mail.gmail.com>
	<20110602134338.0c56160e@lxorguk.ukuu.org.uk>
	<BANLkTik72cU_R5k9NLnqN_FNkm-y5Fk0nQ@mail.gmail.com>
	<m1hb88e3qs.fsf@fess.ebiederm.org>
	<BANLkTin5P8P_HR78qo0oyzeu9hpWazZqTw@mail.gmail.com>
Date: Sun, 12 Jun 2011 08:34:31 -0700
In-Reply-To: <BANLkTin5P8P_HR78qo0oyzeu9hpWazZqTw@mail.gmail.com> (Kay
	Sievers's message of "Thu, 2 Jun 2011 19:32:49 +0200")
Message-ID: <m14o3vukqg.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/lpJpKAv7oKPo5q/bb/nzxhYYw/B9Ms1w=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kay Sievers <kay.sievers@vrfy.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] sysctl: add support for poll()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay.sievers@vrfy.org> writes:

> On Thu, Jun 2, 2011 at 15:56, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Lucas De Marchi <lucas.demarchi@profusion.mobi> writes:
>
>>> With this patch in, if anyone wants to manage a file under /proc/sys
>>> there's really a small amount of code to write. He only has to define
>>> the new poll struct for that file.
>>
>> The support currently appears cumbersome to add, and it adds what appear
>> to be unnecessary wake ups (say when the hostname in another uts
>> namespace changes).
>
> Yeah, *possibly* waking up once a day compared to *unconditionally*
> waking up every second in every namespace and check if something has
> changed. If that *possibly* should be optimized, which I think isn't
> necessary at all, I guess the logic could be moved down to the
> namespaced data.

Unless you happen to be on a system, where someone has decided that it
has a daemon that likes creating a new set of namespaces per connection
to reduce the effect of code bugs.  At which point you could be talking
much more than a wake up per second.

>> There is no explanation at all of why you care about the nis domainname.
>
> Just the same reason as the hostname, we need to know when the
> kernel's internal state changes. regardless who did it and why, system
> services need to follow it.

So the problem is that you have a system where userspace can't get it's
act together?

>> Since there does not appear to be a specific problem that this problem
>> is being aimed at, since the code just looks like extra maintenance and
>> since the code needed to support this appears to be unnecessarily
>> cumbersome I am going to nack the patch for now.
>>
>> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> Please provide solid technical reasons, why we can't to the same we do
> everywhere else since years, or provide working alternatives. Until
> then:
>
> Acked-By: Kay Sievers <kay.sievers@vrfy.org>

Looking a little closer the patch is broken.

It changes the return of poll for every file under /proc/sys reporting
no file under /proc/sys is writable unless it implements the new poll
method.

Also with having the wait_queue owned by the calling code either I am
mistake or this breaks hotplug type situations.  How do you get things
off of your wait queue when you remove a file from /proc/sys.  This
infrastructure as written looks like a setup for use after free
problems.

> I think poll() is the natural interface if you care about the data in
> a file. It's the same an single fd you care, and not some iniotify
> watch, fd, pathname to register, and filter for whatever comes out
> there.

Sort of.  poll is really designed for socket and pipe data.

The problem with poll is there is no POLLUPDATED.

> We already use exactly the same semantics for quite some years for
> /proc/mounts, /proc/swaps, /proc/mdstat, ... and all over /sys. The
> patch just provides the missing pieces that /proc provides, but
> /proc/sys is missing.

Good point.

There is still the problem that the infrastructure code for the proc
sysctl files are in much worse shape than the sysfs files.

> I don't disagree, it might be nice to have generic inotify support on
> /proc for this or other problems. But unless you want to work on it
> now, and it would solve these problems, I don't see how we can get the
> functionality we need, and that seems to solved with this patch.
> Besides the fact that I think poll() is the simple and better
> solution.

Which is a question that has never been answered.  What functionality
do you need?  To me this all looks like a bad science experiment.

Eric
