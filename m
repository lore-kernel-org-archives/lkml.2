Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab0IOTPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 15:15:00 -0400
Received: from mail.perches.com ([173.55.12.10]:2071 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755026Ab0IOTO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 15:14:59 -0400
Subject: Re: [RFC PATCH] drivers/net/tg3.c: Raise Jumbo Frame MTU to 9216?
From: Joe Perches <joe@perches.com>
To: Michael Chan <mchan@broadcom.com>
Cc: Matthew Carlson <mcarlson@broadcom.com>, Benjamin Li <benli@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1284573454.8929.221.camel@HP1>
References: <1284572516.10223.12.camel@Joe-Laptop>
	 <1284573454.8929.221.camel@HP1>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 12:14:55 -0700
Message-ID: <1284578095.10223.27.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-15 at 10:57 -0700, Michael Chan wrote:
> On Wed, 2010-09-15 at 10:41 -0700, Joe Perches wrote:
> > The TG3 apparently supports 9K frame sizes.
> > http://www.broadcom.com/collateral/pb/5704C-PB05-R.pdf
> > Is exactly 9000 a hardware limit?
> > Should the jumbo frame MTU be raised to 9216 or 9216
> > less the size of MAC, VLAN, IP and TCP headers?
> 9000 has been the de facto standard, has it been changed recently?

I know of a performance lab that's trying to use 9216 as a "standard"
jumbo frame length.

Unrelated to the performance lab:
http://www.uoregon.edu/~joe/jumbo-clean-gear.html
9216 seems popular, especially with Cisco gear.
Contrary to that link, the Cisco 3750 does work with 9216 length
jumbo frames.

> Anyway, we've never done any testing on 9216.  As it uses up to 2 more
> internal mbufs per packet, there may not be sufficient buffers inside
> the chip for optimal operations.  At best, some water marks will need to
> be tweaked.  The hardware statistics counters (ethtool -S) also may not
> work for packets bigger than 9022 bytes.

Thanks, do you have pointers to where the tweaking needs to be done?

Is this define a hardware upper bound?
#define TG3_RX_JMB_DMA_SZ		9046

cheers, Joe

