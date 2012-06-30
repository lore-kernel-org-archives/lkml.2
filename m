Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab2F3UlW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 16:41:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52101 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab2F3UlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 16:41:21 -0400
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: Vincent Sanders <vincent.sanders@collabora.co.uk>
Subject: Re: AF_BUS socket address family
Date: Sat, 30 Jun 2012 22:41:08 +0200
User-Agent: KMail/1.9.10
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
References: <1340988354-26981-1-git-send-email-vincent.sanders@collabora.co.uk>
In-Reply-To: <1340988354-26981-1-git-send-email-vincent.sanders@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201206302241.08662.hpj@urpla.net>
X-Provags-ID: V02:K0:NXJc6nlsMKwLzbQ/4N7q6KMX+b2+2Cs6LsqBqwoKyg+
 sd7ZYc89IaDteP9uRyLN/TXqnyxPe0D5GviYIAwl4UfBsYYnSv
 JqXWUvI7Qzp51qpfVCfV5knhMDVwaQr3LHaOvpb8/sPxiSuexa
 IGoAsSDFt+ngSYSWYWSwafE1sQo/uysVPPwiQd/foH/3OX8353
 wjmHQQ+Qi45uJstJcAQ5SiRm0WFbMxHZMKm+bsM34+y3SIi70N
 /4XFlxDX3BtUI9o1rLPKmVabOSml+RnhBI7A3/ju/3bXa+liJu
 1ATt4dism37BhFaA+j27xPB+9suqnFYxXuKSmwp+X+D+DKulap
 N3BpuTa9gmHncLUvGz5I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Vincent,

On Friday 29 June 2012, 18:45:39 Vincent Sanders wrote:
> This series adds the bus address family (AF_BUS) it is against
> net-next as of yesterday.
>
> AF_BUS is a message oriented inter process communication system.
>
> The principle features are:
>
>  - Reliable datagram based communication (all sockets are of type
>    SOCK_SEQPACKET)
>
>  - Multicast message delivery (one to many, unicast as a subset)
>
>  - Strict ordering (messages are delivered to every client in the
> same order)
>
>  - Ability to pass file descriptors
>
>  - Ability to pass credentials
>
> The basic concept is to provide a virtual bus on which multiple
> processes can communicate and policy is imposed by a "bus master".
>
> Introduction
> ------------
>
> AF_BUS is based upon AF_UNIX but extended for multicast operation and
> removes stream operation, responding to extensive feedback on
> previous approaches we have made the implementation as isolated as
> possible. There are opportunities in the future to integrate the
> socket garbage collector with that of the unix socket implementation.
>
> The impetus for creating this IPC mechanism is to replace the
> underlying transport for D-Bus. The D-Bus system currently emulates
> this IPC mechanism using AF_UNIX sockets in userspace and has
> numerous undesirable behaviours. D-Bus is now widely deployed in many
> areas and has become a de-facto IPC standard. Using this IPC
> mechanism as a transport gives a significant (100% or more)
> improvement to throughput with comparable improvement to latency.

Your introduction is missing a comprehensive "Discussion" section, where 
you compare the AF_UNIX based implementation with AF_BUS ones. 

You should elaborate on each of the above noted undesirable behaviours, 
why and how AF_BUS is advantageous. Show the workarounds, that are 
needed by AF_UNIX to operate (properly?!?) and how the new 
implementation is going to improve this situation.

This will help to get some progress into the indurated discussion here.

Please also note, that, while your aims are nice and sound, it's even 
more important for IPC mechanisms to operate properly - even during 
persisting error conditions (crashed bus master and clients, 
misbehaving or even abusing members). It would be cool to create a 
D-BUS test rig, that not only measures performance numbers, but also 
checks for dead locks, corner cases and abuse attempts in both IPC 
implementations.

It's a juggling act: while AF_UNIX might suffer from downsides, the code 
is heavily exercised in every aspect. Your implementation will only be 
exercised by a handful of users (basically one lib), but in order to 
rectify its existence in kernel space, such extensions need different 
kinds of users, and the basic concepts need to fit in the whole kernel 
picture as well, or you need to call it AF_DBUS with even less chance 
to get it into mainstream.

Wishing you all the best and good luck,
Pete
