Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab1GVG65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 02:58:57 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:52996 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab1GVG64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 02:58:56 -0400
Date: Fri, 22 Jul 2011 08:42:48 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: linux-next: manual merge of the trivial tree with the net tree
Message-ID: <20110722064248.GA10763@electric-eye.fr.zoreil.com>
References: <20110722141842.963b38d45ebf8cb5d0a25fcf@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722141842.963b38d45ebf8cb5d0a25fcf@canb.auug.org.au>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> :
[...]
> diff --cc drivers/net/r8169.c
> index 40bcb82,6f36306..0000000
> --- a/drivers/net/r8169.c
> +++ b/drivers/net/r8169.c
> @@@ -682,19 -666,8 +682,19 @@@ struct rtl8169_private 
>   	struct rtl8169_counters counters;
>   	u32 saved_wolopts;
>   
>  -	const struct firmware *fw;
>  +	struct rtl_fw {
>  +		const struct firmware *fw;
>  +
>  +#define RTL_VER_SIZE		32
>  +
>  +		char version[RTL_VER_SIZE];
>  +
>  +		struct rtl_fw_phy_action {
>  +			__le32 *code;
>  +			size_t size;
>  +		} phy_action;
>  +	} *rtl_fw;
> - #define RTL_FIRMWARE_UNKNOWN	ERR_PTR(-EAGAIN);
> + #define RTL_FIRMWARE_UNKNOWN	ERR_PTR(-EAGAIN)

There should not be further conflict in this part of the code until
things get merged with Linus's tree. Do what suits best.

Thanks.

-- 
Ueimor
