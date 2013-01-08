Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab3AHQ2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 11:28:09 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:55801 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab3AHQ2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 11:28:08 -0500
Date: Tue, 8 Jan 2013 17:27:54 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: giometti@enneenne.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pps: hide more configuration symbols behind CONFIG_PPS
Message-ID: <20130108162754.GB7643@netboy.at.omicron.at>
References: <1357649962-14664-1-git-send-email-florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357649962-14664-1-git-send-email-florian@openwrt.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 01:59:22PM +0100, Florian Fainelli wrote:
> This patch makes CONFIG_PPS_DEBUG and CONFIG_NTP_PPS be hidden if
> CONFIG_PPS is not selected, such that we are not prompted for these
> configuration options if CONFIG_PPS is not set.
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>
> ---
>  drivers/pps/Kconfig |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/pps/Kconfig b/drivers/pps/Kconfig
> index 982d16b..dc19fb4 100644
> --- a/drivers/pps/Kconfig
> +++ b/drivers/pps/Kconfig
> @@ -21,6 +21,8 @@ config PPS
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pps_core.ko.
>  
> +if PPS
> +

If you add this "if" ...

>  config PPS_DEBUG
>  	bool "PPS debugging messages"
>  	depends on PPS

... then you should delete this redundant "depends".

Thanks,
Richard
