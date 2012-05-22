Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417Ab2EVLQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 07:16:13 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5344 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758219Ab2EVLQM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 07:16:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 22 May 2012 04:16:05 -0700
Date: Tue, 22 May 2012 14:15:32 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: "Turquette, Mike" <mturquette@ti.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Clock register in early init
Message-ID: <20120522111532.GH8730@tbergstrom-lnx.Nvidia.com>
References: <1337227884.2066.9.camel@pgaikwad-dt2>
 <20120517062131.GA9305@gmail.com>
 <1337316517.22560.19.camel@pgaikwad-dt2>
 <20120518112104.GL20304@tbergstrom-lnx.Nvidia.com>
 <CAJOA=zM_o1Nqw55xxFvw6KssM50Q+7yyo41rUSH2Aoo1neTMjg@mail.gmail.com>
 <20120521084642.GV20304@tbergstrom-lnx.Nvidia.com>
 <CAJOA=zNoj1nZ+zVURfhziqFem4F7_Y_B8s=Gp1Aptr0hgfj6Xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAJOA=zNoj1nZ+zVURfhziqFem4F7_Y_B8s=Gp1Aptr0hgfj6Xw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 08:05:57PM +0200, Turquette, Mike wrote:
> On Mon, May 21, 2012 at 1:46 AM, Peter De Schrijver
> <pdeschrijver@nvidia.com> wrote:
> >>
> >> On OMAP I think the only "gotcha" is setting up the timer.  One
> >> solution is to open code the register reads and the rate calculation
> >> in the timer code.  That is ugly... but it works.
> >>
> >> > Which advantages do you see in dynamically allocating all this?
> >> >
> >>
> >> There are many but I'll name a couple.  The most significant point is
> >> that we can avoid exposing the definition of struct clk if we
> >> dynamically allocate stuff.  One can use struct clk_hw_init to
> >> statically initialize data, or instead rely on direct calls to
> >> clk_register with a bunch of parameters.
> >>
> >
> > Which means if you make a mistake in specifying parents for example, it will
> > only fail at runtime, possibly before any console is active. With static
> > initialization, this will fail at compiletime. Much easier to debug.
> >
> 
> Is this really a problem?  Once you have good data it does not change.
>  Debugging bad data when introducing a new chip is just a fact of
> life.  Static versus dynamic is irrelevant here.
> 

I think it is a problem yes, especially when the tree becomes more
complicated.

Cheers,

Peter.
