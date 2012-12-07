Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423947Ab2LGT2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 14:28:49 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:57817 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab2LGT2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 14:28:48 -0500
Date: Fri, 07 Dec 2012 14:28:45 -0500 (EST)
Message-Id: <20121207.142845.1145515122357569641.davem@davemloft.net>
To: joseph.gasparakis@intel.com
Cc: bhutchings@solarflare.com, alexander.h.duyck@intel.com,
        shemminger@vyatta.com, chrisw@sous-sol.org, gospo@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry@broadcom.com, saeed.bishara@gmail.com,
        peter.p.waskiewicz.jr@intel.com
Subject: Re: [PATCH v3 1/4] net: Add support for hardware-offloaded
 encapsulation
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.02.1212071013200.30243@morpheus.jf.intel.com>
References: <50C21D21.5040101@intel.com>
	<1354900385.2707.42.camel@bwh-desktop.uk.solarflarecom.com>
	<alpine.LFD.2.02.1212071013200.30243@morpheus.jf.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joseph Gasparakis <joseph.gasparakis@intel.com>
Date: Fri, 7 Dec 2012 10:24:17 -0800 (PST)

> So the idea here is that the driver will use the headers for checksumming 
> if the skb->encapsulation bit is on. The bit should be set in the protocol 
> driver.
> 
> To answer the second comment, the flags that we use in this series of 
> patches is NETIF_F_IP_CSUM, NETIF_F_IPV6_CSUM and NETIF_F_SG. These are 
> the bits that we propose will be used for checksumming of encapsulation. 
> As per a previous comment in v2, the hw_enc_features field should be used 
> also in the future when NICs have more encap offloads, so one could
> indicate these features there from the driver.
> 
> Furthermore, I submitted a patch for Rx checksumming, where NETIF_F_RXCSUM 
> is used, again in conjunction with skb->encapsulation flag. As I mention 
> in my logs, the driver is expected to set the ip_summed to UNNECESSARY and 
> turn the skb->encapsulation on, to indicate that the inner headers are 
> already HW checksummed.
> 

This is the kind of language that belongs in the commit message and
code comments.
