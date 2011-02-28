Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab1B1PCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:02:40 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63379 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab1B1PCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:02:39 -0500
Date: Mon, 28 Feb 2011 15:01:49 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: John Linn <John.Linn@xilinx.com>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        catalin.marinas@arm.com, glikely@secretlab.ca, arnd@arndb.de
Subject: Re: [PATCH V4 3/4] ARM: Xilinx: base header files and assembly macros
Message-ID: <20110228150149.GG2754@pulham.picochip.com>
References: <1298052881-14591-1-git-send-email-john.linn@xilinx.com>
 <1298052881-14591-2-git-send-email-john.linn@xilinx.com>
 <1298052881-14591-3-git-send-email-john.linn@xilinx.com>
 <42efee69-aca1-446b-a997-f0063e113877@VA3EHSMHS009.ehs.local>
 <20110228111839.GA9206@pulham.picochip.com>
 <0f644016-95cf-4fcb-853d-fb20bee31908@VA3EHSMHS013.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f644016-95cf-4fcb-853d-fb20bee31908@VA3EHSMHS013.ehs.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 07:20:32AM -0700, John Linn wrote:
[...]
> > > +
> > > +static inline void flush(void)
> > > +{
> > > +	u32 status;
> > > +	/*
> > > +	 * Wait while the FIFO is not empty
> > > +	 */
> > > +	while (1) {
> > > +		status = __raw_readl(IOMEM(LL_UART_PADDR +
> UART_SR_OFFSET));
> > > +		if (status & UART_SR_TXEMPTY)
> > > +			break;
> > > +		cpu_relax();
> > > +	}
> > 
> > This could be written as:
> > 
> > static inline void flush(void)
> > {
> > 	while (!(__raw_readl(IOMEM(LL_UART_PADDR + UART_SR_OFFSET)) &
> > 		 UART_SR_TXEMPTY))
> > 		 cpu_relax();
> > }
> 
> Honestly I had it that way as I know most in the community do that and
> terse-ness is somewhat preferred.
> 
> I thought my way is a bit clearer as it was a bit harder to read the
> other way.
> 
> Do you think everyone else would say to change it?  No big deal to
> change it.

I guess it's largely down to personal preference.  Personally I find the 
infinite loop with conditional break harder to read but then I'm not 
going to the the primary maintainer ;-)

Jamie
