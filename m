Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965117Ab2B1Krj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 05:47:39 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:49873 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964994Ab2B1Kri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 05:47:38 -0500
Message-ID: <1330426059.2139.21.camel@megeve>
Subject: Re: [PATCH 0/10] af_unix: add multicast and filtering features to
 AF_UNIX
From: Rodrigo Moya <rodrigo.moya@collabora.co.uk>
To: David Miller <davem@davemloft.net>
Cc: javier.martinez@collabora.co.uk, javier@collabora.co.uk,
        eric.dumazet@gmail.com, lennart@poettering.net, kay.sievers@vrfy.org,
        alban.crequy@collabora.co.uk, bart.cerneels@collabora.co.uk,
        sjoerd.simons@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 28 Feb 2012 11:47:39 +0100
In-Reply-To: <20120227.140535.1623396420455657443.davem@davemloft.net>
References: <1329753455-1106-1-git-send-email-javier@collabora.co.uk>
	 <20120224.153616.117399887784547022.davem@davemloft.net>
	 <4F4B8C66.5060206@collabora.co.uk>
	 <20120227.140535.1623396420455657443.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David

On Mon, 2012-02-27 at 14:05 -0500, David Miller wrote:
> From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Date: Mon, 27 Feb 2012 15:00:06 +0100
> 
> > Primary for performance reasons. D-bus is an IPC system for processes in
> > the same machine so traversing the whole TCP/IP stack seems a little
> > overkill to me.
> 
> You haven't actually tested what the cost of this actually is, so what
> you're saying is mere speculation.  In many cases TCP/UDP over
> loopback is actually faster than AF_UNIX.
> 
you're right we haven't tested this, but because of the other points in
Javier's mail, which are the special semantics we need for this to fit
the D-Bus usage:

> - total order is guaranteed: If sender A sends a message before B,
then
> receiver C and D should both get message A first and then B.
> 
> - slow readers: dropping packets vs blocking the sender. Although
>   datagrams are not reliable on IP, datagrams on Unix sockets are
never
>   lost. So if one receiver has its buffer full the sender is blocked
> instead of dropping packets. That way we guarantee a reliable
> communication channel.
> 
> - multicast group acess control: controlling who can join the
multicast
> group.
> 
> - multicast on loopback is not supported: which means we have to use a
> NIC (i.e: eth0). 

Because of all of this, UDP/IP multicast wasn't even considered as an
option. We might be wrong in some/all of those, so could you please
comment on them to check if that's so?

thanks

