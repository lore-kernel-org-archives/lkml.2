Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab2DVTcE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 15:32:04 -0400
Received: from toronto-hs-216-138-233-67.s-ip.magma.ca ([216.138.233.67]:37802
	"HELO yow.seanm.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751580Ab2DVTcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 15:32:01 -0400
Date: Sun, 22 Apr 2012 15:25:14 -0400
From: Sean MacLennan <seanm@seanm.ca>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/staging/rtl8192u/ieee80211/ieee80211_module.c:
 add missing free_netdev
Message-ID: <20120422152514.60e66f04@lappy.seanm.ca>
In-Reply-To: <1335096133-16951-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1335096133-16951-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Apr 2012 14:02:13 +0200
Julia Lawall <Julia.Lawall@lip6.fr> wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Free dev on failure as done elsewhere in the function.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  drivers/staging/rtl8192u/ieee80211/ieee80211_module.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
> b/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c index
> e3d47bc..82d4bf6 100644 ---
> a/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c +++
> b/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c @@ -161,7
> +161,7 @@ struct net_device *alloc_ieee80211(int sizeof_priv) if
> (ieee->pHTInfo == NULL) {
>  		IEEE80211_DEBUG(IEEE80211_DL_ERR, "can't alloc
> memory for HTInfo\n");
> -		return NULL;
> +		goto failed;
>  	}
>  	HTUpdateDefaultSetting(ieee);
>  	HTInitializeHTInfo(ieee); //may move to other place.

It looks like the rtl8192e/rtllib_module.c alloc_rtllib has the same
error. They probably where based on the same function.

Cheers,
   Sean
