Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab2A3Xg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:36:56 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41911 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab2A3Xgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:36:54 -0500
Message-ID: <4F272992.9000502@lwfinger.net>
Date: Mon, 30 Jan 2012 17:36:50 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: "Devendra.Naga" <devendra.aaru@gmail.com>
CC: chaoming_li@realsil.com.cn, linville@tuxdriver.com,
        paul.gortmaker@windriver.com, joe@perches.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] wireless: in _rtl92c_phy_calculate_bit_shift remove
 comparing bitmask against 1
References: <1327917655-6494-1-git-send-email-devendra.aaru@gmail.com>
In-Reply-To: <1327917655-6494-1-git-send-email-devendra.aaru@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2012 04:00 AM, Devendra.Naga wrote:
> From: "Devendra.Naga"<devendra.aaru@gmail.com>
>
> in _rtl92c_phy_calculate_bit_shift everytime the right shifted bitmask
> is AND with 1 and compared against 1. i.e.
>          if ((bitmask>>  i)&  0x1 == 1)
>                  break;
> which in the if condition is anyway becomes a 1 or 0.
>
> Signed-off-by: Devendra.Naga<devendra.aaru@gmail.com>

Once again, the patch is OK, but the subject is not good.

Larry

> ---
>   drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
> index 22e998d..a76b223 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
> @@ -177,7 +177,7 @@ u32 _rtl92c_phy_calculate_bit_shift(u32 bitmask)
>   	u32 i;
>
>   	for (i = 0; i<= 31; i++) {
> -		if (((bitmask>>  i)&  0x1) == 1)
> +		if ((bitmask>>  i)&  0x1)
>   			break;
>   	}
>   	return i;

