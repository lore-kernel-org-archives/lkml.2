Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760264Ab2CMWmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 18:42:43 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44228 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758573Ab2CMWml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 18:42:41 -0400
Date: Tue, 13 Mar 2012 15:42:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andrew Miller <amiller@amilx.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8187se: r8180_core.c: Fix coding style issue
Message-ID: <20120313224236.GA12677@kroah.com>
References: <1331440353-2829-1-git-send-email-amiller@amilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331440353-2829-1-git-send-email-amiller@amilx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 11:32:33PM -0500, Andrew Miller wrote:
> Fix long line coding style issue
> 
> Signed-off-by: Andrew Miller <amiller@amilx.com>
> ---
>  drivers/staging/rtl8187se/r8180_core.c |  556 ++++++++++++++++++++++----------
>  1 files changed, 386 insertions(+), 170 deletions(-)
> 
> diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
> index 04c2391..05f25eb 100644
> --- a/drivers/staging/rtl8187se/r8180_core.c
> +++ b/drivers/staging/rtl8187se/r8180_core.c
> @@ -79,8 +79,11 @@ module_param(hwwep, int, S_IRUGO|S_IWUSR);
>  module_param(channels, int, S_IRUGO|S_IWUSR);
>  
>  MODULE_PARM_DESC(devname, " Net interface name, wlan%d=default");
> -MODULE_PARM_DESC(hwseqnum, " Try to use hardware 802.11 header sequence numbers. Zero=default");
> -MODULE_PARM_DESC(hwwep, " Try to use hardware WEP support. Still broken and not available on all cards");
> +MODULE_PARM_DESC(hwseqnum, " Try to use hardware 802.11 header sequence "
> +				"numbers. Zero=default");
> +MODULE_PARM_DESC(hwwep, " Try to use hardware WEP support. "
> +			"Still broken and not"
> +			" available on all cards");

Never break up strings, you can ignore those warnings, they are foolish.

> -void buffer_free(struct net_device *dev, struct buffer **buffer, int len, short consistent)
> +void buffer_free(struct net_device *dev,
> +		struct buffer **buffer,
> +		int len,
> +		short consistent)

Nicer, but how about:
void buffer_free(struct net_device *dev, struct buffer **buffer, int len,
		 short consistent)

Instead?  No need to put every variable on a new line, and this lines
things up better.

>  {
>  
>  	struct buffer *tmp, *next;
> @@ -516,7 +523,8 @@ short check_nic_enought_desc(struct net_device *dev, int priority)
>  	struct ieee80211_device *ieee = netdev_priv(dev);
>  	int requiredbyte, required;
>  
> -	requiredbyte = priv->ieee80211->fts + sizeof(struct ieee80211_header_data);
> +	requiredbyte = priv->ieee80211->fts +
> +		sizeof(struct ieee80211_header_data);
>  
>  	if (ieee->current_network.QoS_Enable)
>  		requiredbyte += 2;
> @@ -982,49 +990,70 @@ short alloc_tx_desc_ring(struct net_device *dev, int bufsize, int count,
>  
>  		switch (addr) {
>  		case TX_MANAGEPRIORITY_RING_ADDR:
> -			if (-1 == buffer_add(&(priv->txmapbufs), buf, dma_tmp, NULL)) {
> +			if (-1 == buffer_add(&(priv->txmapbufs),
> +					buf,
> +					dma_tmp,
> +					NULL)) {

That's just harder to read, no need to do this, right?

Be wise in your cleanup, you don't have to fix up every warning, do the
ones that make sense.

Care to retry?

greg k-h
