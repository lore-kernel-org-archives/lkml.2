Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab0LOQHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:07:31 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43934 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab0LOQHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:07:25 -0500
Date: Wed, 15 Dec 2010 16:07:00 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Brown <davidb@codeaurora.org>
Cc: Pavel Machek <pavel@ucw.cz>, Jeff Ohlstein <johlstei@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>
Subject: Re: [PATCH 1/5] msm: Secure Channel Manager (SCM) support
Message-ID: <20101215160700.GB9937@n2100.arm.linux.org.uk>
References: <1291619778-30289-1-git-send-email-johlstei@codeaurora.org> <1291619778-30289-2-git-send-email-johlstei@codeaurora.org> <20101215074811.GA2483@ucw.cz> <20101215140558.GA9736@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101215140558.GA9736@huya.qualcomm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 06:05:58AM -0800, David Brown wrote:
> On Wed, Dec 15, 2010 at 08:48:11AM +0100, Pavel Machek wrote:
> 
> > > +static u32 smc(dma_addr_t cmd_addr)
> > > +{
> > > +	int context_id;
> > > +	register u32 r0 asm("r0") = 1;
> > > +	register u32 r1 asm("r1") = (u32)&context_id;
> > > +	register u32 r2 asm("r2") = (u32)cmd_addr;
> > 
> > Are these neccessary?
> 
> The values have to be in specific registers.  Without them it doesn't
> generate the right code.
...
> > > +	int context_id;
> > > +	static u32 version = -1;
> > > +	register u32 r0 asm("r0") = 0x1 << 8;
> > > +	register u32 r1 asm("r1") = (u32)&context_id;
> > 
> > And does this even work?
> 
> In what sense?  It generates the desired code.

What you're doing is entirely valid and supported by gcc.  There's no
problem with it.

> > > +	mutex_lock(&scm_lock);
> > > +	asm(
> > > +		__asmeq("%0", "r1")
> > > +		__asmeq("%1", "r0")
> > > +		__asmeq("%2", "r1")

And even if you use an older gcc version where this trips over bugs,
these asmeq() will save you from having silently generated wrong code.

So don't worry about this, you're not doing anything wrong.
