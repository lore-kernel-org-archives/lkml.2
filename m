Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258Ab1EYBQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 21:16:19 -0400
Received: from c-67-188-111-120.hsd1.ca.comcast.net ([67.188.111.120]:34510
	"EHLO saboo.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752177Ab1EYBQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 21:16:18 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 May 2011 21:16:18 EDT
Message-ID: <4DDC2C91.6060408@goop.org>
Date: Tue, 24 May 2011 15:09:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: NetDev <netdev@vger.kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.39: ipv6 tcp connections hanging on transmit
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I use ssh over ipv6 to connect to my machines, it works fine for
command-line interaction until there's a large output (ps alxw, ps -l,
etc), whereupon the connection hangs.  It appears to be about when it
would send an MTU-sized packet.

Logging in with ssh over ipv4 works fine.

The outputting processes terminate OK, but they leave queued data in the
socket:

# netstat
Proto Recv-Q Send-Q Local Address               Foreign Address             State      
[...]
tcp        0   5776 2001:470:a816:0:230:48f:ssh 2001:470:a816:0:e45e::47865 ESTABLISHED 
tcp        0  26688 2001:470:a816:0:230:48f:ssh 2001:470:a816:0:e45e::55428 ESTABLISHED 
tcp        0      0 2001:470:a816:0:230:48f:ssh 2001:470:a816:0:e45e::55426 ESTABLISHED 
tcp        0   5856 2001:470:a816:0:230:48f:ssh 2001:470:a816:0:e45e::55434 ESTABLISHED 

and the corresponding ssh sessions are hung forever.

The path to the host is over openvpn bridged to the host's lan.  The
path MTU is 1500, verified with "traceroute6 --mtu" and "ping -s 1500"
works.

The network device is a bridge containing a single ethernet device: an
Intel 82574L using the e1000e driver.

I think this regression appeared in .38/.39, but unfortunately I haven't
had a chance to go back and systematically test older kernels yet.

Any clues, suggestions, further information I can provide, etc?

Thanks,
    J
