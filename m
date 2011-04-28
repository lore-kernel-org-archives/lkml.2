Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038Ab1D1PI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:08:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38495 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab1D1PI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:08:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-pgp-id:x-archive
         :user-agent;
        b=Sk0e5xQI8WkpvLbMmFAYq+dE7HCdJhkvCKPT+TZLqUH7IUPN4t7Sz+y+l9LtKVGIf6
         w5SwHG97/mVmMSPD7DyYLVpj7vFRb3/A5nLudt81N6S4DSNXQoYVE3oRYQiHNiDqMF53
         utidU/s6uF2YAbL7X+1HqsnN0/XIyTrS62vdM=
Date: Thu, 28 Apr 2011 17:08:20 +0200
From: clemens fischer <ino-news@spotteswoode.dnsalias.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, jeff.chua.linux@gmail.com,
        wlanfae@realtek.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: r8712u: Fix driver to support ad-hoc mode
Message-ID: <20110428150819.GA3713@spotteswoode.de.eu.org>
References: <4db8436a.NDzkd3ql2wJdwy2L%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4db8436a.NDzkd3ql2wJdwy2L%Larry.Finger@lwfinger.net>
X-PGP-ID: 0x214190AF
X-Archive: encrypt=none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Larry Finger:

> From: Jeff Chua <jeff.chua.linux@gmail.com>
>
> Driver r8712u is unable to handle ad-hoc mode. The issue is that when
> the driver first starts, there will not be an SSID for association.
> The fix is to always call the "select and join from scan" routine when
> in ad-hoc mode.
>
> Note: Ad-hoc mode worked intermittently before. If the driver had
> previously been associated, then things were OK.
>
> Signed-off-by: Jeff Chua <jeff.chua.linux@gmail.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@kernel.org>
> ---
>
> Index: linux-2.6/drivers/staging/rtl8712/rtl871x_ioctl_set.c
> ===================================================================
> --- linux-2.6.orig/drivers/staging/rtl8712/rtl871x_ioctl_set.c
> +++ linux-2.6/drivers/staging/rtl8712/rtl871x_ioctl_set.c
> @@ -68,7 +68,10 @@ static u8 do_join(struct _adapter *padap
>  	pmlmepriv->fw_state |= _FW_UNDER_LINKING;
>  	pmlmepriv->pscanned = plist;
>  	pmlmepriv->to_join = true;
> -	if (_queue_empty(queue) == true) {
> +
> +	/* adhoc mode will start with an empty queue, but skip checking */
> +	if (!check_fwstate(pmlmepriv, WIFI_ADHOC_STATE) &&
> +	    _queue_empty(queue)) {
>  		if (pmlmepriv->fw_state & _FW_UNDER_LINKING)
>  			pmlmepriv->fw_state ^= _FW_UNDER_LINKING;
>  		/* when set_ssid/set_bssid for do_join(), but scanning queue

Thanks for CC'ing me.

This patch doesn't solve my problem[1], unfortunately.  I am using
iwconfig(8) to setup things, and it is still impossible to set the ESSID
and the power saving mode.  In my case it was even possible to get into
Ad-hoc mode without the patch and without ever beeing associated.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=33352


regards, clemens fischer
