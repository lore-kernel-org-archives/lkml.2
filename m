Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab1AXUF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 15:05:26 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47241 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab1AXUFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 15:05:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mN1d2BI0JKBW7Rio7ODLTqWCIsklxOe1zTg7UbKnbrb8IpAs0c+xcEjH4On/26JPw4
         IM4WjyoUmpBcD413DWIpKwYFhC1qvZlB4afOy+8/ls4nS93YL/qKPjct5xxUO86oUVOO
         kaWHS4pb1RX4UL5RkA5BzQRBLBPj0WEp7HT6A=
Date: Mon, 24 Jan 2011 23:05:17 +0300
From: Vasiliy Kulikov <segooon@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: Ryan Mallon <ryan@bluewatersys.com>, Russell King <linux@arm.linux.org.uk>,
        kernel-janitors@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] arch/arm/mach-at91/clock.c: Add missing IS_ERR test
Message-ID: <20110124200515.GA30963@albatros>
References: <1295898922-18822-1-git-send-email-julia@diku.dk>
 <1295898922-18822-3-git-send-email-julia@diku.dk>
 <4D3DD964.9020107@bluewatersys.com>
 <Pine.LNX.4.64.1101242058430.3167@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1101242058430.3167@ask.diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 21:00 +0100, Julia Lawall wrote:
> On Tue, 25 Jan 2011, Ryan Mallon wrote:
> 
> > On 01/25/2011 08:55 AM, Julia Lawall wrote:
> > > @@ -224,7 +224,7 @@ void __init at91_clock_associate(const char *id, struct device *dev, const char
> > >  {
> > >  	struct clk *clk = clk_get(NULL, id);
> > >  
> > > -	if (!dev || !clk || !IS_ERR(clk_get(dev, func)))
> > > +	if (!dev || IS_ERR(clk) || !IS_ERR(clk_get(dev, func)))
> > >  		return;
> > 
> > I think we want:
> > 
> > 	if (!dev || !clk || IS_ERR(clk) || !IS_ERR(clk_get(dev, func)))
> > 		return;
> > 
> > Since it is valid to return a NULL clk, and we don't want to try and
> > dereference it if that is the case.
> 
> Looking at the given defintion of clk_get, I can't see how that could 
> happen:

clk_get() is defined per-architecture, sometimes it is NULL only.

> struct clk *clk_get(struct device *dev, const char *id)
> {
>         struct clk *clk;
> 
>         list_for_each_entry(clk, &clocks, node) {
>                 if (strcmp(id, clk->name) == 0)
>                         return clk;
>                 if (clk->function && (dev == clk->dev) && strcmp(id, clk->function) == 0)
>                         return clk;
>         }
> 
>         return ERR_PTR(-ENOENT);
> }
> 
> Both paths to the non-ERR_PTR return dereference clk.
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Vasiliy
