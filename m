Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab2CSUQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:16:58 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:52288 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932371Ab2CSUQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:16:55 -0400
Message-ID: <4F679437.8030201@xenotime.net>
Date: Mon, 19 Mar 2012 13:16:55 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] net: qmi_wwan: fix build error due to cdc-wdm dependecy
References: <20120319184830.fce597a16eaf7206195a7a45@canb.auug.org.au> <1332179309-4163-1-git-send-email-bjorn@mork.no>
In-Reply-To: <1332179309-4163-1-git-send-email-bjorn@mork.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 10:48 AM, Bjørn Mork wrote:

> Fixes:
> 
> drivers/built-in.o: In function `qmi_wwan_bind_shared':
> qmi_wwan.c:(.text+0x25b686): undefined reference to `usb_cdc_wdm_register'
> make[1]: *** [.tmp_vmlinux1] Error 1
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Bjørn Mork <bjorn@mork.no>


Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.


> ---
> Thanks for noticing.
> 
> This should have been in commit c3ecb08a
>  net: qmi_wwan: support devices having a shared QMI/wwan interface
> 
> 
> Bjørn
> 
> 
>  drivers/net/usb/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
> index 4bad899..833e32f 100644
> --- a/drivers/net/usb/Kconfig
> +++ b/drivers/net/usb/Kconfig
> @@ -401,6 +401,7 @@ config USB_NET_KALMIA
>  config USB_NET_QMI_WWAN
>  	tristate "QMI WWAN driver for Qualcomm MSM based 3G and LTE modems"
>  	depends on USB_USBNET
> +	select USB_WDM
>  	help
>  	  Support WWAN LTE/3G devices based on Qualcomm Mobile Data Modem
>  	  (MDM) chipsets.  Examples of such devices are



-- 
~Randy
