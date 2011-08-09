Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab1HIMne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 08:43:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59051 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab1HIMnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 08:43:31 -0400
Subject: Re: RSS mode performance in ixgbe (82599) driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "J.Hwan Kim" <frog1120@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <4E41222B.8060003@gmail.com>
References: <4E41222B.8060003@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 14:43:28 +0200
Message-ID: <1312893808.2371.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 09 août 2011 à 21:03 +0900, J.Hwan Kim a écrit :
> Hi, everyone
> 
> I'm testing the RSS mode throughput of Intel ixgbe 82599 driver.
> My server's specification is Xeon 3GHz (4cores) and PCIe speed is 
> 2.5Gx8lanes,
> and DD2 memory is about 600~700MHz.
> 
> When I enable the RSS(receive side scaling) mode with 4 Rx queues,
> the Rx performance is below than when I use a single queue.
> 
> I don't know how the cores operate, whether the cores run in sequence
> or simultaneously at the same time.
> 
> I want to know the mechanism in general how the multi-cores run
> and the reason why the performance of ixgbe driver in rss mode is below
> non-rss mode.

CC netdev, as these kind of stuff is better hosted on netdev

You should make sure your 4 rx queues are serviced by different cpus, or
else, one cpu could be the bottleneck.

cat /proc/interrupts



