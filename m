Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab1ASRiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 12:38:13 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49297 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab1ASRiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 12:38:11 -0500
Date: Wed, 19 Jan 2011 17:37:39 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: David Brown <davidb@codeaurora.org>
Cc: Jamie Iles <jamie@jamieiles.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, rlove@google.com
Subject: Re: [PATCH 2/2] serial: msm: Add support for UARTDM cores
Message-ID: <20110119173739.GE3341@pulham.picochip.com>
References: <1295407585-18386-1-git-send-email-stepanm@codeaurora.org>
 <20110119082534.GA9569@gallagher>
 <8yaaaiwsstw.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8yaaaiwsstw.fsf@huya.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 09:31:55AM -0800, David Brown wrote:
> On Wed, Jan 19 2011, Jamie Iles wrote:
> 
> >> @@ -38,9 +40,20 @@ struct msm_port {
> >>  	struct uart_port	uart;
> >>  	char			name[16];
> >>  	struct clk		*clk;
> >> +	struct clk		*pclk;
> >>  	unsigned int		imr;
> >> +	unsigned int            *gsbi_base;
> >> +	int			is_dm;
> >> +	unsigned int		old_snap_state;
> >>  };
> >
> > Out of interest, what does .is_dm mean?  Is that obvious to someone who 
> > knows about msm?
> 
> It would be clear to people rather familiar with the chip, but I agree
> it's probably not that clear of a name.
> 
> We have two UART blocks we use in the MSMs, the older one, supported by
> this driver before this change, and a newer one that was designed to
> work with our DMA engine (known as the Data Mover, or dm).  This newer
> UART can be used in a somewhat compatible manner when being used for
> serial-port type operations.
> 
> I'm not sure what would be a better name for the flag, though.  The
> block is called UARTDM.

Ok, it was mainly out of curiosity.  I guess it could be 'use_dma' or 
perhaps a comment to explain what DM is but my curiosity is now 
satisfied ;-)

Jamie
