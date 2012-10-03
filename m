Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082Ab2JCX6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 19:58:42 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:53680 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932871Ab2JCX6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 19:58:41 -0400
Date: Wed, 3 Oct 2012 19:58:34 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Matthias Schniedermeyer <ms@citd.de>
Cc: Kees Cook <kees@outflux.net>, Nick Bowler <nbowler@elliptictech.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.6
Message-ID: <20121003235834.GA29174@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Matthias Schniedermeyer <ms@citd.de>, Kees Cook <kees@outflux.net>,
	Nick Bowler <nbowler@elliptictech.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFw1Y5_HtfXh+-OEQ2KGpW0N18kA4O3R7=cv29_CaF+3UQ@mail.gmail.com>
 <20121003194614.GA2893@elliptictech.com>
 <20121003200515.GZ9092@outflux.net>
 <20121003222341.GA20263@citd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003222341.GA20263@citd.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 12:23:41AM +0200, Matthias Schniedermeyer wrote:
> Personally i would have been bitten by this change, because for years i 
> have used a symlink in /tmp (which has the sticky bit) to a directory 
> somewhere else for historical reasons. But as i was aware of this change 
> i fixed my system before booting the new kernel.

As long as you own the symlink, it wouldn't be a problem.  The problem
comes when the symlink is owned by some user such as
"untrusted_daemon", which could change where the symlink could point
at any any time --- or could create a new symlink where none had
previously existed in some world-writeable directory such as /tmp.

Now you try to use that symlink, assuming that it points to *foo*,
when in fact it now points to *bar*, and hilarity ensues...

						- Ted
