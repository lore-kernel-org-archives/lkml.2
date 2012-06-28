Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab2F1FJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 01:09:44 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39107 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab2F1FJm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 01:09:42 -0400
MIME-Version: 1.0
In-Reply-To: <1340824779-5157-1-git-send-email-asido4@gmail.com>
References: <1340824779-5157-1-git-send-email-asido4@gmail.com>
Date: Thu, 28 Jun 2012 10:39:41 +0530
Message-ID: <CAD2nsn3Kt49mkkE99+8u5AzN+pSw8ktr7ABx3-B74qvQ9VSpWg@mail.gmail.com>
Subject: Re: [PATCH] Build fix in drivers/net/wireless/ath/ath9k/main.c
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Arvydas Sidorenko <asido4@gmail.com>
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
        senthilb@qca.qualcomm.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 28, 2012 at 12:49 AM, Arvydas Sidorenko <asido4@gmail.com> wrote:
> Commit fad29cd2f59949581050a937786c2c9bc78b2f04 broke the build if
> no CONFIG_ATH9K_BTCOEX_SUPPORT is enabled.
>
> Signed-off-by: Arvydas Sidorenko <asido4@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/main.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index c14cf5a..e4e73f0 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -151,8 +151,10 @@ static void __ath_cancel_work(struct ath_softc *sc)
>        cancel_delayed_work_sync(&sc->tx_complete_work);
>        cancel_delayed_work_sync(&sc->hw_pll_work);
>
> +#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
>        if (ath9k_hw_mci_is_enabled(sc->sc_ah))
>                cancel_work_sync(&sc->mci_work);
> +#endif
>  }
>
>  static void ath_cancel_work(struct ath_softc *sc)
> --
> 1.7.8.6

thanks for the patch, but it was just sent some time back
http://www.spinics.net/lists/linux-wireless/msg93078.html


>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
