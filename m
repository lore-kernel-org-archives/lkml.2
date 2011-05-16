Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab1EPPzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 11:55:06 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40559 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299Ab1EPPzD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 11:55:03 -0400
Date: Mon, 16 May 2011 11:50:32 -0400 (EDT)
Message-Id: <20110516.115032.697943097693018627.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: solar@openwall.com, segoon@openwall.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, peak@argo.troja.mff.cuni.cz,
        kees.cook@canonical.com, dan.j.rosenberg@gmail.com, eugene@redhat.com,
        nelhage@ksplice.com, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net
Subject: Re: [PATCH net-next-2.6 v2] net: ping: dont call udp_ioctl()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1305530791.3120.217.camel@edumazet-laptop>
References: <20110515213018.GA26820@openwall.com>
	<20110515.174430.1379973540554096232.davem@davemloft.net>
	<1305530791.3120.217.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 16 May 2011 08:50:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 16 May 2011 09:26:31 +0200

> Le dimanche 15 mai 2011 à 17:44 -0400, David Miller a écrit :
> 
>> Just get rid of ping_ioctl() entirely, as that is the effect of
>> this change since inet_ioctl() returns -ENOIOCTLCMD when
>> sk_prot->ioctl is NULL.
>> 
>> Also get rid of asm/ioctls.h since that will be no longer needed.
> 
> Sure, here is updated version, thanks.
> 
> [PATCH net-next-2.6 v2] net: ping: dont call udp_ioctl()
> 
> udp_ioctl() really handles UDP and UDPLite protocols.
> 
> 1) It can increment UDP_MIB_INERRORS in case first_packet_length() finds
> a frame with bad checksum.
> 
> 2) It has a dependency on sizeof(struct udphdr), not applicable to
> ICMP/PING
> 
> If ping sockets need to handle SIOCINQ/SIOCOUTQ ioctl, this should be
> done differently.
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> CC: Vasiliy Kulikov <segoon@openwall.com>

Applied, thanks.
