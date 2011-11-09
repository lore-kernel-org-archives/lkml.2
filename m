Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab1KIGYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 01:24:46 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60473 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1KIGYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 01:24:45 -0500
Message-ID: <1320819875.26025.48.camel@edumazet-laptop>
Subject: Re: Large file copy to NFS mounted directory causes delay in other
 application packets
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Manavalan Krishnan <manavalan_k@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Date: Wed, 09 Nov 2011 07:24:35 +0100
In-Reply-To: <1320816503.73813.YahooMailNeo@web160718.mail.bf1.yahoo.com>
References: <1320816503.73813.YahooMailNeo@web160718.mail.bf1.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 08 novembre 2011 à 21:28 -0800, Manavalan Krishnan a écrit :
> Hi All
> 
> I have two systems with two network interfaces each(eth0 and eth1). I
> am running linux-HA (heartbeat deamon) on both the systems and they
> use eth0 for exchanging heartbeats. I have NFS mounted directory in
> one system and the NFS client uses the interface eth1. 
> 
> I try to copy a large file to NFS mounted directory. But the heartbeat
> daemons misses the heartbeat packets from peers while copy is under
> progress. I did tcpdump and found that the heartbeat packets are
> delayed for few seconds before sent out on eth0. When I stop the file
> copy, the heartbeats are delivered properly. It seems linux kernel
> somehow giving priority for NFS packets(generated from the file copy)
> over other application packets.
> 
> Any thoughts on this behavior? Is there any way we can avoid this so
> that application packets get equal chance while large file copy to NFS
> mounted directory under progress?
> 
CC netdev

1) Is your NFS using UDP or TCP ?
2) Is your eth0 dedicated to heartbeats and eth1 to NFS traffic ?
3) How do you know heartbeats are delayed ?
4) Is your server CPU bounded ?

Thanks


