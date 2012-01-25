Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab2AYQ5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 11:57:20 -0500
Received: from mail.vyatta.com ([76.74.103.46]:43399 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883Ab2AYQ5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 11:57:16 -0500
Date: Wed, 25 Jan 2012 08:57:12 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Stefan Gula <steweg@ynet.sk>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v4, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
Message-ID: <20120125085712.524b65a8@nehalam.linuxnetplumber.net>
In-Reply-To: <3900291.2831326843194846.JavaMail.root@5-MeO-DMT.ynet.sk>
References: <18947389.2811326843064500.JavaMail.root@5-MeO-DMT.ynet.sk>
	<3900291.2831326843194846.JavaMail.root@5-MeO-DMT.ynet.sk>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jan 2012 00:33:14 +0100 (CET)
Stefan Gula <steweg@ynet.sk> wrote:

> From: Stefan Gula <steweg@gmail.com>
> 
> This patch is an extension for current Ethernet over GRE
> implementation, which allows user to create virtual bridge (multipoint
> VPN) and forward traffic based on Ethernet MAC address information in
> it. It simulates the Bridge behavior learning mechanism, but instead
> of learning port ID from which given MAC address comes, it learns IP
> address of peer which encapsulated given packet. Multicast, Broadcast
> and unknown-multicast traffic is send over network as multicast
> encapsulated GRE packet, so one Ethernet multipoint GRE tunnel can be
> represented as one single virtual switch on logical level and be also
> represented as one multicast IPv4 address on network level.
> 
> Signed-off-by: Stefan Gula <steweg@gmail.com>

Will this break normal usages of GRE?
Compile time options are not acceptable for a standard distribution if
it will break it for the other case. It is fine to add the additional data
structure elements, but the code in the receive path might get broken?


