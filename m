Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab1AWRp3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 12:45:29 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36779 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1AWRp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 12:45:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=SEqhVdcCkL98veXYSPJD2pqBzYiKZBpFLLHV6dWxBtPd4/HGlH40cXPTxflfAzQbUb
         ObRkGguRrEQBYqWwvo3ZMO7Qm8KZc/jk4ixUsgRETIJseKmXjez4q+Apj/7Wjn41U/hR
         HT/cUq5hsXtiWEWzJ5msf/cGpCHzRZxq0xfaM=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: 2.6.37 regression: adding main interface to a bridge breaks vlan interface RX
Date: Sun, 23 Jan 2011 18:45:20 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.4.5; i686; ; )
Cc: netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jesse@nicira.com
References: <4D32FC1C.3010905@simon.arlott.org.uk>
In-Reply-To: <4D32FC1C.3010905@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101231845.20505.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=27432
for your bug report, please add your address to the CC list in there, thanks!

On niedziela, 16 stycznia 2011 o 15:09:32 Simon Arlott wrote:
> [    1.666706] forcedeth 0000:00:08.0: ifname eth0, PHY OUI 0x5043 @ 16,
> addr 00:e0:81:4d:2b:ec [    1.666767] forcedeth 0000:00:08.0: highdma csum
> vlan pwrctl mgmt gbit lnktim msi desc-v3
> 
> I have eth0 and eth0.3840 which works until I add eth0 to a bridge.
> While eth0 is in a bridge (the bridge device is up), eth0.3840 is unable
> to receive packets. Using tcpdump on eth0 shows the packets being
> received with a VLAN tag but they don't appear on eth0.3840. They appear
> with the VLAN tag on the bridge interface.
> 
> If I remove eth0 from the bridge, eth0.3840 starts working again. It
> still works if eth0.3840 is part of a bridge but eth0 isn't (the device
> is in promiscuous mode). I've only tested with broadcast traffic.
> 
> This works with 2.6.36.
> 
> git bisect produces 3701e51382a026cba10c60b03efabe534fba4ca4 as the
> first bad commit.
> 
> The behaviour of drivers/net/forcedeth.c nv_rx_process_optimized looks
> ok - vlan_gro_receive and napi_gro_receive are called correctly. (The
> likely(!np->vlangrp) looks odd as it'll always be false if vlans are in
> use).

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
