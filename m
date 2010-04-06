Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab0DFSqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 14:46:19 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:44527 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888Ab0DFSqL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 14:46:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=T0YztbumF+Dxbva2iuolkLvkT4SWamFaT8h6+tBjH78rSzD2VLMtFqb5LAEtka2ebW
         nkPhK1EPART/BiG/agkf0TM2KvNRaHoIBMW6DAH8aj10X8+2AUOcYDDDXNspUpA6PHxo
         muZW60LF56QgQf1ucvmBdb2QIXNi5//uNaDBU=
MIME-Version: 1.0
In-Reply-To: <20100406104429.GB21229@bicker>
References: <20100406104429.GB21229@bicker>
Date: Tue, 6 Apr 2010 20:46:06 +0200
Message-ID: <p2x71cd59b01004061146x25f04dfy82e1aba72ddfd3ff@mail.gmail.com>
Subject: Re: [patch] asus: don't modify bluetooth/wlan on boot
From: Corentin Chary <corentin.chary@gmail.com>
To: Dan Carpenter <error27@gmail.com>, Corentin Chary <corentincj@iksaif.net>,
       Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       acpi4asus-user@lists.sourceforge.net,
       platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 6, 2010 at 12:44 PM, Dan Carpenter <error27@gmail.com> wrote:
> We were storing -1 as an unsigned int and as a result the effect of
> passing -1 was the same as using 1.
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>
>
> diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
> index 475ab50..f532336 100644
> --- a/drivers/platform/x86/asus-laptop.c
> +++ b/drivers/platform/x86/asus-laptop.c
> @@ -78,15 +78,15 @@ static uint wapf = 1;
>  module_param(wapf, uint, 0644);
>  MODULE_PARM_DESC(wapf, "WAPF value");
>
> -static uint wlan_status = 1;
> -static uint bluetooth_status = 1;
> +static int wlan_status = 1;
> +static int bluetooth_status = 1;
>
> -module_param(wlan_status, uint, 0644);
> +module_param(wlan_status, int, 0644);
>  MODULE_PARM_DESC(wlan_status, "Set the wireless status on boot "
>                 "(0 = disabled, 1 = enabled, -1 = don't do anything). "
>                 "default is 1");
>
> -module_param(bluetooth_status, uint, 0644);
> +module_param(bluetooth_status, int, 0644);
>  MODULE_PARM_DESC(bluetooth_status, "Set the wireless status on boot "
>                 "(0 = disabled, 1 = enabled, -1 = don't do anything). "
>                 "default is 1");
> --

Thanks !
Acked-by: Corentin Chary <corentincj@iksaif.net>


-- 
Corentin Chary
http://xf.iksaif.net
