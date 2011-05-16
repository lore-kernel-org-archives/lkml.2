Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab1EPMsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:48:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36341 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036Ab1EPMsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:48:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=i2tN8d/gwpL1pyT+I6+l19/p/EFh911TV5jufq1UzTwQR9oVnxAQU7ZE8jfmkDxVgi
         eqErPFN18XSH4IguTxQjAbmD7yyYCfmj2pPfnCmQ+AofWlSFcVvzPOVH08vXfvZDXJou
         HzX4vxIgy7DaoP41LDUVQzmNj+lOldwYLS8Lc=
Date: Mon, 16 May 2011 16:48:28 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, solar@openwall.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        peak@argo.troja.mff.cuni.cz, kees.cook@canonical.com,
        dan.j.rosenberg@gmail.com, eugene@redhat.com, nelhage@ksplice.com,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Subject: Re: [PATCH net-next-2.6 v2] net: ping: dont call udp_ioctl()
Message-ID: <20110516124828.GA5943@albatros>
References: <1305447520.3120.88.camel@edumazet-laptop>
 <20110515213018.GA26820@openwall.com>
 <20110515.174430.1379973540554096232.davem@davemloft.net>
 <1305530791.3120.217.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1305530791.3120.217.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 09:26 +0200, Eric Dumazet wrote:
> Le dimanche 15 mai 2011 à 17:44 -0400, David Miller a écrit :
> 
> > Just get rid of ping_ioctl() entirely, as that is the effect of
> > this change since inet_ioctl() returns -ENOIOCTLCMD when
> > sk_prot->ioctl is NULL.
> > 
> > Also get rid of asm/ioctls.h since that will be no longer needed.
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

Acked-by: Vasiliy Kulikov <segoon@openwall.com>

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
