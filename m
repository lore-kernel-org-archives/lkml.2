Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953Ab0EYSEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 14:04:55 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56800 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580Ab0EYSEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 14:04:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=bj6bBfdFfLQJPoiujcJZQBWSNyn/ub/VX1lUvbq8BP7nItzjpVX6HeaRV9jAvDrJTu
         CQXaDt6ymVjgo5+OYPOiNTp04xzLjBgSanGzmg8c2Ex42+OthJA7zAGHqekmjp8iCgWn
         x4nuMzfl95ruSCzSiO2QUUbQ9jSD9tX8FJ/nU=
Date: Tue, 25 May 2010 11:02:22 -0700
From: Charles =?iso-8859-1?Q?Cl=E9ment?= <caratorn@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andreas Schwab <schwab@redhat.com>, devel@driverdev.osuosl.org,
       Jassi Brar <jassisinghbrar@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: remove all code dependent on
 LINUX_VERSION_CODE
Message-ID: <20100525180220.GA14127@fujitsu>
References: <alpine.LNX.2.00.1005251200410.28092@pobox.suse.cz>
 <AANLkTik-k5lECpQtbsQy8DLJJ3DOPrAz_e5XPPMzgr2o@mail.gmail.com>
 <alpine.LNX.2.00.1005251355100.28092@pobox.suse.cz>
 <m3eih0dvyv.fsf@hase.home>
 <alpine.LNX.2.00.1005251414310.28092@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1005251414310.28092@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jiri,

On Tue, May 25, 2010 at 02:16:50PM +0200, Jiri Kosina wrote:
> On Tue, 25 May 2010, Andreas Schwab wrote:

> diff --git a/drivers/staging/cxt1e1/pmcc4.h b/drivers/staging/cxt1e1/pmcc4.h
> index 26c1f0e..e288a0a 100644
> --- a/drivers/staging/cxt1e1/pmcc4.h
> +++ b/drivers/staging/cxt1e1/pmcc4.h
> @@ -117,12 +117,6 @@ extern      "C"
>  
>  #include "pmcc4_private.h"
>  
> -#if !(LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
> -char       *get_hdlc_name (hdlc_device *);
> -
> -#endif
> -
> -

Shouldn't that declaration be kept?


> diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c
> index 65f4889..14ca610 100644
> --- a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c
> +++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c

> @@ -886,32 +711,18 @@ static int ieee80211_tkip_set_key(void *key, int len, u8 *seq, void *priv)
>  {
>  	struct ieee80211_tkip_data *tkey = priv;
>  	int keyidx;
> -#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
> -	struct crypto_tfm *tfm = tkey->tx_tfm_michael;
> -	struct crypto_tfm *tfm2 = tkey->tx_tfm_arc4;
> -	struct crypto_tfm *tfm3 = tkey->rx_tfm_michael;
> -	struct crypto_tfm *tfm4 = tkey->rx_tfm_arc4;
> -#else
>  	struct crypto_hash *tfm = tkey->tx_tfm_michael;
>  	struct crypto_blkcipher *tfm2 = tkey->tx_tfm_arc4;
>  	struct crypto_hash *tfm3 = tkey->rx_tfm_michael;
>  	struct crypto_blkcipher *tfm4 = tkey->rx_tfm_arc4;
> -#endif
>  
>  	keyidx = tkey->key_idx;
>  	memset(tkey, 0, sizeof(*tkey));
>  	tkey->key_idx = keyidx;
> -#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
>  	tkey->tx_tfm_michael = tfm;
>  	tkey->tx_tfm_arc4 = tfm2;
>  	tkey->rx_tfm_michael = tfm3;
>  	tkey->rx_tfm_arc4 = tfm4;
> -#else
> -	tkey->tx_tfm_michael = tfm;
> -	tkey->tx_tfm_arc4 = tfm2;
> -	tkey->rx_tfm_michael = tfm3;
> -	tkey->rx_tfm_arc4 = tfm4;
> -#endif

In this block, it is not the same branch that are kept, don't you want
to keep the same ones?

-- 
Charles Clément

