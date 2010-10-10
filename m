Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab0JJPXt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 11:23:49 -0400
Received: from japan.chezphil.org ([77.240.5.4]:5932 "EHLO japan.chezphil.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707Ab0JJPXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 11:23:47 -0400
X-Greylist: delayed 2127 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Oct 2010 11:23:47 EDT
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Cc: "Linux NFS Mailing List" <linux-nfs@vger.kernel.org>
Date: Sun, 10 Oct 2010 15:48:17 +0100
Subject: NFS & atl1c : "RPC: multiple fragments per record not supported"
Message-ID: <1286722097803@dmwebmail.dmwebmail.chezphil.org>
X-Mailer: Decimail Webmail 3alpha16
MIME-Version: 1.0
Content-Type: text/plain; format="flowed"
From: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Experts,

I am seeing the error "RPC: multiple fragments per record not 
supported" on my NFS server when an NFS client with an atl1c network 
driver talks to it.

The server is a QNAP TS119 ARM box running Debian's 2.6.33.2 kernel.  
It works reliably with other clients.

The client is a new x86 system with an "Atheros Communications AR8131 
Gigabit Ethernet (rev c0)" (1969:1063).  The kernel is Debian's 
2.6.32-5-686 and the driver seems to be atl1c.

Typically NFS works for a few seconds and then stops, with that message 
repeated on the server.  Other network activity seems reliable (e.g. 
HTTP, ssh, etc.)

If I use a USB-ethernet adaptor instead of the built-in gigabit it 
works reliably.  (The USB device is not gigabit, but I do still see the 
problems if I limit the port to 100 Mbit on the switch.)

I see the problem with NFS v3 and v4.  However, I only see it with 
proto=tcp.  By changing the NFS protocol to UDP, the problem seems to 
go away [well, it has been working for about 20 minutes now without any issues].

Google finds a previous report here:  
http://lkml.org/lkml/2010/1/20/198 ; the suggestion is to turn off tcp 
segmentation offload, but it seems that this is not possible with my system:

# ethtool -K eth0 tso off
Cannot set device tcp segmentation offload settings: Operation not supported

I have looked at the changes to atl1c since 2.6.32 
(http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=history;f=drivers/net/atl1c;h=53cd10d07d040b7bec957acb1c69bc7b44897e69;hb=HEAD) 
and they seem harmless.

I wiresharked the network activity while this error was being shown, 
and it did include some packets with the high-contrast colour schemes 
that wireshark uses for "bad" packets.  Unfortunately my laptop ran out 
of battery before I could decipher these packets further.

So, is this a known issue?  Do people agree that the atl1c driver is 
most likely the culprit?  Can I offer any further debugging?


Regards,  Phil.

(Please CC me in any replies, as I'll see them sooner.)



