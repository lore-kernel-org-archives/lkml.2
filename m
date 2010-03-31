Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169Ab0CaKLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 06:11:30 -0400
Received: from mailgw01.datarespons.com ([81.0.189.39]:2160 "EHLO
	mailgw01.datarespons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933001Ab0CaKL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 06:11:29 -0400
Date: Wed, 31 Mar 2010 12:11:20 +0200
From: Anders Darander <anders.darander@datarespons.se>
To: Jiri Pirko <jpirko@redhat.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       "David S. Miller" <davem@davemloft.net>,
       Erik Waling <erik.waling@konftel.com>,
       Patrick McHardy <kaber@trash.net>,
       Grant Likely <grant.likely@secretlab.ca>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MACB: Set PHY address in kernel parameters
Message-ID: <20100331101120.GJ4837@datarespons.se>
References: <1270021902-6556-1-git-send-email-anders.darander@gmail.com>
 <20100331100313.GA4053@psychotron.lab.eng.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331100313.GA4053@psychotron.lab.eng.brq.redhat.com>
X-Accept-Language: sv, en, de
X-GPG-Fingerprint: A8FE 0294 BA4B 6981 DD9A  2900 C5C7 016C B47B AE60
X-GPG-Key-Id: 0xB47BAE60
X-GPG-Keyserver: hkp://keys.gnupg.net
Organization: Data Respons AB
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 31 Mar 2010 10:11:25.0976 (UTC) FILETIME=[85BD7180:01CAD0BA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jiri Pirko <jpirko@redhat.com> [100331 12:03]:
> Wed, Mar 31, 2010 at 09:51:42AM CEST, anders.darander@gmail.com wrote:
> > 
> >-	phydev = phy_find_first(bp->mii_bus);
> >+	if (phy_addr >= PHY_MAX_ADDRESS)
> >+		phydev = phy_find_first(bp->mii_bus);
> >+	else
> >+		phydev = bp->mii_bus->phy_map[phy_addr];
> >+
> > 	if (!phydev) {
> > 		printk (KERN_ERR "%s: no PHY found\n", dev->name);
> > 		return -1;
> 
> This is really ugly :( Should be done differently, more general. I've been
> thinking about this for a while. Maybe the solution is to integrate the switch
> into DSA subsystem. See net/dsa. Not sure though...

A more general solution is always welcome...

However, although I've not tested it, I think that Marc Kleine-Budde
came up with the correct solution. That was using phy_mask, and set it
up in the *eth_data structure in the board setup code.

Thus, it seems that the needed functionality is readily available.
(Working in the embedded field, I've no problem with defining HW-related
things in the board setup code, as opposite of having it dynamically
defined).

Regards,
Anders

