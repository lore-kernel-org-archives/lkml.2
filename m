Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab1I0W6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 18:58:20 -0400
Received: from mail.windriver.com ([147.11.1.11]:60338 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab1I0W6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 18:58:18 -0400
Message-ID: <4E825500.4000606@windriver.com>
Date: Tue, 27 Sep 2011 18:58:08 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <sfr@canb.auug.org.au>,
        <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] rtlwifi: rtl8192c: Add includes of export.h
References: <4e7a6393.eQ0IEnMVbVlQIbx0%Larry.Finger@lwfinger.net>
In-Reply-To: <4e7a6393.eQ0IEnMVbVlQIbx0%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-09-21 06:22 PM, Larry Finger wrote:
> With the split of include/linux/module.h into two parts, several files in
> drivers rtlwifi and rtl8192c need to include the new file.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Paul,
> 
> At Randy Dunlap's suggestion, I am sending this to you in hopes that
> I can save you some time. I think I found all the routines that will have
> a problem, but as these patches do not compile, I cannot be sure.

Hi Larry -- thanks for the patch, but...

> 
> Larry
> ---
> 
> Index: wireless-testing-new/drivers/net/wireless/rtlwifi/base.c
> ===================================================================
> --- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/base.c
> +++ wireless-testing-new/drivers/net/wireless/rtlwifi/base.c
> @@ -30,6 +30,7 @@
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
>  #include <linux/ip.h>
> +#include <linux/export.h>

This one needs module.h (which it has in my current tree) because it
calls module_init and module_exit.  All the other ones in your patch
match what I have in tree already though, so that is a good double
check to have.  There are some other ones that I found through many
randconfig builds that aren't in your patch. Here is the current list
in my tree:

~/git/module.h/linux-2.6.git$ git diff ^v3.1-rc6  HEAD drivers/net/wireless/rtlwifi |diffstat
 base.c                |    1 +
 cam.c                 |    1 +
 efuse.c               |    1 +
 pci.c                 |    1 +
 ps.c                  |    1 +
 rtl8192c/dm_common.c  |    1 +
 rtl8192c/fw_common.c  |    1 +
 rtl8192c/main.c       |    1 +
 rtl8192c/phy_common.c |    1 +
 rtl8192ce/sw.c        |    1 +
 rtl8192cu/sw.c        |    1 +
 rtl8192de/sw.c        |    1 +
 rtl8192se/sw.c        |    1 +
 usb.c                 |    1 +
 14 files changed, 14 insertions(+)

Thanks,
Paul.
 
>  #include "wifi.h"
>  #include "rc.h"
>  #include "base.h"
> Index: wireless-testing-new/drivers/net/wireless/rtlwifi/cam.c
> ===================================================================
> --- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/cam.c
> +++ wireless-testing-new/drivers/net/wireless/rtlwifi/cam.c
> @@ -29,6 +29,8 @@
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
> +#include <linux/export.h>

Have this already.

> +
>  #include "wifi.h"
>  #include "cam.h"
>  
> Index: wireless-testing-new/drivers/net/wireless/rtlwifi/efuse.c
> ===================================================================
> --- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/efuse.c
> +++ wireless-testing-new/drivers/net/wireless/rtlwifi/efuse.c
> @@ -27,6 +27,8 @@
>   *
>   *****************************************************************************/
>  
> +#include <linux/export.h>
> +
>  #include "wifi.h"
>  #include "efuse.h"
>  
> Index: wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
> ===================================================================
> --- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/pci.c
> +++ wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
> @@ -27,6 +27,8 @@
>   *
>   *****************************************************************************/
>  
> +#include <linux/export.h>
> +
>  #include "core.h"
>  #include "wifi.h"
>  #include "pci.h"
> Index: wireless-testing-new/drivers/net/wireless/rtlwifi/ps.c
> ===================================================================
> --- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/ps.c
> +++ wireless-testing-new/drivers/net/wireless/rtlwifi/ps.c
> @@ -27,6 +27,8 @@
>   *
>   *****************************************************************************/
>  
> +#include <linux/export.h>
> +
>  #include "wifi.h"
>  #include "base.h"
>  #include "ps.h"
> Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
> ===================================================================
> --- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
> +++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
> @@ -27,6 +27,8 @@
>   *
>   *****************************************************************************/
>  
> +#include <linux/export.h>
> +
>  #include "dm_common.h"
>  #include "phy_common.h"
>  #include "../pci.h"
> Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
> ===================================================================
> --- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
> +++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
> @@ -30,6 +30,8 @@
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
>  #include <linux/firmware.h>
> +#include <linux/export.h>
> +
>  #include "../wifi.h"
>  #include "../pci.h"
>  #include "../base.h"
> Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
> ===================================================================
> --- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
> +++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
> @@ -27,6 +27,8 @@
>   *
>   *****************************************************************************/
>  
> +#include <linux/export.h>
> +
>  #include "../wifi.h"
>  #include "../rtl8192ce/reg.h"
>  #include "../rtl8192ce/def.h"
> Index: wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
> ===================================================================
> --- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/usb.c
> +++ wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
> @@ -28,6 +28,8 @@
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
>  #include <linux/usb.h>
> +#include <linux/export.h>
> +
>  #include "core.h"
>  #include "wifi.h"
>  #include "usb.h"
