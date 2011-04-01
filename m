Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab1DAUW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 16:22:28 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:38058 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755168Ab1DAUW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 16:22:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Q4Z3O5iQ8Gcnr4gZOyhl1jYNNMN+sMmt6r+TDAKXxVFhy6opywdwRClaFx9DZklnff9x3IaQ+Dh7+7sUKS2YFXZuTwp/BTPd/SOA0RJCaXZDTADErRCXqfW8g8DZS7GR;
Date: Fri, 1 Apr 2011 13:22:25 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: haael <haael@wp.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bug: Apparent memory exhaustion WTF?
Message-Id: <20110401132225.a9291e25.rdunlap@xenotime.net>
In-Reply-To: <4D9632BD.1050504@wp.pl>
References: <4D9632BD.1050504@wp.pl>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Apr 2011 22:17:01 +0200 haael wrote:

> 
> Hello, guys. My server keeps hanging up with the error output as seen on the 
> bottom of this message. I run non-patched vanilla kernel. Full system upgrade 
> didn't help. Kernel upgrade from 2.6.28.7 to 2.6.35.10 didn't help. I tried 
> also turning swap on/off, upgrading memory and adding new CPU. After the CPU 
> upgrade things actually went worse, now my system blows up every few hours.
> 
> Here you see the squid process running out of memory, but nothing changed when 
> I killed squid; some other process would always cause this error. Just before a 
> hangup, all processes are being killed, as if OOM killer went wild. But the OOM 
> killer shouldn't disable the network stack, right?
> 
> After a hangup, the system becomes completely unresponsive, doesn't answer on 
> ping and even on ARP requests. The only thing that still works is the serial 
> console from which I get the following error. This message is being printed 
> continuously, one per second, for infinity. The only thing I can do with my 
> server is to turn off the power.
> 
> Tell me, guys, what to do? The server is 2x Intel dual core, 16GB RAM, HP 
> Proliant. It has RAID-1 disk and a Broadcom network adapter, which is the most 
> suspicious for me. Attached: lspci, /proc/meminfo, /proc/cpuinfo, kernel config 
> and the actual error message from the serial console.

It would really help if you would build with KALLSYMS enabled (=y)
so that the stack trace below was meaningful/useful.

# CONFIG_KALLSYMS is not set


> [83155.708165] squid: page allocation failure. order:0, mode:0x4020
> [83155.718040] Pid: 19999, comm: squid Not tainted 2.6.35.10-server #1
> [83155.718040] Call Trace:
> [83155.718040]  [<c0175d67>] ? 0xc0175d67
> [83155.718040]  [<c019acdf>] ? 0xc019acdf
> [83155.718040]  [<c019b275>] ? 0xc019b275
> [83155.718040]  [<c030fe0b>] ? 0xc030fe0b
> [83155.718040]  [<c030fe0b>] ? 0xc030fe0b
> [83155.718040]  [<c030f838>] ? 0xc030f838
> [83155.718040]  [<c030fe0b>] ? 0xc030fe0b
> [83155.718040]  [<f81444f5>] ? 0xf81444f5
> [83155.718040]  [<f8142858>] ? 0xf8142858
> [83155.718040]  [<c0317a6a>] ? 0xc0317a6a
> [83155.718040]  [<c0137e77>] ? 0xc0137e77
> [83155.718040]  [<c0137df0>] ? 0xc0137df0
> [83155.718040]  <IRQ>  [<c0137c75>] ? 0xc0137c75
> [83155.718040]  [<c0119ec3>] ? 0xc0119ec3
> [83155.718040]  [<c0296760>] ? 0xc0296760
> [83155.718040]  [<c039480a>] ? 0xc039480a
> [83155.718040]  [<c01336e5>] ? 0xc01336e5
> [83155.718040]  [<c01030a9>] ? 0xc01030a9
> [83155.718040]  [<c0392135>] ? 0xc0392135
> [83155.718040]  [<c024495a>] ? 0xc024495a
> [83155.718040]  [<c0172e93>] ? 0xc0172e93
> [83155.718040]  [<c0243eea>] ? 0xc0243eea
> [83155.718040]  [<c0172d58>] ? 0xc0172d58
> [83155.718040]  [<c0172ff3>] ? 0xc0172ff3
> [83155.718040]  [<c01731b3>] ? 0xc01731b3
> [83155.718040]  [<c0173274>] ? 0xc0173274
> [83155.718040]  [<c0175e99>] ? 0xc0175e99
> [83155.718040]  [<c0175ec4>] ? 0xc0175ec4
> [83155.718040]  [<c01af563>] ? 0xc01af563
> [83155.718040]  [<c0345992>] ? 0xc0345992
> [83155.718040]  [<c030805c>] ? 0xc030805c
> [83155.718040]  [<c01af7d7>] ? 0xc01af7d7
> [83155.718040]  [<c01af4c0>] ? 0xc01af4c0
> [83155.718040]  [<c01af5b0>] ? 0xc01af5b0
> [83155.718040]  [<c01af5b0>] ? 0xc01af5b0
> [83155.718040]  [<c01af5b0>] ? 0xc01af5b0
> [83155.718040]  [<c01af5b0>] ? 0xc01af5b0
> [83155.718040]  [<c01af5b0>] ? 0xc01af5b0
> [83155.718040]  [<c01af5b0>] ? 0xc01af5b0
> [83155.718040]  [<c01af5b0>] ? 0xc01af5b0
> [83155.718040]  [<c01af5b0>] ? 0xc01af5b0
> [83155.718040]  [<c01af5b0>] ? 0xc01af5b0
> [83155.718040]  [<c01af5b0>] ? 0xc01af5b0
> [83155.718040]  [<c01af5b0>] ? 0xc01af5b0
> [83155.718040]  [<c01af5b0>] ? 0xc01af5b0
> [83155.718040]  [<c01af5b0>] ? 0xc01af5b0
> [83155.718040]  [<c01af5b0>] ? 0xc01af5b0
> [83155.718040]  [<c01af5b0>] ? 0xc01af5b0
> [83155.718040]  [<c01af5b0>] ? 0xc01af5b0
> [83155.718040]  [<c01af5b0>] ? 0xc01af5b0
> [83155.718040]  [<c01af5b0>] ? 0xc01af5b0
> [83155.718040]  [<c01aee68>] ? 0xc01aee68
> [83155.718040]  [<c01afbaa>] ? 0xc01afbaa
> [83155.718040]  [<c039441d>] ? 0xc039441d
> [83155.718040]  [<c0390000>] ? 0xc0390000


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
