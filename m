Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab0FFQgb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 12:36:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:48242 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab0FFQga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 12:36:30 -0400
Date: Sun, 6 Jun 2010 17:36:24 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>
Subject: Re: [RFC] Try a bit harder to get output on the screen at panic
 time
In-Reply-To: <20100519173449.6babbdfa@virtuousgeek.org>
Message-ID: <alpine.LFD.2.00.1006061734060.1320@casper.infradead.org>
References: <20100409151050.74ef6dcd@virtuousgeek.org> <20100519173449.6babbdfa@virtuousgeek.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Fri, 9 Apr 2010 15:10:50 -0700
> Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> > This set of 3 patches makes it a little more likely we'll get panic
> > output onto the screen even when X is running, assuming a KMS enabled
> > stack anyway.
> > 
> > It gets me from a blank or very sparsely populated black screen at
> > panic time, to one including the full backtrace and panic output at
> > panic time (tested with "echo c > /proc/sysrq-trigger" from an X
> > session).
> > 
> > It doesn't cover every case; for instance I think it'll fail when X has
> > disabled the display, but those cases need to be handled with separate
> > patches anyway (need to add atomic DPMS paths for instance).
> > 
> > Anyway, please test these out and let me know if they work for you.
> 
> Ping Linus & Dave again.  Have you guys tried these?  Really, it's cool.

Is this safe with UMS and vgacon/sticon? With a oops while using vgacon 
you can now touch the hardware buffer while not in vga text mode. 
