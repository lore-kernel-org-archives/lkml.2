Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286Ab0DHUNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:13:00 -0400
Received: from mail.tmr.com ([64.65.253.246]:34774 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755838Ab0DHUM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:12:58 -0400
Message-ID: <4BBE38B9.6020507@tmr.com>
Date: Thu, 08 Apr 2010 16:12:41 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 pango-text SeaMonkey/1.1.16
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Andreas Mohr <andi@lisas.de>
CC: Jens Axboe <axboe@kernel.dk>, Wu Fengguang <fengguang.wu@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 32GB SSD on USB1.1 P3/700 == ___HELL___ (2.6.34-rc3)
References: <20100404221349.GA18036@rhlx01.hs-esslingen.de>
In-Reply-To: <20100404221349.GA18036@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Mohr wrote:
> [CC'd some lucky candidates]
> 
> Hello,
> 
> I was just running
> mkfs.ext4 -b 4096 -E stride=128 -E stripe-width=128 -O ^has_journal
> /dev/sdb2
> on my SSD18M connected via USB1.1, and the result was, well,
> absolutely, positively _DEVASTATING_.
> 
> The entire system became _FULLY_ unresponsive, not even switching back
> down to tty1 via Ctrl-Alt-F1 worked (took 20 seconds for even this key
> to be respected).
> 
> Once back on ttys, invoking any command locked up for minutes
> (note that I'm talking about attempted additional I/O to the _other_,
> _unaffected_ main system HDD - such as loading some shell binaries -,
> NOT the external SSD18M!!).
> 
> Having an attempt at writing a 300M /dev/zero file to the SSD's filesystem
> was even worse (again tons of unresponsiveness), combined with multiple
> OOM conditions flying by (I/O to the main HDD was minimal, its LED was
> almost always _off_, yet everything stuck to an absolute standstill).
> 
> Clearly there's a very, very important limiter somewhere in bio layer
> missing or broken, a 300M dd /dev/zero should never manage to put
> such an onerous penalty on a system, IMHO.
> 
You are using a USB 1.1 connection, about the same speed as a floppy. If you 
have not tuned your system to prevent all of the memory from being used to cache 
writes, it will be used that way. I don't have my notes handy, but I believe you 
need to tune the "dirty" parameters of /proc/sys/vm so that it makes better use 
of memory.

Of course putting a fast device like SSD on a super slow connection makes no 
sense other than as a test of system behavior on misconfigured machines.
> 
> I've got SysRq-W traces of these lockup conditions if wanted.
> 
> 
> Not sure whether this is a 2.6.34-rc3 thing, might be a general issue.
> 
> Likely the lockup behaviour is a symptom of very high memory pressure.
> But this memory pressure shouldn't even be allowed to happen in the first
> place, since the dd submission rate should immediately get limited by the kernel's
> bio layer / elevators.
> 
> Also, I'm wondering whether perhaps additionally there are some cond_resched()
> to be inserted in some places, to try to improve coping with such a
> broken situation at least.
> 
> Thanks,
> 
> Andreas Mohr


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
