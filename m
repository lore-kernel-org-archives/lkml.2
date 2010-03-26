Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab0CZEeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 00:34:08 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:35516 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab0CZEeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 00:34:06 -0400
To: hayfeng Lee <omycle@gmail.com>
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com
Subject: Re: x86_64 virtual memory map
References: <5f6c52c61003241920i6b3eaaf7k946f67d1a6f9e384@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 25 Mar 2010 21:34:02 -0700
In-Reply-To: <5f6c52c61003241920i6b3eaaf7k946f67d1a6f9e384@mail.gmail.com> (hayfeng Lee's message of "Thu\, 25 Mar 2010 10\:20\:27 +0800")
Message-ID: <m1r5n7ln0l.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: omycle@gmail.com, ak@linux.intel.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hayfeng Lee <omycle@gmail.com> writes:

> Hi,folks.
> Recently I'm studying some things of x86_64 on Linux. And the virsion
> is 2.6.18.8. From the document of Documentation/x86_64/mm.txt,I found
> the mapping method for x86_64 virtual memory map. I want to know ,why
> use this method for virtual memory mapping?
>
> -----------------------------------------------------------------------------------------------
>   1
>   2 <previous description obsolete, deleted>
>   3
>   4 Virtual memory map with 4 level page tables:
>   5
>   6 0000000000000000 - 00007fffffffffff (=47bits) user space, different per mm
>   7 hole caused by [48:63] sign extension
>   8 ffff800000000000 - ffff80ffffffffff (=40bits) guard hole
>   9 ffff810000000000 - ffffc0ffffffffff (=46bits) direct mapping of
> all phys. memory
>  10 ffffc10000000000 - ffffc1ffffffffff (=40bits) hole
>  11 ffffc20000000000 - ffffe1ffffffffff (=45bits) vmalloc/ioremap space
>  12 ... unused hole ...
>  13 ffffffff80000000 - ffffffff82800000 (=40MB)   kernel text mapping,
> from phys 0
>  14 ... unused hole ...
>  15 ffffffff88000000 - fffffffffff00000 (=1919MB) module mapping space
>  16
>  17 The direct mapping covers all memory in the system upto the highest
>  18 memory address (this means in some cases it can also include PCI memory
>  19 holes)
>  20
>  21 vmalloc space is lazily synchronized into the different PML4 pages of
>  22 the processes using the page fault handler, with init_level4_pgt as
>  23 reference.
>  24
>  25 Current X86-64 implementations only support 40 bit of address space,
>  26 but we support upto 46bits. This expands into MBZ space in the page tables.
>  27
>  28 -Andi Kleen, Jul 2004
>
> I urgently want to know the answer.

We can't give you the answer unless you give us the question, and enough
context that the question makes sense.  I recommend looking up the AMD and
possibly the intel architecture documents on x86_64.  They very completely
cover what the processors can do and are freely available online.

Eric
