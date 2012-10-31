Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab2JaFz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 01:55:56 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63911 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab2JaFzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 01:55:53 -0400
Date: Tue, 30 Oct 2012 22:55:49 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca
Subject: Re: [PATCH] Input: select INPUT_MATRIXKMAP for lpc32xx-keys
Message-ID: <20121031055549.GE31983@core.coreip.homeip.net>
References: <1351323648-18645-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351323648-18645-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2012 at 09:40:48AM +0200, Roland Stigge wrote:
> This patch adds a "select" dependency of KEYBOARD_LPC32XX on INPUT_MATRIXKMAP,
> as the other drivers are doing in this regard. This fixes the following compile
> error if KEYBOARD_LPC32XX is enabled but INPUT_MATRIXKMAP is not:
> 
> drivers/input/keyboard/lpc32xx-keys.c:230: undefined reference to
> `matrix_keypad_build_keymap'
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Applied, thank you Roland.

> 
> ---
>  drivers/input/keyboard/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-2.6.orig/drivers/input/keyboard/Kconfig
> +++ linux-2.6/drivers/input/keyboard/Kconfig
> @@ -335,6 +335,7 @@ config KEYBOARD_LOCOMO
>  config KEYBOARD_LPC32XX
>  	tristate "LPC32XX matrix key scanner support"
>  	depends on ARCH_LPC32XX && OF
> +	select INPUT_MATRIXKMAP
>  	help
>  	  Say Y here if you want to use NXP LPC32XX SoC key scanner interface,
>  	  connected to a key matrix.

-- 
Dmitry
