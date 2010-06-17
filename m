Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab0FQFRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 01:17:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:38641 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab0FQFRG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 01:17:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,429,1272870000"; 
   d="scan'208";a="631125560"
From: "Shi, Alex" <alex.shi@intel.com>
To: "Fastabend, John R" <john.r.fastabend@intel.com>,
       David Miller <davem@davemloft.net>,
       "markus@trippelsdorf.de" <markus@trippelsdorf.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
       "Chen, Tim C" <tim.c.chen@intel.com>
Date: Thu, 17 Jun 2010 13:16:56 +0800
Subject: RE: mpd client timeouts (bisected) 2.6.35-rc3
Thread-Topic: mpd client timeouts (bisected) 2.6.35-rc3
Thread-Index: AcsLOBym1TqeRZEuRwWgKFNKXB7qhgCjafbg
Message-ID: <6E3BC7F7C9A4BF4286DD4C043110F30B18EBD46A25@shsmsx502.ccr.corp.intel.com>
References: <20100612102802.GA1782@arch.tripp.de>
 <20100612.145835.123986343.davem@davemloft.net> <4C149147.3080808@intel.com>
 <4C15414E.5090201@intel.com>
In-Reply-To: <4C15414E.5090201@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It fixed the aim7/specjbb2005 issues! 

Tested-by: Alex Shi <alex.shi@intel.com>


Regards! 
Alex  

>
>Needed to set the wcard bit in copy_skb_header otherwise it will not be cleared
>when called from skb_clone.  Which then hits the loopback device gets pushed
>into the rx path and is eventually dropped. The following patch fixes this.
>Hopefully, this is easy and fast enough for you Dave.
>
>
>[PATCH] net: fix deliver_no_wcard regression on loopback device
>
>deliver_no_wcard is not being set in skb_copy_header.
>In the skb_cloned case it is not being cleared and
>may cause the skb to be dropped when the loopback device
>pushes it back up the stack.
>
>Signed-off-by: John Fastabend <john.r.fastabend@intel.com>
>---
>
>  net/core/skbuff.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
>diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>index 9f07e74..bcf2fa3 100644
>--- a/net/core/skbuff.c
>+++ b/net/core/skbuff.c
>@@ -532,6 +532,7 @@ static void __copy_skb_header(struct sk_buff *new, const
>struct sk_buff *old)
>  	new->ip_summed		= old->ip_summed;
>  	skb_copy_queue_mapping(new, old);
>  	new->priority		= old->priority;
>+	new->deliver_no_wcard	= old->deliver_no_wcard;
>  #if defined(CONFIG_IP_VS) || defined(CONFIG_IP_VS_MODULE)
>  	new->ipvs_property	= old->ipvs_property;
>  #endif
