Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab0KXAOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:14:14 -0500
Received: from dyn60-31.dsl.spy.dnainternet.fi ([83.102.60.31]:49262 "EHLO
	shogun.pilppa.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755334Ab0KXAON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:14:13 -0500
Date: Wed, 24 Nov 2010 02:14:07 +0200 (EET)
From: Mika Laitio <lamikr@pilppa.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH -mmotm] w1: fix ds2423 build, needs to select CRC16
In-Reply-To: <20101117212517.48069281.randy.dunlap@oracle.com>
Message-ID: <alpine.LMD.2.00.1011240208470.24087@shogun.pilppa.org>
References: <201011180135.oAI1Znl3017273@imap1.linux-foundation.org> <20101117212517.48069281.randy.dunlap@oracle.com>
User-Agent: Alpine 2.00 (LMD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for noticing the missing crc16 module selection, it's indeed 
needed if it's not for some other reason selected in the .config.

Mika

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix w1_ds2423 build:  needs to select CRC16.
> 
> w1_ds2423.c:(.text+0x9971d): undefined reference to `crc16'
> w1_ds2423.c:(.text+0x9973a): undefined reference to `crc16'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Mika Laitio <lamikr@pilppa.org>
> ---
>  drivers/w1/slaves/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- mmotm-2010-1117-1703.orig/drivers/w1/slaves/Kconfig
> +++ mmotm-2010-1117-1703/drivers/w1/slaves/Kconfig
> @@ -18,6 +18,7 @@ config W1_SLAVE_SMEM
>  
>  config W1_SLAVE_DS2423
>  	tristate "Counter 1-wire device (DS2423)"
> +	select CRC16
>  	help
>  	  If you enable this you can read the counter values available
>  	  in the DS2423 chipset from the w1_slave file under the
> 

-- 
Terveisin Mika
