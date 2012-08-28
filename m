Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab2H1Ol3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 10:41:29 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:47406 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab2H1Ol2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 10:41:28 -0400
Date: Tue, 28 Aug 2012 10:41:10 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, Rob Landley <rob@landley.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Ludwig Nussel <ludwig.nussel@suse.de>,
        Alessandro Rubini <rubini@gnudd.com>, linux-doc@vger.kernel.org
Subject: Hardening debugfs (Was Re: [PATCH] debugfs: more tightly restrict
 default mount mode)
Message-ID: <20120828144110.GA23035@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ben Hutchings <ben@decadent.org.uk>, Rob Landley <rob@landley.net>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Ludwig Nussel <ludwig.nussel@suse.de>,
	Alessandro Rubini <rubini@gnudd.com>, linux-doc@vger.kernel.org
References: <20120827203215.GA16637@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120827203215.GA16637@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 01:32:15PM -0700, Kees Cook wrote:
> Since the debugfs is mostly only used by root, make the default mount
> mode 0700. Most system owners do not need a more permissive value,
> but they can choose to weaken the restrictions via their fstab.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

I agree with this patch, but it would also be good if we could try to
harden debugfs in general.  Some ideas that might be worth discussing,
for example?

1) Adding a per-module flag, so things in debugfs only show up if they
are explicitly requested (you know, for debugging purposes).  If most
people are using debugfs for access to ftrace and powertap (my use
case), there's no point making directories for other device drivers
and file systems visible.

2) Can we find a pattern of common security #fail's with debugfs
files, and try to sweep through and fix them?

There may be other ideas, and again, I'm not saying that this means we
shouldn't lock down the permissions on debugfs.  But a both/and
approach might be useful here....

							- Ted
