Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab0GIHSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 03:18:55 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:49271 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878Ab0GIHSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 03:18:49 -0400
Date: Fri, 9 Jul 2010 15:18:14 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
       James Morris <jmorris@namei.org>,
       Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netfilter@vger.kernel.org, coreteam@netfilter.org,
       netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] netfilter: add CHECKSUM target
Message-ID: <20100709071814.GA27964@gondor.apana.org.au>
References: <20100708222913.GA4475@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100708222913.GA4475@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 09, 2010 at 01:29:13AM +0300, Michael S. Tsirkin wrote:
> This adds a `CHECKSUM' target, which can be used in the iptables mangle
> table.
> 
> You can use this target to compute and fill in the checksum in
> an IP packet that lacks a checksum.  This is particularly useful,
> if you need to work around old applications such as dhcp clients,
> that do not work well with checksum offloads, but don't want to
> disable checksum offload in your device.
> 
> The problem happens in the field with virtualized applications.
> For reference, see Red Hat bz 605555, as well as
> http://www.spinics.net/lists/kvm/msg37660.html
> 
> Typical expected use (helps old dhclient binary running in a VM):
> iptables -A POSTROUTING -t mangle -p udp --dport 68 -j CHECKSUM
> --checksum-fill
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

I'd think that this target would be protocol-agnostic, no?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
