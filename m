Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab0FGUka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 16:40:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26952 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab0FGUk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 16:40:28 -0400
Message-ID: <4C0D58C6.2060505@oracle.com>
Date: Mon, 07 Jun 2010 13:38:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: fix-up botched revert
References: <20100607090230.deed8bd1.randy.dunlap@oracle.com> <1275936576-15590-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1275936576-15590-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090203.4C0D592B.0065:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/10 11:49, John W. Linville wrote:
> In the revert of "iwlwifi: move _agn statistics related structure", I
> need to use CONFIG_IWLWIFI_DEBUGFS instead of CONFIG_IWLWIFI_DEBUG in
> the private structure definition.  Without this patch, it is possible
> to get this:
> 
> drivers/net/wireless/iwlwifi/iwl-rx.c: In function 'iwl_accumulative_statistics':
> drivers/net/wireless/iwlwifi/iwl-rx.c:304: error: 'struct iwl_priv' has no member named 'accum_statistics'
> drivers/net/wireless/iwlwifi/iwl-rx.c:305: error: 'struct iwl_priv' has no member named 'delta_statistics'
> drivers/net/wireless/iwlwifi/iwl-rx.c:306: error: 'struct iwl_priv' has no member named 'max_delta'
> drivers/net/wireless/iwlwifi/iwl-rx.c:321: error: 'struct iwl_priv' has no member named 'accum_statistics'
> drivers/net/wireless/iwlwifi/iwl-rx.c:323: error: 'struct iwl_priv' has no member named 'accum_statistics'
> drivers/net/wireless/iwlwifi/iwl-rx.c:325: error: 'struct iwl_priv' has no member named 'accum_statistics'
> drivers/net/wireless/iwlwifi/iwl-rx.c:327: error: 'struct iwl_priv' has no member named 'accum_statistics'
> drivers/net/wireless/iwlwifi/iwl-rx.c:329: error: 'struct iwl_priv' has no member named 'accum_statistics'
> drivers/net/wireless/iwlwifi/iwl-rx.c:331: error: 'struct iwl_priv' has no member named 'accum_statistics'
> drivers/net/wireless/iwlwifi/iwl-rx.c: In function 'iwl_reply_statistics':
> drivers/net/wireless/iwlwifi/iwl-rx.c:484: error: 'struct iwl_priv' has no member named 'accum_statistics'
> drivers/net/wireless/iwlwifi/iwl-rx.c:486: error: 'struct iwl_priv' has no member named 'delta_statistics'
> drivers/net/wireless/iwlwifi/iwl-rx.c:488: error: 'struct iwl_priv' has no member named 'max_delta'
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  drivers/net/wireless/iwlwifi/iwl-dev.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
> index f359d9f..a00248c 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-dev.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
> @@ -1208,7 +1208,7 @@ struct iwl_priv {
>  	struct iwl_tt_mgmt thermal_throttle;
>  
>  	struct iwl_notif_statistics statistics;
> -#ifdef CONFIG_IWLWIFI_DEBUG
> +#ifdef CONFIG_IWLWIFI_DEBUGFS
>  	struct iwl_notif_statistics accum_statistics;
>  	struct iwl_notif_statistics delta_statistics;
>  	struct iwl_notif_statistics max_delta;


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
