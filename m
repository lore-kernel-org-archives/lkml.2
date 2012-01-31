Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab2AaQqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 11:46:20 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:32824 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab2AaQqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 11:46:18 -0500
MIME-Version: 1.0
In-Reply-To: <m14nvc82jo.fsf@fess.ebiederm.org>
References: <4F27120A.4040106@suse.cz> <20120130220611.GA26655@kroah.com>
 <20120130221059.26ab5edf@pyramind.ukuu.org.uk> <20120130222717.GA6393@kroah.com>
 <m18vkoirv9.fsf@fess.ebiederm.org> <4F27C6EB.2070305@suse.cz> <m14nvc82jo.fsf@fess.ebiederm.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 31 Jan 2012 08:45:58 -0800
X-Google-Sender-Auth: -xcYyc4YkyDSg2fLDbQDmq3MsdQ
Message-ID: <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
Subject: Re: sysfs regression: wrong link counts
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Greg KH <greg@kroah.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        systemd-devel@lists.freedesktop.org, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 4:44 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> The sensors update with the fix is scheduled for about a week out, well
> before 3.3 ships.

That's almost certainly *not* going to help.

Guys, people don't update their user space. Some people run modern
kernels on the enterprise distros - and those can be *years* out of
date.

If people report problems, we revert things. It's that simple. It
really doesn't matter if you call it a user space bug or not - if user
space depends on what we used to do, then we continue to do it.

We can *try* the kernel change, but I can already tell you that
anybody who thinks that "sensors will be fixed by all users by the
time the kernel comes out" is likely totally full of shit. Not to
mention that it apparently *already* causes problems for people who
want to test -next, and this breaks those peoples setup, and thus
means that -next gets less testing.

Really. "It's a bug in user space" is *NOT* an excuse for breaking
things. Never was. Never is. There are (other) excuses for breaking
things, but "user space did something I didn't expect it to do, and I
consider it a bug" is absolutely not one of them.

                       Linus
