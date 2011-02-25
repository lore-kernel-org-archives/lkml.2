Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab1BYLkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 06:40:49 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46995 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab1BYLks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 06:40:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=i4eCdMCUeMyVBvl+/w7hnMo9jI+yAVKS21UdvLipBV2M4HhSPbJPi+pIDnPZCGhpEu
         Db9Xa44gTXfU4tFSdl4hhULV6y+BPOYQmh/Wmz1RbIjGequTNLImlmkO+Km3SvO3ZjBz
         5R7Nsbn//O3fCYYE0dNhe0p0ovwlEhHj447zk=
Subject: Re: [PATCH v6] net: add Faraday FTMAC100 10/100 Ethernet driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, joe@perches.com, dilinger@queued.net,
        mirqus@gmail.com, davem@davemloft.net,
        Po-Yu Chuang <ratbert@faraday-tech.com>
In-Reply-To: <1298627845-1583-1-git-send-email-ratbert.chuang@gmail.com>
References: <1298539762-2242-1-git-send-email-ratbert.chuang@gmail.com>
	 <1298627845-1583-1-git-send-email-ratbert.chuang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 12:40:40 +0100
Message-ID: <1298634040.2659.32.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 25 février 2011 à 17:57 +0800, Po-Yu Chuang a écrit :
> From: Po-Yu Chuang <ratbert@faraday-tech.com>
> 
> FTMAC100 Ethernet Media Access Controller supports 10/100 Mbps and
> MII.  This driver has been working on some ARM/NDS32 SoC's including
> Faraday A320 and Andes AG101.
> 
> Signed-off-by: Po-Yu Chuang <ratbert@faraday-tech.com>

It seems fine to me, but I have somes questions 

1) On V5, the receive function ftmac100_rx_packet() was able to process
several segments per skb. On V6 you process one frag only.

Isnt this NIC able to handle large MTU (say... 9000) ?

2) ftmac100_alloc_rx_page() is called and allocate a full page for a
rxdes.

128*4K -> 512 Kbytes of memory for RX ring

In V5, you were using half pages only, so 256 kbytes of memory.

If you look at other drivers (NIU, BENET), they are able to use exactly
128*2 kbytes (for a rxring of 128 slots, and 2Kbytes per slot)



