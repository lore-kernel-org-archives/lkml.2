Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933496Ab1D1Uy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 16:54:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58183 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611Ab1D1Uyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 16:54:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-pgp-id:x-archive
         :user-agent;
        b=cB+JvGdChwMn7ZhYvoVcp8m2jldHFxk8Z/efczRdnXCfgNBA2n9Xj9OuyKGrZJ3+1T
         1/C2ZahdScOs7mSqIE7FdiTQyZZCmNNvnX6lGYRoO44xBHJhQS4NAsqhA7hi0xnwCmEn
         yrvAonnR7aS4AizYR3KYbW5TmnXz7Dgg6XsAw=
Date: Thu, 28 Apr 2011 22:54:49 +0200
From: clemens fischer <ino-news@spotteswoode.dnsalias.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, jeff.chua.linux@gmail.com,
        wlanfae@realtek.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: r8712u: Fix driver to support ad-hoc mode
Message-ID: <20110428205449.GA3730@spotteswoode.de.eu.org>
References: <4db8436a.NDzkd3ql2wJdwy2L%Larry.Finger@lwfinger.net>
 <20110428150819.GA3713@spotteswoode.de.eu.org>
 <4DB9884F.10409@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB9884F.10409@lwfinger.net>
X-PGP-ID: 0x214190AF
X-Archive: encrypt=none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Larry Finger:

> On 04/28/2011 10:08 AM, clemens fischer wrote:
>
> >[1] https://bugzilla.kernel.org/show_bug.cgi?id=33352
> 
> Does this one help? It should be in addition to the previous patch.

So far it doesn't, but I'm having trouble with (wpa_supplicant &&
adhoc-mode).  With "iwconfig", it doesn't help.

> Index: linux-2.6/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> ===================================================================
> --- linux-2.6.orig/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> +++ linux-2.6/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> @@ -990,8 +990,6 @@ static int r8711_wx_set_wap(struct net_d
>  	struct wlan_network *pnetwork = NULL;
>  	enum NDIS_802_11_AUTHENTICATION_MODE	authmode;
>  
> -	if (padapter->bup == false)
> -		return -1;
>  	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY) == true)
>  		return -1;
>  	if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING) == true)
> @@ -1182,8 +1180,6 @@ static int r8711_wx_set_essid(struct net
>  	struct list_head *phead;
>  	u32 len;
>  
> -	if (padapter->bup == false)
> -		return -1;
>  	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY))
>  		return -1;
>  	if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING))


regards, clemens
