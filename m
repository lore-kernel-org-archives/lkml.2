Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab1EOVaq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 17:30:46 -0400
Received: from mother.openwall.net ([195.42.179.200]:45613 "HELO
	mother.openwall.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752334Ab1EOVan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 17:30:43 -0400
Date: Mon, 16 May 2011 01:30:18 +0400
From: Solar Designer <solar@openwall.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        peak@argo.troja.mff.cuni.cz, kees.cook@canonical.com,
        dan.j.rosenberg@gmail.com, eugene@redhat.com, nelhage@ksplice.com,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Subject: Re: [PATCH net-next-2.6] net: ping: dont call udp_ioctl()
Message-ID: <20110515213018.GA26820@openwall.com>
References: <20110510.121550.112583080.davem@davemloft.net> <20110513200100.GA3875@albatros> <1305447520.3120.88.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305447520.3120.88.camel@edumazet-laptop>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 15, 2011 at 10:18:40AM +0200, Eric Dumazet wrote:
> Do we really need to support SIOCOUTQ and SIOCINQ ioctls for ping
> sockets ?

Probably not.

> BTW, link
> (ftp://mirrors.kernel.org/openwall/Owl/current/sources/Owl/packages/iputils/iputils-ss020927.tar.gz ) provided in http://openwall.info/wiki/people/segoon/ping is not working.
> 
> I had to manually patch iputils-s20101006.tar.bz2 instead.

Oh, the link broke precisely because we updated to s20101006 since then,
and the link was to our current branch.  I've just updated the wiki page
to include links both for iputils-ss020927 and for iputils-s20101006
(both original tarballs and patches).

> [PATCH net-next-2.6] net: ping: dont call udp_ioctl()
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

Reviewed-by: Solar Designer <solar@openwall.com>

Thanks,

Alexander
