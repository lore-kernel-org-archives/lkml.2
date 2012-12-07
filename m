Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424027Ab2LGTh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 14:37:29 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:57932 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab2LGTh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 14:37:28 -0500
Date: Fri, 07 Dec 2012 14:37:25 -0500 (EST)
Message-Id: <20121207.143725.1501926484331042018.davem@davemloft.net>
To: joseph.gasparakis@intel.com
Cc: bhutchings@solarflare.com, alexander.h.duyck@intel.com,
        shemminger@vyatta.com, chrisw@sous-sol.org, gospo@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry@broadcom.com, saeed.bishara@gmail.com,
        peter.p.waskiewicz.jr@intel.com
Subject: Re: [PATCH v3 1/4] net: Add support for hardware-offloaded
 encapsulation
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.02.1212071139190.4985@morpheus.jf.intel.com>
References: <alpine.LFD.2.02.1212071013200.30243@morpheus.jf.intel.com>
	<20121207.142845.1145515122357569641.davem@davemloft.net>
	<alpine.LFD.2.02.1212071139190.4985@morpheus.jf.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joseph Gasparakis <joseph.gasparakis@intel.com>
Date: Fri, 7 Dec 2012 11:41:46 -0800 (PST)

> 
> 
> On Fri, 7 Dec 2012, David Miller wrote:
> 
>> From: Joseph Gasparakis <joseph.gasparakis@intel.com>
>> Date: Fri, 7 Dec 2012 10:24:17 -0800 (PST)
>> 
>> > So the idea here is that the driver will use the headers for checksumming 
>> > if the skb->encapsulation bit is on. The bit should be set in the protocol 
>> > driver.
>> > 
>> > To answer the second comment, the flags that we use in this series of 
>> > patches is NETIF_F_IP_CSUM, NETIF_F_IPV6_CSUM and NETIF_F_SG. These are 
>> > the bits that we propose will be used for checksumming of encapsulation. 
>> > As per a previous comment in v2, the hw_enc_features field should be used 
>> > also in the future when NICs have more encap offloads, so one could
>> > indicate these features there from the driver.
>> > 
>> > Furthermore, I submitted a patch for Rx checksumming, where NETIF_F_RXCSUM 
>> > is used, again in conjunction with skb->encapsulation flag. As I mention 
>> > in my logs, the driver is expected to set the ip_summed to UNNECESSARY and 
>> > turn the skb->encapsulation on, to indicate that the inner headers are 
>> > already HW checksummed.
>> > 
>> 
>> This is the kind of language that belongs in the commit message and
>> code comments.
>> 
> Sure. I'll wait to gather some more feedback if there is any and I will 
> re-spin this off adding more code comments and clarify this in the logs.

Great.

Please note that this request applies to your receive side change too.
