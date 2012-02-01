Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596Ab2BAFEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 00:04:12 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:49248 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab2BAFEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 00:04:10 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Greg KH <greg@kroah.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        systemd-devel@lists.freedesktop.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: sysfs regression: wrong link counts
References: <4F27120A.4040106@suse.cz> <20120130220611.GA26655@kroah.com>
	<20120130221059.26ab5edf@pyramind.ukuu.org.uk>
	<20120130222717.GA6393@kroah.com> <m18vkoirv9.fsf@fess.ebiederm.org>
	<4F27C6EB.2070305@suse.cz> <m14nvc82jo.fsf@fess.ebiederm.org>
	<CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
Date: Tue, 31 Jan 2012 21:06:46 -0800
In-Reply-To: <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
	(Linus Torvalds's message of "Tue, 31 Jan 2012 08:45:58 -0800")
Message-ID: <m1wr87ywex.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19m4nFJvLN9eXWfPJBo2/XlHTW2cNZNceE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Tue, Jan 31, 2012 at 4:44 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> The sensors update with the fix is scheduled for about a week out, well
>> before 3.3 ships.
>
> That's almost certainly *not* going to help.
>
> Guys, people don't update their user space. Some people run modern
> kernels on the enterprise distros - and those can be *years* out of
> date.
>
> If people report problems, we revert things. It's that simple. It
> really doesn't matter if you call it a user space bug or not - if user
> space depends on what we used to do, then we continue to do it.

> We can *try* the kernel change, but I can already tell you that
> anybody who thinks that "sensors will be fixed by all users by the
> time the kernel comes out" is likely totally full of shit. Not to
> mention that it apparently *already* causes problems for people who
> want to test -next, and this breaks those peoples setup, and thus
> means that -next gets less testing.

By and large I am in agreement with you, and this patch was designed to
be very focused in case we ran into userspace that had problems to make
it easy to revert.  The first question I asked when this was reported is
how badly do things break.  So I could tell if things needed to be
fixed.

My current understanding is that it is exactly sensors that breaks.
One program that complains loudly and doesn't function.

To the best of my knowledge nothing else fails, or depends on sensors.

I would like to have the code in -next a little longer to see if
anything else breaks.

> Really. "It's a bug in user space" is *NOT* an excuse for breaking
> things. Never was. Never is. There are (other) excuses for breaking
> things, but "user space did something I didn't expect it to do, and I
> consider it a bug" is absolutely not one of them.

Part of the reason for the patch is it is a partial regression fix for
sysfs using more memory in 3.3 and 3.2 than in previous kernels.
struct sysfs_dirent  is nowhere near as critical as struct page but the
same kind of small in structure size add up.

Thinking about it I should be able to whip up a tiny patch that adds
a Kconfig option.  Support for programs that are don't interpret nlinks
correctly.

That should allow people who want the size reduction to have a smaller
sysfs and it should allow people who are conservative to guarantee that
the code works, and it should let me find out if anything else out there
actually cares.

Eric
