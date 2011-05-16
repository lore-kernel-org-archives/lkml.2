Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab1EPPe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 11:34:26 -0400
Received: from smtp.nexicom.net ([216.168.96.13]:45751 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755999Ab1EPPeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 11:34:25 -0400
Message-ID: <4DD14424.8000003@lockie.ca>
Date: Mon, 16 May 2011 11:35:00 -0400
From: James <bjlockie@lockie.ca>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110512 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kernel bug relating to networking
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I originally posted to linux-net@vger.kernel.org but all that list
received in the last day was 3 Russian (spam?) messages.
I'm hoping here will be less spam.

I'm having a wireless problem that I think is kernel issue.
kernel-2.6.36.4 is good but recent kernels are bad.
CompatWireless (recent wireless code) works on kernel-2.6.36.4 so I
don't think it is the wireless subsystem..

I have a Network controller: Atheros Communications Inc. AR5008 Wireless
Network Adapter (rev 01).

"iwlist wlan0 scan | grep SSID" under kernel-2.6.36.4 returns  ~15 APs
and associates to my AP.
Recent kernels are bad and return ~0-3 APs and do not associate to my AP.

I need help to debug this.

I think the scans fail whenever dmesg shows this:
> ath: Failed to stop TX DMA in 100 msec after killing last frame
> ath: Failed to stop TX DMA!
It seems to be 100% if I boot a kernel and that message is there, it'll
be a bad kernel.

I tried:
$ git clone
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.37.y.git
$ cd linux-2.6.37.y
# git tag
What tag is 2.6.36.4?

v2.6.36
v2.6.36-rc1
v2.6.36-rc2
v2.6.36-rc3
v2.6.36-rc4
v2.6.36-rc5
v2.6.36-rc6
v2.6.36-rc7
v2.6.36-rc8
v2.6.37
v2.6.37-rc1
v2.6.37-rc2
v2.6.37-rc3
v2.6.37-rc4
v2.6.37-rc5
v2.6.37-rc6
v2.6.37-rc7
v2.6.37-rc8
v2.6.37.1
v2.6.37.2
v2.6.37.3
v2.6.37.4
v2.6.37.5
v2.6.37.6

Is the next step to do:
$ git bisect start
$ git bisect good v2.6.36.4
$ git bisect bad v2.6.37.6

