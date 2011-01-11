Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab1AKWWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 17:22:49 -0500
Received: from www84.your-server.de ([213.133.104.84]:49301 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab1AKWWs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 17:22:48 -0500
Subject: Re: [PATCH] new UDPCP Communication Protocol
From: Stefani Seibold <stefani@seibold.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        shemminger@vyatta.com, jj@chaosbits.net, daniel.baluta@gmail.com,
        jochen@jochen.org, hagen@jauu.net, torvalds@linux-foundation.org,
        pavel@ucw.cz
In-Reply-To: <1294782386.3447.21.camel@edumazet-laptop>
References: <1294779020.16410.2.camel@wall-e>
	 <20110111.125254.133402589.davem@davemloft.net>
	 <1294780480.17388.2.camel@wall-e>
	 <20110111.131953.180400101.davem@davemloft.net>
	 <1294782117.17531.18.camel@wall-e>
	 <1294782386.3447.21.camel@edumazet-laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 11 Jan 2011 23:23:29 +0100
Message-ID: <1294784609.18562.4.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 11.01.2011, 22:46 +0100 schrieb Eric Dumazet:
> Le mardi 11 janvier 2011 à 22:41 +0100, Stefani Seibold a écrit :
> 
> > Second, the design is may in your opinion poor. I like it. What is
> > really poor is the kernel_...() socket functions, which are only simple
> > wrapper of the system calls without any performance improvement, skb
> > support and memory saving.
> > 
> 
> The only thing you want is to have a callback to your own code to
> deliver an decapsulated skb to your state machine.
> 
> Take a look at other layers on top of UDP
> 
> (L2TP comes to mind)
> 

I have looked on it. And it will not work since UDPCP is UDP. And so
IPPROTO_UDP (17) is still handled by the UDP handler.

Despite this it will also make no sense to rewrite the whole UDP socket
layer.

The only thing i have found with comes near to my requirements is the
rxrpc module, but i see no real different to my solution.


