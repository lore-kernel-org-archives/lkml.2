Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab1LFReX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:34:23 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53658 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751417Ab1LFReW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:34:22 -0500
X-Sasl-enc: GfTlYB1+fgjvwaXQxEqNAI1LkK0R8at0Tx32JWSE+cKr 1323192861
Date: Tue, 6 Dec 2011 09:32:20 -0800
From: Greg KH <greg@kroah.com>
To: Ted Feng <artisdom@gmail.com>
Cc: Jiri Pirko <jpirko@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Josh Boyer <jwboyer@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ipip, sit: copy parms.name after register_netdevice
Message-ID: <20111206173220.GA28763@kroah.com>
References: <CAM7b5hzt8D6hn3=XEcm9E3_BwJxj-YABpkufCpuhjiPLDxCsMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM7b5hzt8D6hn3=XEcm9E3_BwJxj-YABpkufCpuhjiPLDxCsMQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 05:25:24PM +0800, Ted Feng wrote:
> Same fix as 731abb9cb2 for ipip and sit tunnel.
> Commit 1c5cae815d removed an explicit call to dev_alloc_name in
> ipip_tunnel_locate
> and ipip6_tunnel_locate, because register_netdevice will now create a
> valid name.
> However the tunnel keeps a copy of the name in the private parms structure.
> 
> This shows up if you do a simple tunnel add, followed by a tunnel show:
> 
> $ sudo ip tunnel add mode ipip remote 10.2.20.211
> $ ip tunnel
> tunl0: ip/ip  remote any  local any  ttl inherit  nopmtudisc
> tunl%d: ip/ip  remote 10.2.20.211  local any  ttl inherit
> $ sudo ip tunnel add mode sit remote 10.2.20.212
> $ ip tunnel
> sit0: ipv6/ip  remote any  local any  ttl 64  nopmtudisc 6rd-prefix 2002::/16
> sit%d: ioctl 89f8 failed: No such device
> sit%d: ipv6/ip  remote 10.2.20.212  local any  ttl inherit
> 
> Signed-off-by: Ted Feng <artisdom@gmail.com>

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
