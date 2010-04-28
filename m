Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab0D1Shs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 14:37:48 -0400
Received: from kroah.org ([198.145.64.141]:38316 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363Ab0D1Sgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 14:36:50 -0400
Date: Wed, 28 Apr 2010 11:27:10 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 09/13] drivers/staging/rtl8192su: Hoist assign from if
Message-ID: <20100428182710.GD8509@kroah.com>
References: <cover.1269493047.git.joe@perches.com>
 <c45ba099fc8f31f166c4067f2eff609c8eaf422f.1269493047.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c45ba099fc8f31f166c4067f2eff609c8eaf422f.1269493047.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 10:17:03PM -0700, Joe Perches wrote:
> --- a/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
> +++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
> @@ -1690,7 +1690,8 @@ ieee80211_rx_auth_rq(struct ieee80211_device *ieee, struct sk_buff *skb)
>  	//IEEE80211DMESG("Rx probe");
>  	ieee->softmac_stats.rx_auth_rq++;
>  
> -	if ((status = auth_rq_parse(skb, dest))!= -1){
> +	status = auth_rq_parse(skb, dest);
> +	if (status!= -1) {

And again.  Did you do this with some tool and not by hand?

Did you not run your patch through checkpatch after creating it and
before sending it to me?

thanks,

greg k-h
