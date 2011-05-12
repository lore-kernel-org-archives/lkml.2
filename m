Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab1ELVdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:33:22 -0400
Received: from mail.perches.com ([173.55.12.10]:1579 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932821Ab1ELVdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:33:21 -0400
Subject: Re: [PATCH] net: af_packet: Don't initialize vnet_hdr
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20110512.172623.220889608152651989.davem@davemloft.net>
References: <18a010357eb63dfd50751c5eb529f6261cf90ecd.1305232529.git.joe@perches.com>
	 <20110512.172623.220889608152651989.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 14:33:20 -0700
Message-ID: <1305236000.6124.67.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 17:26 -0400, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Thu, 12 May 2011 13:36:10 -0700
> 
> > Save a memset, initialize only the portion necessary.
> > 
> > packet_snd either gets this structure completely from
> > memcpy_fromiovec or uses only the hdr_len set to 0,
> > so don't always initialize the structure to 0.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> On ARM this won't be tightly packed, therefore you'll leave
> uninitialized pieces of padding in this structure and this
> thing is an "on-the-wire" network header.
> 
> I'm not applying this.

I believe that it's only sent when po->has_vnet_hdr
is set.  In that case, it's completely filled from
memcpy_fromiovec.  In the not set po->has_vnet_hdr case,
only vnet_hdr.hdr_len is accessed by packet_alloc_skb.

cheers, Joe


