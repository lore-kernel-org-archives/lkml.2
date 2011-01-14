Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab1ANXY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 18:24:29 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63833 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab1ANXY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 18:24:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QC5vo37JxzMfuN52zIv0qQuKncZ6qKGnjqQqQI2x+rB9kWMBU/sFR5nvupvF/f1Uzv
         hXC26yipoitgCYxceLq1BEIZSqUMIZ5ndtIGHEY88B5sruGQIY906tKRvVz5edwQ42EK
         5Kvo+TrnvsgRXvHWCTrEMb9Nxwn+x6qNKR6xw=
Message-ID: <4D30DB42.5040704@lwfinger.net>
Date: Fri, 14 Jan 2011 17:24:50 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
CC: Greg Kroah-Hartman <gregkh@suse.de>, florian.c.schilhabel@googlemail.com,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: [PATCH] staging: r8712u: Fix external firmware loading
References: <4d30b7fa.j0xZq9/VwpVGxx/H%Larry.Finger@lwfinger.net> <201101150005.26858.s.L-H@gmx.de> <201101150008.18054.s.L-H@gmx.de>
In-Reply-To: <201101150008.18054.s.L-H@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2011 05:08 PM, Stefan Lippers-Hollmann wrote:
> * select FW_LOADER
> * change firmware location to represent published linux-fimware.git
> * declare MODULE_FIRMWARE for r8712u
> 
> Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
> ---
>  drivers/staging/rtl8712/Kconfig    |    1 +
>  drivers/staging/rtl8712/hal_init.c |    3 ++-
>  2 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/rtl8712/Kconfig b/drivers/staging/rtl8712/Kconfig
> index 1e9a230..041e1e8 100644
> --- a/drivers/staging/rtl8712/Kconfig
> +++ b/drivers/staging/rtl8712/Kconfig
> @@ -3,6 +3,7 @@ config R8712U
>  	depends on WLAN && USB
>  	select WIRELESS_EXT
>  	select WEXT_PRIV
> +	select FW_LOADER
>  	default N
>  	---help---
>  	This option adds the Realtek RTL8712 USB device such as the D-Link DWA-130.
> diff --git a/drivers/staging/rtl8712/hal_init.c b/drivers/staging/rtl8712/hal_init.c
> index 52ab2d5..1411c7bf 100644
> --- a/drivers/staging/rtl8712/hal_init.c
> +++ b/drivers/staging/rtl8712/hal_init.c
> @@ -40,7 +40,7 @@ static u32 rtl871x_open_fw(struct _adapter *padapter, void **pphfwfile_hdl,
>  		    const u8 **ppmappedfw)
>  {
>  	int rc;
> -	const char firmware_file[] = "rtl8712u/rtl8712u.bin";
> +	const char firmware_file[] = "rtlwifi/rtl8712u.bin";
>  	const struct firmware **praw = (const struct firmware **)
>  				       (pphfwfile_hdl);
>  	struct dvobj_priv *pdvobjpriv = (struct dvobj_priv *)
> @@ -58,6 +58,7 @@ static u32 rtl871x_open_fw(struct _adapter *padapter, void **pphfwfile_hdl,
>  	*ppmappedfw = (u8 *)((*praw)->data);
>  	return (*praw)->size;
>  }
> +MODULE_FIRMWARE("rtlwifi/rtl8712u.bin");
>  
>  static void fill_fwpriv(struct _adapter *padapter, struct fw_priv *pfwpriv)
>  {


Thanks for the review. These changes are all in PATCH 4/4. Apparently, my ISP is
having some difficulties with that one, or perhaps LKML will not post it. In it,
I delete the 10K+ lines of internal firmware in a header file, and all of them
are in the patch.

Larry
