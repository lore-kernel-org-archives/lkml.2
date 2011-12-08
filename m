Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab1LHEQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 23:16:15 -0500
Received: from mail.vyatta.com ([76.74.103.46]:55794 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756547Ab1LHEQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 23:16:13 -0500
Date: Wed, 7 Dec 2011 20:16:10 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Ted Feng <artisdom@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jiri Pirko <jpirko@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipip, sit: copy parms.name after register_netdevice
Message-ID: <20111207201610.7cc9714a@nehalam.linuxnetplumber.net>
In-Reply-To: <CAM7b5hyXkRTUwnE-NwXEff-34WjRfMSBDf2itMVhdJGi4XoA=g@mail.gmail.com>
References: <CAM7b5hzt8D6hn3=XEcm9E3_BwJxj-YABpkufCpuhjiPLDxCsMQ@mail.gmail.com>
	<20111206173220.GA28763@kroah.com>
	<CAM7b5hyXkRTUwnE-NwXEff-34WjRfMSBDf2itMVhdJGi4XoA=g@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Dec 2011 11:35:15 +0800
Ted Feng <artisdom@gmail.com> wrote:

> From: Ted Feng <artisdom@gmail.com>
> Same fix as 731abb9cb2 for ipip and sit tunnel.
> Commit 1c5cae815d removed an explicit call to dev_alloc_name in
> ipip_tunnel_locate and ipip6_tunnel_locate, because register_netdevice
> will now create a valid name. However the tunnel keeps a copy of the
> name in the private parms structure.
> 
> This shows up if you do a simple tunnel add, followed by a tunnel show:
> 

Ok, but keeping a private copy is not a good idea, since tunnel
can be renamed.
  ip li set dev tun0 name tunnel-of-love

