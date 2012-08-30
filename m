Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab2H3QfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 12:35:25 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43170 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab2H3QfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 12:35:22 -0400
Message-ID: <503F9191.20209@landley.net>
Date: Thu, 30 Aug 2012 11:15:13 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "Theodore Ts'o" <tytso@mit.edu>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Ludwig Nussel <ludwig.nussel@suse.de>,
        Alessandro Rubini <rubini@gnudd.com>, linux-doc@vger.kernel.org
Subject: Re: Hardening debugfs (Was Re: [PATCH] debugfs: more tightly restrict
 default mount mode)
References: <20120827203215.GA16637@www.outflux.net> <20120828144110.GA23035@thunk.org> <503D4C71.9040501@landley.net> <20120829040935.GB21265@kroah.com>
In-Reply-To: <20120829040935.GB21265@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2012 11:09 PM, Greg Kroah-Hartman wrote:
> On Tue, Aug 28, 2012 at 05:55:45PM -0500, Rob Landley wrote:
>> I've always been a bit confused by the debugfs design, which seems a
>> giant compost heap like /proc where we find a specific styrofoam cup
>> useful and the temporary thing becomes permanent. (Why is there _one_
>> debugfs?)
> 
> The rules for debugfs are very simple:
> 	There are no rules.
> 
> That's it.  It's up to the kernel developer to do what they need to do,
> for debugging stuff, how ever they best see fit.

Emergent de-facto standards with no review or versioning or anything,
check. It's the "every driver in the system shares a common resource
with no arbitration or guidelines" thing that I have trouble with.

Is it possible to have multiple instances of this filesystem? If so, can
they have -o "modulename,modulename,modulename..." so that only certain
modules' files get put in this instance?

I understand that /sys/module/$BLAH has rules and we can't have that,
but having a giant slush pile and asserting it won't become a new /proc
because reasons makes me nervous.

For example, ftrace is already built on top of debugfs. If debugfs has
no rules, but ftrace does, can another module put stuff in "tracing"? If
a stable API isn't important, will we start bundling whatever userspace
tools ftrace needs in with the kernel, along with udev/systemd? Or is
the position that ftrace will never have non-debugging uses, just like
ptrace?

> Yes, it replaces proc for all of the debugging stuff that shouldn't have
> been there before, how it's structured, is up to the developer adding
> the code.

For a definition of "replaces" that does not actually remove any of the
existing entries from /proc. (That garbage can's full, here's a new one?)

The problem with /proc is that lots of things used it for different
purposes with no rules. The goal of debugfs is to provide something that
lots of things use for different purposes, explicitly with no rules.

I'm just wondering why it's a big common hairball instead of separate
per-module filesystems. (Other than "Linux will never have a unionfs
because the perfect is the enemy of the good".)

Eh, it's your thing, not mine. I just don't understand it.

> greg k-h

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
