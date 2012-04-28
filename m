Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab2D1RiP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 13:38:15 -0400
Received: from plane.gmane.org ([80.91.229.3]:56835 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743Ab2D1RiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 13:38:14 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Mantas M." <grawity@gmail.com>
Subject: "martian source" mixes up source and destination
Date: Sat, 28 Apr 2012 20:37:57 +0300
Message-ID: <jnh9tl$rth$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 78-60-211-195.static.zebra.lt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120426 Thunderbird/12.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After enabling the /proc/sys/net/ipv4/conf/all/log_martians sysctl, I've
been receiving the following messages on dmesg:

> martian source 255.255.255.255 from 192.168.1.115, on dev wlan0
> ll header: ff:ff:ff:ff:ff:ff:f4:6d:04:85:fc:d7:08:00
> martian source 192.168.1.255 from 192.168.1.115, on dev wlan0
> ll header: ff:ff:ff:ff:ff:ff:f4:6d:04:85:fc:d7:08:00
> martian source 192.168.1.255 from 192.168.1.115, on dev wlan0
> ll header: ff:ff:ff:ff:ff:ff:f4:6d:04:85:fc:d7:08:00
> <later>
> martian source 255.255.255.255 from 192.168.1.183, on dev eth0
> ll header: ff:ff:ff:ff:ff:ff:48:5d:60:e8:65:8f:08:00

However, the packets are *not* martians, but legitimate broadcast
UDP/IPv4 packets: they have the *destination* as 255.255.255.255 or
192.168.1.255, with the source being 192.168.1.115 (wlan0 on this
device) for the first three packets, and 192.168.1.183 (eth0) on the
fourth.

Linux 3.3.4-1-ARCH on Arch Linux

-- 
Mantas M. <grawity@gmail.com>

