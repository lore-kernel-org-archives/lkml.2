Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934489Ab0EZLjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 07:39:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933984Ab0EZLjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 07:39:43 -0400
Date: Wed, 26 May 2010 13:39:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Charles_Cl=E9ment?= <caratorn@gmail.com>
Cc: Andreas Schwab <schwab@redhat.com>, devel@driverdev.osuosl.org,
       Jassi Brar <jassisinghbrar@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: remove all code dependent on
 LINUX_VERSION_CODE
In-Reply-To: <20100525180220.GA14127@fujitsu>
Message-ID: <alpine.LNX.2.00.1005261339070.28092@pobox.suse.cz>
References: <alpine.LNX.2.00.1005251200410.28092@pobox.suse.cz> <AANLkTik-k5lECpQtbsQy8DLJJ3DOPrAz_e5XPPMzgr2o@mail.gmail.com> <alpine.LNX.2.00.1005251355100.28092@pobox.suse.cz> <m3eih0dvyv.fsf@hase.home> <alpine.LNX.2.00.1005251414310.28092@pobox.suse.cz>
 <20100525180220.GA14127@fujitsu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010, Charles Clément wrote:

> Hello Jiri,
> 
> On Tue, May 25, 2010 at 02:16:50PM +0200, Jiri Kosina wrote:
> > On Tue, 25 May 2010, Andreas Schwab wrote:
> 
> > diff --git a/drivers/staging/cxt1e1/pmcc4.h b/drivers/staging/cxt1e1/pmcc4.h
> > index 26c1f0e..e288a0a 100644
> > --- a/drivers/staging/cxt1e1/pmcc4.h
> > +++ b/drivers/staging/cxt1e1/pmcc4.h
> > @@ -117,12 +117,6 @@ extern      "C"
> >  
> >  #include "pmcc4_private.h"
> >  
> > -#if !(LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
> > -char       *get_hdlc_name (hdlc_device *);
> > -
> > -#endif
> > -
> > -
> 
> Shouldn't that declaration be kept?

Thanks for catching that.

> > diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c
> > index 65f4889..14ca610 100644
> > --- a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c
> > +++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c
> 
> > @@ -886,32 +711,18 @@ static int ieee80211_tkip_set_key(void *key, int len, u8 *seq, void *priv)
> >  {
> >  	struct ieee80211_tkip_data *tkey = priv;
> >  	int keyidx;
> > -#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
> > -	struct crypto_tfm *tfm = tkey->tx_tfm_michael;
> > -	struct crypto_tfm *tfm2 = tkey->tx_tfm_arc4;
> > -	struct crypto_tfm *tfm3 = tkey->rx_tfm_michael;
> > -	struct crypto_tfm *tfm4 = tkey->rx_tfm_arc4;
> > -#else
> >  	struct crypto_hash *tfm = tkey->tx_tfm_michael;
> >  	struct crypto_blkcipher *tfm2 = tkey->tx_tfm_arc4;
> >  	struct crypto_hash *tfm3 = tkey->rx_tfm_michael;
> >  	struct crypto_blkcipher *tfm4 = tkey->rx_tfm_arc4;
> > -#endif
> >  
> >  	keyidx = tkey->key_idx;
> >  	memset(tkey, 0, sizeof(*tkey));
> >  	tkey->key_idx = keyidx;
> > -#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
> >  	tkey->tx_tfm_michael = tfm;
> >  	tkey->tx_tfm_arc4 = tfm2;
> >  	tkey->rx_tfm_michael = tfm3;
> >  	tkey->rx_tfm_arc4 = tfm4;
> > -#else
> > -	tkey->tx_tfm_michael = tfm;
> > -	tkey->tx_tfm_arc4 = tfm2;
> > -	tkey->rx_tfm_michael = tfm3;
> > -	tkey->rx_tfm_arc4 = tfm4;
> > -#endif
> 
> In this block, it is not the same branch that are kept, don't you want
> to keep the same ones?

What difference do you see?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
