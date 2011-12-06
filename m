Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab1LFRpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:45:42 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:7604 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751701Ab1LFRpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:45:41 -0500
Subject: Re: [PATCH] drivers/net/usb/asix:  resync from vendor's copy
From: Ben Hutchings <bhutchings@solarflare.com>
To: Mark Lord <kernel@teksavvy.com>
CC: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <4EDE0E29.9070809@teksavvy.com>
References: <4EA89972.5060101@teksavvy.com>
	 <20111026.194045.2019668159403582571.davem@davemloft.net>
	 <4EA8B283.3010105@teksavvy.com>
	 <20111026.221719.2216112919297458522.davem@davemloft.net>
	 <4EB19BBE.5050602@teksavvy.com> <1320266549.2782.21.camel@bwh-desktop>
	 <4EBAA967.10403@teksavvy.com> <1320856444.18929.78.camel@deadeye>
	 <4EBAAEA5.1060408@teksavvy.com> <4EBAB0EA.1050102@teksavvy.com>
	 <4EBAB643.8020603@teksavvy.com> <1320859911.2781.1.camel@bwh-desktop>
	 <4EBABAFD.6050604@teksavvy.com> <1320860895.2781.6.camel@bwh-desktop>
	 <4EDCD828.2090904@teksavvy.com> <1323098335.7454.214.camel@deadeye>
	 <4EDE0E29.9070809@teksavvy.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Tue, 6 Dec 2011 17:45:37 +0000
Message-ID: <1323193537.2772.9.camel@bwh-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18562.005
X-TM-AS-Result: No--18.479900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-06 at 07:44 -0500, Mark Lord wrote:
> On 11-12-05 10:18 AM, Ben Hutchings wrote:
> > On Mon, 2011-12-05 at 09:41 -0500, Mark Lord wrote:
> > [...]
> >> static int ax88772b_bind(struct usbnet *dev, struct usb_interface *intf)
> >> {
> >> ...
> >>         /* register support for hardware checksums */
> >>         dev->net->hw_features |= NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
> >>
> >>         /* enable hardware checksums */
> >>         dev->net->features |= NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
> >>         ax88772b_set_features(dev->net, dev->net->features);
> >> ...
> >> }
> >> -------------------------------snip-----------------------------------
> >>
> >> Does this look correct -- any improvements/fixes to suggest?
> > [...]
> > 
> > NETIF_F_HW_CSUM means the hardware implements generic IP-style
> > checksumming: the stack specifies the offset at which to start
> > checksumming and the offset at which to store the checksum, and the
> > hardware does not attempt to parse the headers.
> > 
> > If this hardware recognises specific protocols and works out the offsets
> > itself, then you must claim NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM instead.
> 
> Yeah, the hardware seems to understand quite a few protocol formats.
> Okay, so I'll claim the protocol-specific flags in net->hw_features.
> 
> But what do I use in net->features?
> The exact same protocol flags,
> or the generic NETIF_F_HW_CSUM | NETIF_F_RXCSUM ones?

You set the flags for features that are actually being implemented!

But do set NETIF_F_RXCSUM in both places.  The network stack doesn't
know or care exactly what protocols you can do RX checksum validation
for, so there is only one flag for this.  Only the TX checksum
generation features have to be distinguished.

> The set_features() function also has to test for flags
> to know what to do.  Should it test specific protocol flags,
> or just the generic two ?

Think it through.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

