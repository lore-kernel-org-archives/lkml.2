Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab0C2CPs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 22:15:48 -0400
Received: from mail.perches.com ([173.55.12.10]:1194 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827Ab0C2CPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 22:15:46 -0400
Subject: Re: linux-next: build warning after merge of the tree
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, kyle@mcmartin.ca
In-Reply-To: <20100328.185707.161194820.davem@davemloft.net>
References: <20100329103139.1a735227.sfr@canb.auug.org.au>
	 <20100328.185707.161194820.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 28 Mar 2010 19:15:44 -0700
Message-ID: <1269828944.1500.105.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-03-28 at 18:57 -0700, David Miller wrote:
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> > After merging the  tree, today's linux-next build (x86_64 allmodconfig)
> > produced this warning:
> > drivers/net/tulip/uli526x.c: In function 'uli526x_rx_packet':
> > drivers/net/tulip/uli526x.c:861: warning: assignment makes pointer from integer without a cast
> I just committed the following, let me know if it fixes
> this.
> -				    ((new_skb = dev_alloc_skb(rxlen + 2) != NULL))) {
> +				    (((new_skb = dev_alloc_skb(rxlen + 2)) != NULL))) {

You've an extra () there.

A close paren could have been moved from after
the NULL to after the "+ 2"

I think it's more readable as:
				      (new_skb = dev_alloc_skb(rxlen + 2))) {

cheers, Joe

