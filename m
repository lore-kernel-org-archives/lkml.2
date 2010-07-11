Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab0GKMpx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 08:45:53 -0400
Received: from borg.medozas.de ([188.40.89.202]:44264 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049Ab0GKMpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 08:45:51 -0400
Date: Sun, 11 Jul 2010 14:45:49 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, herbert.xu@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH] netfilter: add CHECKSUM target
In-Reply-To: <20100711122708.GA3573@redhat.com>
Message-ID: <alpine.LSU.2.01.1007111445320.6015@obet.zrqbmnf.qr>
References: <20100708222913.GA4475@redhat.com> <alpine.LSU.2.01.1007091154120.7235@obet.zrqbmnf.qr> <20100711122708.GA3573@redhat.com>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2010-07-11 14:27, Michael S. Tsirkin wrote:
>> >
>> > include/linux/netfilter_ipv4/ipt_CHECKSUM.h |   18 +++++++
>> > net/ipv4/netfilter/Kconfig                  |   16 ++++++
>> > net/ipv4/netfilter/Makefile                 |    1 +
>> > net/ipv4/netfilter/ipt_CHECKSUM.c           |   72 +++++++++++++++++++++++++++
>> 
>> New modules should use xt.
>
>I tried moving the module to xt_CHECKSUM but now
>	iptables -A POSTROUTING -t mangle -p udp --dport 68 -j CHECKSUM --checksum-fill
>does not to load the module.
>It seems that xt_request_find_target in x_tables uses the prefix 'ip' for a module.
>What am I missing?

MODULE_ALIAS like the others have.
