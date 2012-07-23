Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab2GWTEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 15:04:24 -0400
Received: from fieldses.org ([174.143.236.118]:55283 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280Ab2GWTEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 15:04:23 -0400
Date: Mon, 23 Jul 2012 15:04:22 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: Re: Remove easily user-triggerable BUG from generic_setlease
Message-ID: <20120723190422.GA2703@fieldses.org>
References: <20120713173536.GB25432@redhat.com>
 <CA+55aFyg7Cs5KF4HGQKAUi29+RpXJdUyEm6uy57rwVBB_jyN3Q@mail.gmail.com>
 <20120723152038.GB623@fieldses.org>
 <CA+55aFxGuoxbdxy3uKX063vZ1xSRhshRyWf_UhMnDL_by7j9Sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxGuoxbdxy3uKX063vZ1xSRhshRyWf_UhMnDL_by7j9Sg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 11:34:56AM -0700, Linus Torvalds wrote:
> On Mon, Jul 23, 2012 at 8:20 AM, J. Bruce Fields <bfields@fieldses.org> wrote:
> >
> > So we need something like the following, backported to 2.6.anything.
> 
> Please add a note about the 3.2+ version of this patch (well, totally
> different patch), and why this particular patch isn't needed there.
> 
> For stable, we should always have a pointer to the patch in mainline,
> and if mainline has a different solution, and note about *why*
> mainline has that different solution.

Right, I wasn't clear: that patch should go to mainline as well.

(Then, do we still want Dave's patch?: in some sense that BUG() was
correct, as the code was obviously intended to catch illegal values
earlier.  And having the BUG() means we found the problem quickly
instead of having to track down memory corruption.  On the other hand,
agreed that BUG()'ing under a spin lock is cruel.  Maybe we should stick
a WARN there if it's not overkill.)

--b.
