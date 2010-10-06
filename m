Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016Ab0JFWrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 18:47:20 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:44667 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760004Ab0JFWrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 18:47:18 -0400
Message-ID: <4CACFC23.4080504@kernel.org>
Date: Wed, 06 Oct 2010 15:45:55 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 00/47] Sparse irq rework
References: <20100930221351.682772535@linutronix.de> <20101003112312.GB9844@angua.secretlab.ca> <20101003112920.GB32736@n2100.arm.linux.org.uk> <AANLkTingVuhgdaLZ8U3bM+F2vZJ_kScwKqNtHW=g6DcH@mail.gmail.com> <alpine.LFD.2.00.1010031544340.14550@localhost6.localdomain6> <alpine.LFD.2.00.1010051219580.2556@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1010051219580.2556@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2010 03:22 AM, Thomas Gleixner wrote:
> On Sun, 3 Oct 2010, Thomas Gleixner wrote:
>> On Sun, 3 Oct 2010, Grant Likely wrote:
>>> Okay, patch 14 looks good to me too (including Yinghai's comment).
>>> The new allocator seems sane, and I didn't see any obvious errors in
>>> patches 16-47.  I've not tested any of this yet.  Hopefully I'll be
>>> able to carve out some time to do so early this week.
>>
>> Wait until I pushed out a fixed tree. In meantime I found out how I
>> managed to screw up the quilt series :(
>>
>> Will post, once it's ready.
> 
> Pushed out an updated tree to
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-sparse-irq.git master
> 

test it together with tip, it seems all io apic routing is not set rightly. MSI is ok...

[  200.290040] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  200.290991] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  200.310002] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[  200.310455] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[  200.330127] ehci_hcd 0000:00:1d.7: debug port 1
[  200.334395] ehci_hcd 0000:00:1d.7: cache line size of 256 is not supported
[  200.350042] ehci_hcd 0000:00:1d.7: request interrupt 23 failed
[  200.350491] ehci_hcd 0000:00:1d.7: USB bus 1 deregistered
[  200.372257] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[  200.372644] ehci_hcd 0000:00:1d.7: init 0000:00:1d.7 fail, -38
[  200.389916] ehci_hcd: probe of 0000:00:1d.7 failed with error -38
