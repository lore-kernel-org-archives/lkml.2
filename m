Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab1DBPU7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 11:20:59 -0400
Received: from atl.turmel.org ([74.117.157.138]:44761 "EHLO atl.turmel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778Ab1DBPU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 11:20:58 -0400
X-Greylist: delayed 1139 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Apr 2011 11:20:58 EDT
Message-ID: <4D973A65.3000003@turmel.org>
Date: Sat, 02 Apr 2011 11:01:57 -0400
From: Phil Turmel <philip@turmel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110305 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: haael <haael@wp.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: Bug: Apparent memory exhaustion WTF?
References: <4D9632BD.1050504@wp.pl>
In-Reply-To: <4D9632BD.1050504@wp.pl>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2011 04:17 PM, haael wrote:
> 
> Hello, guys. My server keeps hanging up with the error output as seen on the bottom of this message. I run non-patched vanilla kernel. Full system upgrade didn't help. Kernel upgrade from 2.6.28.7 to 2.6.35.10 didn't help. I tried also turning swap on/off, upgrading memory and adding new CPU. After the CPU upgrade things actually went worse, now my system blows up every few hours.
> 
> Here you see the squid process running out of memory, but nothing changed when I killed squid; some other process would always cause this error. Just before a hangup, all processes are being killed, as if OOM killer went wild. But the OOM killer shouldn't disable the network stack, right?
> 
> After a hangup, the system becomes completely unresponsive, doesn't answer on ping and even on ARP requests. The only thing that still works is the serial console from which I get the following error. This message is being printed continuously, one per second, for infinity. The only thing I can do with my server is to turn off the power.
> 
> Tell me, guys, what to do? The server is 2x Intel dual core, 16GB RAM, HP Proliant. It has RAID-1 disk and a Broadcom network adapter, which is the most suspicious for me. Attached: lspci, /proc/meminfo, /proc/cpuinfo, kernel config and the actual error message from the serial console.

I think this is part of your problem:

> # CONFIG_64BIT is not set
> CONFIG_X86_32=y
> # CONFIG_X86_64 is not set
> CONFIG_X86=y

Everything I've seen on these lists says 32bit kernels and large amounts of RAM are a bad combination.  As I understand it, the information the kernel needs to track all of the memory above 4G must fit in kernel memory below 4G, which is usually just the 1G under the kernel/user split.

> [83155.718040] Free swap  = 0kB
> [83155.718040] Total swap = 0kB

And no swap to fall back on.  Which might be OK on a 64bit kernel.

Just my $0.02.

Phil
