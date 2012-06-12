Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab2FLTRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 15:17:36 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:60240 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab2FLTRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 15:17:34 -0400
Message-ID: <1339528648.4531.15.camel@jlt3.sipsolutions.net>
Subject: Re: [PATCH] iwlwifi: re-order module_init order to prevent NULL ptr
 deref
From: Johannes Berg <johannes@sipsolutions.net>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: wey-yi.w.guy@intel.com, linville@tuxdriver.com, ilw@linux.intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 12 Jun 2012 21:17:28 +0200
In-Reply-To: <1339528412-4163-1-git-send-email-levinsasha928@gmail.com> (sfid-20120612_211247_722972_E0F3BAE7)
References: <1339528412-4163-1-git-send-email-levinsasha928@gmail.com>
	 (sfid-20120612_211247_722972_E0F3BAE7)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 21:13 +0200, Sasha Levin wrote:
> We need to make sure iwl_drv_init is called before iwl_init, since otherwise
> iwl_init will NULL ptr deref when trying to add a new mode.
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  drivers/net/wireless/iwlwifi/Makefile |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
> index 98c8f64..16e39a4 100644
> --- a/drivers/net/wireless/iwlwifi/Makefile
> +++ b/drivers/net/wireless/iwlwifi/Makefile
> @@ -1,5 +1,3 @@
> -obj-$(CONFIG_IWLDVM)	+= dvm/
> -

Thanks! I already have a patch like this in my tree, will send a pull
request soon:

http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-next.git;a=commit;h=4b75b1e49568dd6a30a1dddc47408cc6fde55608

johannes

