Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983Ab2EIJKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 05:10:34 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:30183
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834Ab2EIJKc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 05:10:32 -0400
X-SpamScore: 0
X-BigFish: VS0(zz14ffIzz1202hzzz2dh2a8h668h839h8e2h8e3hd25hbe9i)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Agarwal Nikhil-B38457 <B38457@freescale.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-netdev@vger.kernel.org" <linux-netdev@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Memory exhaust issue with only IPsec policies configured on
 continuous traffic
Thread-Topic: Memory exhaust issue with only IPsec policies configured on
 continuous traffic
Thread-Index: Ac0tv28IM+yv7QjhQam8Yx0e57jygwAAbzFQAABj4VAAAAsIEA==
Date: Wed, 9 May 2012 09:10:14 +0000
Message-ID: <F0B93D0554724543876B9A180DC988575B70E7@039-SN1MPN1-001.039d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.134.142]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
               In a typical scenario, when IPSEC policies are configured in the system but SA is not present or negotiation fails or IKE daemon is not running.  The current behavior of xfrm is to send those matching packets to blackhole route.  i.e. xfrm_bundle_lookup returns a bundle with null route and xfrm_lookup returns a blackhole route.

For each of these packet a dst_alloc is called in ipv4_blackhole_route. However when these skbs get free and their dst's get discarded using dst_free and the garbage collector is scheduled using cancel_delayed_work and schedule_delayed_work.

If the packets are coming continuously garbage collector may not get scheduled and large amount of memory is stuck to be freed causing the system to go into non-recoverable state.

Any ideas? 

Regards
Nikhil

