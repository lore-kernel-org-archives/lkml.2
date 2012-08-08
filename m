Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030802Ab2HHTdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 15:33:41 -0400
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:39743 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758084Ab2HHTdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 15:33:39 -0400
X-Greylist: delayed 629 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Aug 2012 15:33:38 EDT
Message-ID: <20120808222306.133742ltgk7j9tic@www.81.fi>
Date: Wed, 08 Aug 2012 22:23:06 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: Re: [PATCH] rndis_wlan: Fix potential memory leak in
 update_pmkid()
References: <1344440661-32322-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1344440661-32322-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Khoroshilov <khoroshilov@ispras.ru>:

> Do not leak memory by updating pointer with potentially NULL realloc  
> return value.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Thanks!

Acked-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

> ---
>  drivers/net/wireless/rndis_wlan.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/rndis_wlan.c  
> b/drivers/net/wireless/rndis_wlan.c
> index 241162e..7a4ae9e 100644
> --- a/drivers/net/wireless/rndis_wlan.c
> +++ b/drivers/net/wireless/rndis_wlan.c
> @@ -1803,6 +1803,7 @@ static struct ndis_80211_pmkid  
> *update_pmkid(struct usbnet *usbdev,
>  						struct cfg80211_pmksa *pmksa,
>  						int max_pmkids)
>  {
> +	struct ndis_80211_pmkid *new_pmkids;
>  	int i, err, newlen;
>  	unsigned int count;
>
> @@ -1833,11 +1834,12 @@ static struct ndis_80211_pmkid  
> *update_pmkid(struct usbnet *usbdev,
>  	/* add new pmkid */
>  	newlen = sizeof(*pmkids) + (count + 1) * sizeof(pmkids->bssid_info[0]);
>
> -	pmkids = krealloc(pmkids, newlen, GFP_KERNEL);
> -	if (!pmkids) {
> +	new_pmkids = krealloc(pmkids, newlen, GFP_KERNEL);
> +	if (!new_pmkids) {
>  		err = -ENOMEM;
>  		goto error;
>  	}
> +	pmkids = new_pmkids;
>
>  	pmkids->length = cpu_to_le32(newlen);
>  	pmkids->bssid_info_count = cpu_to_le32(count + 1);
> --
> 1.7.9.5
>
>
>



