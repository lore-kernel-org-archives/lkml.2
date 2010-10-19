Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab0JSHTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 03:19:55 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38227 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab0JSHTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 03:19:54 -0400
Date: Tue, 19 Oct 2010 09:19:51 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Ian Molton <ian@mnementh.co.uk>, Magnus Damm <damm@opensource.se>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd/tc6393xb: don't use devinit data from non-init
	function
Message-ID: <20101019071951.GB23839@pengutronix.de>
References: <1267546953-19319-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1267546953-19319-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Mar 02, 2010 at 05:22:33PM +0100, Uwe Kleine-König wrote:
> tc6393xb_mmc_resources (which was marked __devinitdata) is used in
> tc6393xb_mmc_enable() and tc6393xb_mmc_resume() which both are functions
> living in .text.  This is not save with CONFIG_HOTPLUG=n.
> 
> This was introduced in
> 
> 	64e8867 (mfd: tmio_mmc hardware abstraction for CNF area)
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Ian Molton <ian@mnementh.co.uk>
> Cc: Magnus Damm <damm@opensource.se>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
ping

Uwe
> ---
>  drivers/mfd/tc6393xb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
> index 4bc5a08..b057d8d 100644
> --- a/drivers/mfd/tc6393xb.c
> +++ b/drivers/mfd/tc6393xb.c
> @@ -154,7 +154,7 @@ static struct resource __devinitdata tc6393xb_nand_resources[] = {
>  	},
>  };
>  
> -static struct resource __devinitdata tc6393xb_mmc_resources[] = {
> +static struct resource tc6393xb_mmc_resources[] = {
>  	{
>  		.start	= 0x800,
>  		.end	= 0x9ff,
> -- 
> 1.7.0
> 
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
