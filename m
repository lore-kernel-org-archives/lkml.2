Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab1BVPpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 10:45:08 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58802 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab1BVPpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 10:45:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=e136HVmBNjDGosJNAb6Ohe/bXTN64Ru7P+vNJjvomZST1kVH2xZlfQRK5YeClSt5Jh
         1nCiVITN7Y3357vUBoG+CefgkHK8gQOlC8rt80Tccpys0p8wHo+PGesX2963Lpb2iC/F
         OhfoHNtaIGpeYCCLwh5wGAdWPuBfXEukUgcP8=
Message-ID: <4D63D9FD.1080101@lwfinger.net>
Date: Tue, 22 Feb 2011 09:45:01 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, George <george0505@realtek.com>
Subject: Re: linux-next: build failure after merge of the final tree (wireless
 tree related)
References: <20110222181519.7a020eb3.sfr@canb.auug.org.au>
In-Reply-To: <20110222181519.7a020eb3.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 01:15 AM, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/net/wireless/rtlwifi/rtl8192cu/sw.c: In function 'rtl92cu_init_sw_vars':
> drivers/net/wireless/rtlwifi/rtl8192cu/sw.c:60: error: implicit declaration of function 'vmalloc'
> drivers/net/wireless/rtlwifi/rtl8192cu/sw.c:60: warning: assignment makes pointer from integer without a cast
> drivers/net/wireless/rtlwifi/rtl8192cu/sw.c: In function 'rtl92cu_deinit_sw_vars':
> drivers/net/wireless/rtlwifi/rtl8192cu/sw.c:74: error: implicit declaration of function 'vfree'
> 
> Caused by commit 442888c706e90634c4cc3441751b43115a7d8506 ("rtlwifi:
> rtl8192cu: Add routines dm, fw, led and sw").  Missing an include of
> linux/vmalloc.h.  See Rule 1 in Documentation/SubmitChecklist.
> 
> I added the following patch:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 22 Feb 2011 17:29:04 +1100
> Subject: [PATCH] rtlwifi: include vmalloc.h for needed routines
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/net/wireless/rtlwifi/rtl8192cu/sw.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> index 4e937e0..c69861e 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> @@ -27,6 +27,8 @@
>   *
>   *****************************************************************************/
>  
> +#include <linux/vmalloc.h>
> +
>  #include "../wifi.h"
>  #include "../core.h"
>  #include "../usb.h"

I had gotten private mail yesterday about the missing vmalloc.h include.

It will take me a while to set up an allyes configuration to find the other
problems.

Larry
