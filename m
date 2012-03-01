Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273Ab2CAM7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:59:46 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49117 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759108Ab2CAM7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:59:44 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eric.dumazet@gmail.com designates 10.180.92.34 as permitted sender) smtp.mail=eric.dumazet@gmail.com; dkim=pass header.i=eric.dumazet@gmail.com
Message-ID: <1330606775.2465.56.camel@edumazet-laptop>
Subject: RE: [PATCH 0/10] af_unix: add multicast and filtering features to
 AF_UNIX
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Rodrigo Moya <rodrigo.moya@collabora.co.uk>
Cc: David Laight <David.Laight@ACULAB.COM>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        David Miller <davem@davemloft.net>, javier@collabora.co.uk,
        lennart@poettering.net, kay.sievers@vrfy.org,
        alban.crequy@collabora.co.uk, bart.cerneels@collabora.co.uk,
        sjoerd.simons@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 01 Mar 2012 04:59:35 -0800
In-Reply-To: <1330606237.27405.5.camel@megeve>
References: <AE90C24D6B3A694183C094C60CF0A2F6026B6E86@saturn3.aculab.com>
	 <1330606237.27405.5.camel@megeve>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 01 mars 2012 à 13:50 +0100, Rodrigo Moya a écrit :
> the main problem in D-Bus we are trying to solve is the context
> switches, since right now, there is a daemon, which listens on a UNIX
> socket, and all traffic in the bus goes through it, and then the daemon
> has to route the messages it gets on that socket to the corresponding
> place(s). So, every time someone sends a message to D-Bus, since all
> traffic goes through the daemon, dbus-daemon gets waked-up, which is one
> of the biggest bottlenecks we are trying to fix.
> 
> That's why we are thinking about using multicast with socket filters, so
> that the daemon only gets traffic it cares about and thus is not waked
> up and context switches don't happen when not needed.
> 
> Using message queues, AFAICS, we would have the same problem, as the
> daemon would create the message queue and would get all traffic, right?
> 

This is why I mentioned extensions.

Anyway, if you think multicast sockets is the way to go, then you could
setup a virtual network just to be able to use AF_INET multicast.

Thats probably doable without kernel patching.



