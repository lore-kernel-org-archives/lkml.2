Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab1LEPTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 10:19:06 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:10137 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932381Ab1LEPTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 10:19:04 -0500
Message-ID: <1323098335.7454.214.camel@deadeye>
Subject: Re: [PATCH] drivers/net/usb/asix:  resync from vendor's copy
From: Ben Hutchings <bhutchings@solarflare.com>
To: Mark Lord <kernel@teksavvy.com>
CC: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Mon, 5 Dec 2011 15:18:55 +0000
In-Reply-To: <4EDCD828.2090904@teksavvy.com>
References: <4EA89972.5060101@teksavvy.com>
	  <20111026.194045.2019668159403582571.davem@davemloft.net>
	  <4EA8B283.3010105@teksavvy.com>
	  <20111026.221719.2216112919297458522.davem@davemloft.net>
	  <4EB19BBE.5050602@teksavvy.com> <1320266549.2782.21.camel@bwh-desktop>
	  <4EBAA967.10403@teksavvy.com> <1320856444.18929.78.camel@deadeye>
	  <4EBAAEA5.1060408@teksavvy.com> <4EBAB0EA.1050102@teksavvy.com>
	  <4EBAB643.8020603@teksavvy.com> <1320859911.2781.1.camel@bwh-desktop>
	  <4EBABAFD.6050604@teksavvy.com> <1320860895.2781.6.camel@bwh-desktop>
	 <4EDCD828.2090904@teksavvy.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [88.96.1.126]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18560.004
X-TM-AS-Result: No--3.825600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-05 at 09:41 -0500, Mark Lord wrote:
[...]
> static int ax88772b_bind(struct usbnet *dev, struct usb_interface *intf)
> {
> ...
>         /* register support for hardware checksums */
>         dev->net->hw_features |= NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
> 
>         /* enable hardware checksums */
>         dev->net->features |= NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
>         ax88772b_set_features(dev->net, dev->net->features);
> ...
> }
> -------------------------------snip-----------------------------------
> 
> Does this look correct -- any improvements/fixes to suggest?
[...]

NETIF_F_HW_CSUM means the hardware implements generic IP-style
checksumming: the stack specifies the offset at which to start
checksumming and the offset at which to store the checksum, and the
hardware does not attempt to parse the headers.

If this hardware recognises specific protocols and works out the offsets
itself, then you must claim NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM instead.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

