Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab2AaTSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 14:18:54 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51925 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab2AaTSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 14:18:53 -0500
Date: Tue, 31 Jan 2012 19:18:22 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Jiri Slaby <jslaby@suse.cz>,
        Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        systemd-devel@lists.freedesktop.org
Subject: Re: sysfs regression: wrong link counts
Message-ID: <20120131191822.GP23916@ZenIV.linux.org.uk>
References: <4F27120A.4040106@suse.cz>
 <20120130220611.GA26655@kroah.com>
 <20120130221059.26ab5edf@pyramind.ukuu.org.uk>
 <20120130222717.GA6393@kroah.com>
 <m18vkoirv9.fsf@fess.ebiederm.org>
 <4F27C6EB.2070305@suse.cz>
 <m14nvc82jo.fsf@fess.ebiederm.org>
 <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 08:45:58AM -0800, Linus Torvalds wrote:
> We can *try* the kernel change, but I can already tell you that
> anybody who thinks that "sensors will be fixed by all users by the
> time the kernel comes out" is likely totally full of shit. Not to
> mention that it apparently *already* causes problems for people who
> want to test -next, and this breaks those peoples setup, and thus
> means that -next gets less testing.
> 
> Really. "It's a bug in user space" is *NOT* an excuse for breaking
> things. Never was. Never is. There are (other) excuses for breaking
> things, but "user space did something I didn't expect it to do, and I
> consider it a bug" is absolutely not one of them.

It's actually "user space did something utterly weird that happened not
to break with the current behaviour by accident", and yes, it's better
to revert that change for the reasons you've described.  But it's
definitely a userland bug - as in "code doesn't do what it intends to
do" and no matter what we do kernel-side it ought to be fixed in
lm-sensors.  Several years later it hopefully will become a non-issue
(and we'll need to document the conflict with lm-sensors earlier than
$FIXED_VERSION in Documentation/Changes when that sysfs patch finally
goes in).
