Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab0GKMdT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 08:33:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305Ab0GKMdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 08:33:17 -0400
Date: Sun, 11 Jul 2010 15:27:08 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, herbert.xu@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH] netfilter: add CHECKSUM target
Message-ID: <20100711122708.GA3573@redhat.com>
References: <20100708222913.GA4475@redhat.com>
 <alpine.LSU.2.01.1007091154120.7235@obet.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.1007091154120.7235@obet.zrqbmnf.qr>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 09, 2010 at 11:56:26AM +0200, Jan Engelhardt wrote:
> 
> On Friday 2010-07-09 00:29, Michael S. Tsirkin wrote:
> >
> > include/linux/netfilter_ipv4/ipt_CHECKSUM.h |   18 +++++++
> > net/ipv4/netfilter/Kconfig                  |   16 ++++++
> > net/ipv4/netfilter/Makefile                 |    1 +
> > net/ipv4/netfilter/ipt_CHECKSUM.c           |   72 +++++++++++++++++++++++++++
> 
> New modules should use xt.

I tried moving the module to xt_CHECKSUM but now
	iptables -A POSTROUTING -t mangle -p udp --dport 68 -j CHECKSUM --checksum-fill
does not to load the module.
It seems that xt_request_find_target in x_tables uses the prefix 'ip' for a module.
What am I missing?

> >+static unsigned int
> >+checksum_tg(struct sk_buff *skb, const struct xt_action_param *par)
> >+{
> >+	if (skb->ip_summed == CHECKSUM_PARTIAL) {
> >+		skb_checksum_help(skb);
> >+	}
> 
> - {}
