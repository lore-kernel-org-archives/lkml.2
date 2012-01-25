Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab2AYFxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 00:53:35 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38787 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab2AYFxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 00:53:34 -0500
Message-ID: <1327470810.14373.39.camel@edumazet-laptop>
Subject: Re: [patch v4, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stefan Gula <steweg@ynet.sk>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 25 Jan 2012 06:53:30 +0100
In-Reply-To: <3900291.2831326843194846.JavaMail.root@5-MeO-DMT.ynet.sk>
References: <3900291.2831326843194846.JavaMail.root@5-MeO-DMT.ynet.sk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 18 janvier 2012 à 00:33 +0100, Stefan Gula a écrit :
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
> 
> ---
> 

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

I guess remaining performance point is to get a refcount less
ip_route_output_gre(), aka ip_route_output_gre_noref() :)



