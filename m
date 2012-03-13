Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab2CMTVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 15:21:17 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65264 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759152Ab2CMTVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 15:21:15 -0400
Date: Tue, 13 Mar 2012 23:21:10 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        m.szyprowski@samsung.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] max17042_battery: Preserve properties outside of
 platform data
Message-ID: <20120313192110.GB2187@oksana.dev.rtsoft.ru>
References: <1329933982-2529-1-git-send-email-k.lewandowsk@samsung.com>
 <1329933982-2529-3-git-send-email-k.lewandowsk@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1329933982-2529-3-git-send-email-k.lewandowsk@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 07:06:21PM +0100, Karol Lewandowski wrote:
> Add fields originally found in platform data back to max17042_chip,
> as the former data structure might be not available on device
> tree-based systems.
> 
> This commit makes it possible to safely declare platform data with
> __initdata tag.
> 
> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/power/max17042_battery.c |   36 +++++++++++++++++++++++-------------
>  1 files changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
> index 21a3650..49c1377 100644
> --- a/drivers/power/max17042_battery.c
> +++ b/drivers/power/max17042_battery.c
> @@ -33,7 +33,8 @@
>  struct max17042_chip {
>  	struct i2c_client *client;
>  	struct power_supply battery;
> -	struct max17042_platform_data *pdata;
> +	bool enable_current_sense;
> +	u32 r_sns;

Dirk Brandewie implemented config_data in addition to these
fields, so this patch would have needed a rework. So I decided
to drop this particular patch and rework patch 3/3 to make OF
helper allocat pdata instead.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
