Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab2CARSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 12:18:15 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:53672 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab2CARSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 12:18:12 -0500
Message-ID: <1330622294.5373.8.camel@megeve>
Subject: Re: [PATCH 0/10] af_unix: add multicast and filtering features to
 AF_UNIX
From: Rodrigo Moya <rodrigo.moya@collabora.co.uk>
To: Erik Hugne <erik.hugne@ericsson.com>
Cc: "netdev-owner@vger.kernel.org" <netdev-owner@vger.kernel.org>,
        "David.Laight@ACULAB.COM" <David.Laight@ACULAB.COM>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "javier@collabora.co.uk" <javier@collabora.co.uk>,
        "lennart@poettering.net" <lennart@poettering.net>,
        "kay.sievers@vrfy.org" <kay.sievers@vrfy.org>,
        "alban.crequy@collabora.co.uk" <alban.crequy@collabora.co.uk>,
        "bart.cerneels@collabora.co.uk" <bart.cerneels@collabora.co.uk>,
        "sjoerd.simons@collabora.co.uk" <sjoerd.simons@collabora.co.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Date: Thu, 01 Mar 2012 18:18:14 +0100
In-Reply-To: <A1249B08688639468D1CB181445EE79D5A61B30431@ESESSCMS0355.eemea.ericsson.se>
References: <A1249B08688639468D1CB181445EE79D5A61B30431@ESESSCMS0355.eemea.ericsson.se>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Erik

On Thu, 2012-03-01 at 15:25 +0100, Erik Hugne wrote:
> Hi
> Have you considered using TIPC instead?
> It already provides multicast messaging with guaranteed ordering, and reliable delivery  (SOCK _RDM)
> 
I didn't know about TIPC, so have been having a quick look over it, and
have some questions about it:

* since it's for cluster use, I guess it's based on AF_INET sockets? if
so, see the messages from Luis Augusto and Javier about this breaking
current D-Bus apps, that use fd passing, for out-of-band data

* D-Bus works locally, with all processes on the same machine, but there
are 2 buses (daemons), one for system-related interfaces, and one per
user, so how would this work with TIPC. Can you create several
clusters/networks (as in TIPC addressing semantics) on the same machine
on the loopback device?

* I installed tipcutils on my machine, and it asked me if I wanted to
setup the machine as a TIPC node. Does this mean every machine needs to
be setup as a TIPC node before any app makes use of it? That is, can I
just create a AF_TIPC socket on this machine and just make it work
without any further setup?

* I guess it is easy to prevent any TIPC-enabled machine to get into the
local communication channel, right? That is, what's the security
mechanism for allowing local-only communications?

I'll stop asking questions and have a deeper look at it :)

