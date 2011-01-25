Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab1AYLcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 06:32:13 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:59127 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176Ab1AYLb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 06:31:57 -0500
Date: Tue, 25 Jan 2011 12:31:55 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: walter harms <wharms@bfs.de>, Vasiliy Kulikov <segooon@gmail.com>,
        Ryan Mallon <ryan@bluewatersys.com>, kernel-janitors@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] arch/arm/mach-at91/clock.c: Add missing IS_ERR test
In-Reply-To: <20110125112641.GG11507@n2100.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.1101251231060.12123@pc-004.diku.dk>
References: <1295898922-18822-1-git-send-email-julia@diku.dk>
 <1295898922-18822-3-git-send-email-julia@diku.dk> <4D3DD964.9020107@bluewatersys.com>
 <Pine.LNX.4.64.1101242058430.3167@ask.diku.dk> <20110124200515.GA30963@albatros>
 <Pine.LNX.4.64.1101242108180.3167@ask.diku.dk> <4D3EA6EC.5050305@bfs.de>
 <20110125104333.GE11507@n2100.arm.linux.org.uk> <4D3EB02D.6090302@bfs.de>
 <Pine.LNX.4.64.1101251216190.12123@pc-004.diku.dk>
 <20110125112641.GG11507@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011, Russell King - ARM Linux wrote:

> On Tue, Jan 25, 2011 at 12:18:40PM +0100, Julia Lawall wrote:
> > On Tue, 25 Jan 2011, walter harms wrote:
> > > So these is a bug ? They should return -ENOENT ?
> > > 
> > > The interessting question is: what to do with an error ?
> > > 
> > > Obviously some architecture can live with NULL, so it is not an critical
> > > error. An the patch shows a code that is simply a return, not even the
> > > user is informed that something did not work as expected.
> > > 
> > > From that point of view i would like question if it is useful to have
> > > a "detailed" error instead of just returning NULL.
> > 
> > Somewhat unrelatedly, I often run into code where error handling code is 
> > needed, but not present, and the function returns void, so nothing is 
> > provided for propagating the error further.  I generally consider these 
> > cases to be beyond my expertise to fix...
> 
> That is a pain, but so is returning NULL in error conditions.  If you've
> got several layers of nesting, and every level returns NULL on error,
> it's an awful lot of debugging to find out _why_ a failure happened.
> 
> With error codes, it narrows down the number of places which could have
> returned that error code, and as error codes can be descriptive, it
> turns it into an "oh, I forgot about doing X" or "it's failing *there*"
> rather than a puzzle.
> 
> The only place where it really makes sense to return NULL is with memory
> allocators.  NULL is an accepted value for meaning "I couldn't allocate
> memory" as its not a useful pointer value.
> 
> The alternative is to have an API like:
> 
> 	struct clk *clk_get(int *error, ...)
> or
> 	int clk_get(struct clk **, ...)
> 
> but that then leads to _additional_ errors made by driver authors and by
> implementations - you can no longer guarantee that *error will always be
> initialized, and this is why the whole ERR_PTR/PTR_ERR/IS_ERR stuff was
> implemented.  The kernel used to have such things in it and they were
> buggy.

I agree that error codes are very useful.  The problem is rather how to 
propagate any sort of error indicator, whether ERR_PTR, NULL, an negative 
integer, etc.

julia
