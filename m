Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab2KLBkK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 20:40:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:3409 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab2KLBkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 20:40:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,759,1344236400"; 
   d="scan'208";a="247374887"
Date: Sun, 11 Nov 2012 17:47:55 -0800 (PST)
From: Joseph Gasparakis <joseph.gasparakis@intel.com>
X-X-Sender: jgaspara@morpheus.jf.intel.com
To: Dmitry Kravkov <dmitry@broadcom.com>
cc: Joseph Gasparakis <joseph.gasparakis@intel.com>, davem@davemloft.net,
        shemminger@vyatta.com, chrisw@sous-sol.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [PATCH 3/3] ipgre: capture inner headers during encapsulation
In-Reply-To: <1352647110.5201.4.camel@lb-tlvb-dmitry.il.broadcom.com>
Message-ID: <alpine.LFD.2.02.1211111746450.29318@morpheus.jf.intel.com>
References: <1352427483-4380-1-git-send-email-joseph.gasparakis@intel.com> <1352427483-4380-4-git-send-email-joseph.gasparakis@intel.com> <1352647110.5201.4.camel@lb-tlvb-dmitry.il.broadcom.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
ReplyTo: "Joseph Gasparakis" <joseph.gasparakis@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 11 Nov 2012, Dmitry Kravkov wrote:

> On Thu, 2012-11-08 at 18:18 -0800, Joseph Gasparakis wrote:
> >  
> >  	if (skb->ip_summed == CHECKSUM_PARTIAL &&
> >  	    skb_checksum_help(skb))
> > @@ -902,6 +903,17 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff *skb, struct net_device *dev
> >  			tunnel->err_count = 0;
> >  	}
> >  
> > +	offset = skb->data - skb->head;
> > +
> > +	skb_reset_inner_mac_header(skb);
> > +
> > +	if (skb->network_header)
> > +		skb_set_inner_network_header(skb, skb->network_header - offset);
> > +
> > +	if (skb->transport_header)
> > +		skb_set_inner_transport_header(skb, skb->transport_header -
> > +					       offset);
> > +
> >  	max_headroom = LL_RESERVED_SPACE(tdev) + gre_hlen + rt->dst.header_len;
> >  
> >  	if (skb_headroom(skb) < max_headroom || skb_shared(skb)||
> 
> How it will be useful if skb_checksum_help(skb) will calculate csum? And
> leaves nothing to offload 
>
Thanks for catching this Dmitry. Will fix it in v2 
