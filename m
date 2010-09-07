Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab0IGCvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 22:51:17 -0400
Received: from thunk.org ([69.25.196.29]:50465 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755744Ab0IGCvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 22:51:12 -0400
Date: Mon, 6 Sep 2010 22:51:10 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org, Paolo Ornati <ornati@gmail.com>
Subject: Re: help with git bisecting a bug 16376: random - possibly Radeon
 DRM KMS related - freezes
Message-ID: <20100907025110.GD6134@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Martin Steigerwald <Martin@lichtvoll.de>,
	linux-kernel@vger.kernel.org, Paolo Ornati <ornati@gmail.com>
References: <201008312153.45792.Martin@lichtvoll.de>
 <20100901204716.775e9cfd@gmail.com>
 <201009050953.52440.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009050953.52440.Martin@lichtvoll.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 05, 2010 at 09:53:41AM +0200, Martin Steigerwald wrote:
> 
> Quite some kernels were unbootable with an ext4 and readahead related 
> backtrace[1]. 

Unfortunately, you don't have a full backtrace in the picture which
submitted as an attachment to the bugzilla.  It shows part of the
backtrace which has an ext4 and readahead stack, yes.  But we didn't
get to see the beginning of the stack trace with the IP and the reason
for the oops.  If keyboard interrupts still work, you might try seing
if you can scroll upwards and see more of the backtrace.  Or you might
try configuring your console to use a higher resolution display so
more lines can be displayed.  Or you might try getting a serial
console.

I don't recognize the display, but the problem could just as easily be
in the block layer or in the device driver for your hard drive.
(i.e., the readahead stack calls ext4, which in turn will submit a
read request to the block device layer which then submits the request
to a device driver).

But because you keep referring it to it as an ext4/readahead related
backtrace, you may have disguised the symptom enough that people who
might recognize it as, "Oh, yeah, there was this regression in the
SATA layer", wouldn't recognize it as such from your description.
That's why it's important to be careful how you describe issues; if
you had said, I don't have a complete stack trace, and I don't have
the IP and function where the fault occurred, that might have caused
people to think a bit harder about what might be the problem, instead
of thinking to themselves, "ah, well, the ext4 and readahead parts of
the kernel aren't my problem, so I'll ignore this report".

> I am also seeking help with selecting more suitable commits to test: If 
> its a Radeon KMS related freeze and everything points at it, I think the 
> offending commit is in the first quarter of what git commit shows to me[2]. 

You do know that you can restrict a git bisect to commits that modify
a particular part of the tree, right?  e.g.,

git bisect start 2.6.34 2.6.33 -- drivers/gpu/drm/radeon

					- Ted
