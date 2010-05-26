Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab0EZPzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:55:20 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36541 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab0EZPzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:55:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Cn4s8EHVM+Lbe3EhGA3XRTzkxszK/GQ8DVN5iFw6qOiL92pZ7dJJHPFK7ML74v7d9+
         +TXrcnum/eAWLO3jIcPK6gVYB0T12KpYEmW8cvJ86FdeBH75ga5wINQTgL8ipZCyj7Xs
         7+Bb8erhEzZuztfqwfBVDEZYQiVsNUTnR7Tk8=
Date: Wed, 26 May 2010 08:52:44 -0700
From: Charles =?iso-8859-1?Q?Cl=E9ment?= <caratorn@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Charles =?iso-8859-1?Q?Cl=E9ment?= <caratorn@gmail.com>,
       Andreas Schwab <schwab@redhat.com>, devel@driverdev.osuosl.org,
       Jassi Brar <jassisinghbrar@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: remove all code dependent on
 LINUX_VERSION_CODE
Message-ID: <20100526155243.GA5884@fujitsu>
References: <alpine.LNX.2.00.1005251200410.28092@pobox.suse.cz>
 <AANLkTik-k5lECpQtbsQy8DLJJ3DOPrAz_e5XPPMzgr2o@mail.gmail.com>
 <alpine.LNX.2.00.1005251355100.28092@pobox.suse.cz>
 <m3eih0dvyv.fsf@hase.home>
 <alpine.LNX.2.00.1005251414310.28092@pobox.suse.cz>
 <20100525180220.GA14127@fujitsu>
 <alpine.LNX.2.00.1005261339070.28092@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1005261339070.28092@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 01:39:42PM +0200, Jiri Kosina wrote:
> On Tue, 25 May 2010, Charles Clément wrote:

> > > diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c
> > > index 65f4889..14ca610 100644
> > > --- a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c
> > > +++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c
> > 
> > > @@ -886,32 +711,18 @@ static int ieee80211_tkip_set_key(void *key, int len, u8 *seq, void *priv)
> > >  {
> > >  	struct ieee80211_tkip_data *tkey = priv;
> > >  	int keyidx;
> > > -#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
> > > -	struct crypto_tfm *tfm = tkey->tx_tfm_michael;
> > > -	struct crypto_tfm *tfm2 = tkey->tx_tfm_arc4;
> > > -	struct crypto_tfm *tfm3 = tkey->rx_tfm_michael;
> > > -	struct crypto_tfm *tfm4 = tkey->rx_tfm_arc4;
> > > -#else
> > >  	struct crypto_hash *tfm = tkey->tx_tfm_michael;
> > >  	struct crypto_blkcipher *tfm2 = tkey->tx_tfm_arc4;
> > >  	struct crypto_hash *tfm3 = tkey->rx_tfm_michael;
> > >  	struct crypto_blkcipher *tfm4 = tkey->rx_tfm_arc4;
> > > -#endif
> > >  
> > >  	keyidx = tkey->key_idx;
> > >  	memset(tkey, 0, sizeof(*tkey));
> > >  	tkey->key_idx = keyidx;
> > > -#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
> > >  	tkey->tx_tfm_michael = tfm;
> > >  	tkey->tx_tfm_arc4 = tfm2;
> > >  	tkey->rx_tfm_michael = tfm3;
> > >  	tkey->rx_tfm_arc4 = tfm4;
> > > -#else
> > > -	tkey->tx_tfm_michael = tfm;
> > > -	tkey->tx_tfm_arc4 = tfm2;
> > > -	tkey->rx_tfm_michael = tfm3;
> > > -	tkey->rx_tfm_arc4 = tfm4;
> > > -#endif
> > 
> > In this block, it is not the same branch that are kept, don't you want
> > to keep the same ones?
> 
> What difference do you see?

Right, the branch are exactly the same, sorry.

> -- 
> Jiri Kosina
> SUSE Labs, Novell Inc.

-- 
Charles Clément

