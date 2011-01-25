Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab1AYLSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 06:18:48 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:40373 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769Ab1AYLSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 06:18:47 -0500
Date: Tue, 25 Jan 2011 12:18:40 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: walter harms <wharms@bfs.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Vasiliy Kulikov <segooon@gmail.com>,
        Ryan Mallon <ryan@bluewatersys.com>, kernel-janitors@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] arch/arm/mach-at91/clock.c: Add missing IS_ERR test
In-Reply-To: <4D3EB02D.6090302@bfs.de>
Message-ID: <Pine.LNX.4.64.1101251216190.12123@pc-004.diku.dk>
References: <1295898922-18822-1-git-send-email-julia@diku.dk>
 <1295898922-18822-3-git-send-email-julia@diku.dk> <4D3DD964.9020107@bluewatersys.com>
 <Pine.LNX.4.64.1101242058430.3167@ask.diku.dk> <20110124200515.GA30963@albatros>
 <Pine.LNX.4.64.1101242108180.3167@ask.diku.dk> <4D3EA6EC.5050305@bfs.de>
 <20110125104333.GE11507@n2100.arm.linux.org.uk> <4D3EB02D.6090302@bfs.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011, walter harms wrote:

> 
> 
> Am 25.01.2011 11:43, schrieb Russell King - ARM Linux:
> > On Tue, Jan 25, 2011 at 11:33:16AM +0100, walter harms wrote:
> >> Would it be more easy to return NULL in the error case of clk_get() instead
> >> of ERR_PTR(-ENOENT) ?
> >>
> >> So the default could be return NULL and an architecture depending solution
> >> replacing that.
> > 
> > That's not how the API is defined.  The API defines error-pointers to be
> > errors, everything should be considered valid.  Please don't go down the
> > route of doing something architecturally different from that.
> > 
> > What if, say, you couldn't return the struct clk because maybe it could
> > only be controlled by one user?  Returning an EBUSY error pointer would
> > indicate this condition.  What if the module providing the struct clk
> > hasn't finished initializing - that's another reason for EBUSY rather
> > than ENOENT.
> > 
> > Error codes are useful to describe why something failed.  NULL pointers
> > can't do that.
> > 
> 
> On Mon, 24 Jan 2011, Vasiliy Kulikov wrote:
> > 
> ...
> > clk_get() is defined per-architecture, sometimes it is NULL only.
> >
> 
> So these is a bug ? They should return -ENOENT ?
> 
> The interessting question is: what to do with an error ?
> 
> Obviously some architecture can live with NULL, so it is not an critical
> error. An the patch shows a code that is simply a return, not even the
> user is informed that something did not work as expected.
> 
> From that point of view i would like question if it is useful to have
> a "detailed" error instead of just returning NULL.

Somewhat unrelatedly, I often run into code where error handling code is 
needed, but not present, and the function returns void, so nothing is 
provided for propagating the error further.  I generally consider these 
cases to be beyond my expertise to fix...

julia
