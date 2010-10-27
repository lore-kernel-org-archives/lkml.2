Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229Ab0J0NX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 09:23:28 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42717 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758164Ab0J0NX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 09:23:26 -0400
MIME-Version: 1.0
X-Originating-IP: [89.235.167.66]
Date: Wed, 27 Oct 2010 17:23:24 +0400
Message-ID: <AANLkTikmNCogLY3ZVhtfxOnSpWdPMq1YBCM3ZprkxEsP@mail.gmail.com>
Subject: [PATCH 0/5] tcp: ipv4 listen state scaling
From: Dmitry Popov <dp@highloadlab.com>
To: "David S. Miller" <davem@davemloft.net>, William.Allen.Simpson@gmail.com,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andreas Petlund <apetlund@simula.no>,
        Shan Wei <shanwei@cn.fujitsu.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Octavian Purdila <opurdila@ixiacom.com>,
        =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Evgeniy Polyakov <zbr@ioremap.net>,
        Laurent Chavey <chavey@google.com>,
        Gilad Ben-Yossef <gilad@codefidence.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "Steven J. Magnani" <steve@digidescorp.com>,
        Joe Perches <joe@perches.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Yony Amit <yony@comsleep.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*Note: this patch depends on "[PATCH] tcp: md5 signature check scaling"*
Hi.

The problem with current TCP stack implementation is that it locks
socket in tcp_v4_rcv on each incoming packet. However, incoming SYNs
may be processed in parallel with syncookies. And it helps a lot under
synflood. This proposed patch serie fixes this problem, but (as for
now) for ipv4 only.
6-core Xeon with 6 RX queues on NIC:
without patch: 530k syn-pkts/s;
with patch: 1620k syn-pkts/s.

Discussion?
