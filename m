Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab1BITT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 14:19:56 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:45703 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab1BITTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 14:19:55 -0500
X-Auth-Info: HzGxAG/tpVFyQ7CwDRMvdhWUIupHeNhisQvyGUcA0Hw=
Message-ID: <4D52E94D.8030400@grandegger.com>
Date: Wed, 09 Feb 2011 20:21:49 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew.chih.howe.khor@intel.com,
        qi.wang@intel.com, yong.y.wang@intel.com,
        toshiharu-linux@dsn.okisemi.com, kok.howg.ewe@intel.com,
        joel.clark@intel.com
Subject: Re: [PATCH 1/3] pch_can: fix 800k comms issue
References: <1297157343-3213-1-git-send-email-tomoya-linux@dsn.okisemi.com>
In-Reply-To: <1297157343-3213-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomoya,

On 02/08/2011 10:29 AM, Tomoya MORINAGA wrote:
> Currently, 800k comms fails since prop_seg set zero.
> (EG20T PCH CAN register of prop_seg must be set more than 1)
> To prevent prop_seg set to zero, change tseg2_min 1 to 2.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---
>  drivers/net/can/pch_can.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
> index c42e972..9b171d1 100644
> --- a/drivers/net/can/pch_can.c
> +++ b/drivers/net/can/pch_can.c
> @@ -187,7 +187,7 @@ static struct can_bittiming_const pch_can_bittiming_const = {
>  	.name = KBUILD_MODNAME,
>  	.tseg1_min = 1,
>  	.tseg1_max = 16,
> -	.tseg2_min = 1,
> +	.tseg2_min = 2,
>  	.tseg2_max = 8,
>  	.sjw_max = 4,
>  	.brp_min = 1,

I just realized that this fix is wrong. You wanted to set tseg1_min to 2
(and not tseg2_min). Could you please send a patch?

Thanks,

Wolfgang.
