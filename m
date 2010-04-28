Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab0D1Sgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 14:36:51 -0400
Received: from kroah.org ([198.145.64.141]:38308 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755667Ab0D1Sgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 14:36:49 -0400
Date: Wed, 28 Apr 2010 11:24:52 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       devel@driverdev.osuosl.org
Subject: Re: [PATCH 07/13] drivers/staging/rtl8187se: Hoist assign from if
Message-ID: <20100428182452.GB8509@kroah.com>
References: <cover.1269493047.git.joe@perches.com>
 <65ce2b5aaf76237feec33b4dde5e553beb9ad03c.1269493047.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65ce2b5aaf76237feec33b4dde5e553beb9ad03c.1269493047.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 10:17:01PM -0700, Joe Perches wrote:
> --- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
> +++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
> @@ -1554,7 +1554,8 @@ ieee80211_rx_auth_rq(struct ieee80211_device *ieee, struct sk_buff *skb)
>  	//IEEE80211DMESG("Rx probe");
>  	ieee->softmac_stats.rx_auth_rq++;
>  
> -	if ((status = auth_rq_parse(skb, dest))!= -1){
> +	status = auth_rq_parse(skb, dest);
> +	if (status!= -1) {

Careful that you don't add new coding style issues to a staging driver
:)

I've fixed this up in the patch...

thanks,

greg k-h
