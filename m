Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452Ab1CXAB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 20:01:26 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:9366 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023Ab1CXABY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 20:01:24 -0400
Subject: Re: [RFC] usbnet: use eth%d name for known ethernet devices
From: Ben Hutchings <bhutchings@solarflare.com>
To: Steve Calfee <stevecalfee@gmail.com>
Cc: Michal Nazarewicz <mnazarewicz@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Arnd Bergmann <arnd@arndb.de>,
        broonie@opensource.wolfsonmicro.com,
        lkml <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Greg KH <greg@kroah.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, grant.likely@secretlab.ca,
        Linux USB list <linux-usb@vger.kernel.org>, andy.green@linaro.org,
        netdev@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        roger.quadros@nokia.com, Jaswinder Singh <jaswinder.singh@linaro.org>
In-Reply-To: <4D8A8471.9060904@gmail.com>
References: <4D79F068.2080009@linaro.org> <201103232035.18232.arnd@arndb.de>
	 <AANLkTim7hPfTv3gDYnh+jGxHBg0OvX=r1FKYoHnH7H_o@mail.gmail.com>
	 <201103232057.18150.arnd@arndb.de>
	 <20110323125958.76285c0f.rdunlap@xenotime.net>
	 <8762r9l94h.fsf@erwin.mina86.com>  <4D8A8471.9060904@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Thu, 24 Mar 2011 00:01:18 +0000
Message-ID: <1300924878.2638.38.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 24 Mar 2011 00:01:23.0717 (UTC) FILETIME=[9CFA7350:01CBE9B6]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18028.005
X-TM-AS-Result: No--19.308100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-23 at 16:38 -0700, Steve Calfee wrote:
> On 03/23/11 16:17, Michal Nazarewicz wrote:
> >>>>>>> @@ -97,6 +97,8 @@ struct driver_info {
> >>>>>>>
> >>>>>>>   #define FLAG_LINK_INTR       0x0800          /* updates link (carrier) status */
> >>>>>>>
> >>>>>>> +#define FLAG_PTP     0x1000          /* maybe use "usb%d" names */
> >
> >>>>> On Wednesday 23 March 2011 19:46:50 Greg KH wrote:
> >>>>>> "PTP"?  What does that stand for?
> >
> >>>> On Mar 23, 2011 8:36 PM, "Arnd Bergmann"<arnd@arndb.de>  wrote:
> >>>>> point-to-point, I'll improve the comment to spell it out when
> >>>>> I send the fixed version.
> >
> >>> On Wednesday 23 March 2011 20:53:13 Michał Nazarewicz wrote:
> >>>> I think P2P could be better.
> >
> >> On Wed, 23 Mar 2011 20:57:18 +0100 Arnd Bergmann wrote:
> >>> Yes, good idea.
> >
> > Randy Dunlap<rdunlap@xenotime.net>  writes:
> >> that's peer-to-peer.
> >>
> >> OTOH, I knew that PTP was point-to-point.
> >
> > It can be any of that, depending on context.  For me PTP is more like
> > Picture Transport Protocol, whereas "2" between two letters is usually
> > "to".
> >
> Well, my 2 cents, picture transport protocol is so obviously different 
> than flags for network interfaces it does not cause a mental collision. 

PTP is also Precision Time Protocol, which *is* used on network
interfaces (maybe not USB-connected interfaces though).

Anyway, these USB cable interfaces can presumably be bridged to standard
Ethernet, so they are really no more point-to-point than any other
Ethernet link has been since the demise of the hub.

> However P2P is about to become a huge wifi issue, which definitely is in 
> the network space. So don't confuse things in the near future, don't use 
> P2P.
>
> Maybe a completely different, not so overused flag name would be better.

How about FLAG_NON_IEEE, meaning that the physical layer is not based on
an IEEE 802.3, 802.11 or other standard physical layer.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

