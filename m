Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab2JIEwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 00:52:20 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:44764 "EHLO
	sivan.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab2JIEwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 00:52:17 -0400
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Oct 2012 00:52:17 EDT
Date: Tue, 9 Oct 2012 06:42:01 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Fabio Estevam <festevam@gmail.com>
Cc: kernel@pengutronix.de, Fabio Estevam <fabio.estevam@freescale.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        FlorianSchandinat@gmx.de
Subject: Re: [PATCH v2] video: imxfb: Do not crash on reboot
Message-ID: <20121009044201.GA4640@sapphire.tkos.co.il>
References: <1349735038-19196-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349735038-19196-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,

On Mon, Oct 08, 2012 at 07:23:58PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Issuing a "reboot" command after the LCD times out causes the following
> warnings:

[snip]

> @@ -513,47 +514,53 @@ static void imxfb_exit_backlight(struct imxfb_info 
> *fbi)
>  
>  static void imxfb_enable_controller(struct imxfb_info *fbi)
>  {
> -	pr_debug("Enabling LCD controller\n");
> +	if (!fbi->enabled) {
> +		pr_debug("Enabling LCD controller\n");

Won't it be simpler to just do:

    if (fbi->enabled)
        return;

instead of adding another nesting level to the whole routine?

>  static void imxfb_disable_controller(struct imxfb_info *fbi)
>  {
> -	pr_debug("Disabling LCD controller\n");
> +	if (fbi->enabled) {
> +		pr_debug("Disabling LCD controller\n");

ditto (with inverted logic).

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
