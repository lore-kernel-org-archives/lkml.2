Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab1G0Dwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 23:52:39 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52350 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab1G0Dwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 23:52:37 -0400
Message-ID: <4E2F8B7B.80906@signal11.us>
Date: Tue, 26 Jul 2011 23:52:27 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: IP over 802.2 with LLC/SNAP
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

What I have is a fairly straight-forward question, but takes a little 
background to get there.

I have an ancient computer (Gould 3267) that I'm trying to interface 
with both a Windows computer and an embedded Linux computer over 
UDP/Ethernet. Since the Gould doesn't have any IP support, I have to 
make the IP packet myself. Also, because of the way the Gould's Ethernet 
driver works, sent packets all use the type/length field in the Ethernet 
header to represent the length and therefore are unable to specify that 
the packet contains IP data in the Ethernet header. To get around this, 
I added an 802.2 LLC/SNAP header to my packet[1]. My packet looks good 
in Wireshark, and I have it working well communicating with the Windows 
PC. However, I can't seem to get Linux to recognize the packet as IP, 
and thus I am unable to receive it using the normal socket interface on 
the Linux system.

So the question is, does Linux support IP over 802.2 with LLC/SNAP? Is 
there a sysfs/proc entry that I have to turn on to make this work (I 
didn't find one)? I have the LLC2 module loaded, and I believe my packet 
to be correct, since Windows recognizes it and since Wireshark doesn't 
give any red flags on it. I've been unable to find anything about this 
kind of thing in my searching.

I put a sample capture file of the packets I'm sending at [2] for those 
interested.

Alan.

[1] So the packet looks like this:
  Ethernet Header
  LLC/SNAP header
  IP Header
  UDP Header
  data

[2] www.signal11.us/~alan/testraw.pcap
