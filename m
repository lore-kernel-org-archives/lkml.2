Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab2JRV5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 17:57:19 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:42865 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753103Ab2JRV5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 17:57:18 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VPS-7(zz98dI9371I146fI103dK1432Izz1202h1d1ah1d2ahzz8275bhz2dh668h839h944hd25hd2bhf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
X-WSS-ID: 0MC3ZN9-01-7IH-02
X-M-MSG: 
Date: Thu, 18 Oct 2012 16:57:07 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 0/7] x86: Use BRK to pre mapping page table to make
 xen happy
Message-ID: <20121018215707.GA29973@jshin-Toonie>
References: <1349827115-16600-1-git-send-email-yinghai@kernel.org>
 <alpine.DEB.2.02.1210101609170.2689@kaball.uk.xensource.com>
 <CAE9FiQW952+jHBHxhKu2PX_fpwb8fXVQp2xX0i=HdzgKWuGFCA@mail.gmail.com>
 <alpine.DEB.2.02.1210181444380.2689@kaball.uk.xensource.com>
 <20121018162611.GA11556@jshin-Toonie>
 <CAE9FiQVA-FF80h1nDqd1_PkxJ2U4oLTeB0-ak5FdniaLM8y4RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAE9FiQVA-FF80h1nDqd1_PkxJ2U4oLTeB0-ak5FdniaLM8y4RQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 01:40:21PM -0700, Yinghai Lu wrote:
> On Thu, Oct 18, 2012 at 9:26 AM, Jacob Shin <jacob.shin@amd.com> wrote:
> 
> i tested dom0 conf on 32 bit  and 64 bit, they are all working.
> 
> and just now I tried with mem=8944m, and they are still working.
> 
> anyway, can you please updated -v5 for-x86-mm branch ?
> I removed mark_page_ro workaround according to stefano

Just tested -v5 with Xen, and Dom0 no longer dies. Also tried it on HVM DomU
and also boots fine.

Also tested on our 1TB machine, and it looks good, only E820_RAM are mapped:

[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x00000000000983ff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000098400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000d2000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000c7ebffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c7ec0000-0x00000000c7ed7fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000c7ed8000-0x00000000c7ed9fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000c7eda000-0x00000000c7ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000e037ffffff] usable
[    0.000000] BIOS-e820: [mem 0x000000e038000000-0x000000ffffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000010000000000-0x0000011ffeffffff] usable

...

[    0.000000] e820: last_pfn = 0xc7ec0 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000092000] 92000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x11ffee00000-0x11ffeffffff]
[    0.000000]  [mem 0x11ffee00000-0x11ffeffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x11ffc000000-0x11ffedfffff]
[    0.000000]  [mem 0x11ffc000000-0x11ffedfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x11f80000000-0x11ffbffffff]
[    0.000000]  [mem 0x11f80000000-0x11fbfffffff] page 1G
[    0.000000]  [mem 0x11fc0000000-0x11ffbffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x11000000000-0x11f7fffffff]
[    0.000000]  [mem 0x11000000000-0x11f7fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0xc7ebffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0xbfffffff] page 1G
[    0.000000]  [mem 0xc0000000-0xc7dfffff] page 2M
[    0.000000]  [mem 0xc7e00000-0xc7ebffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0xe037ffffff]
[    0.000000]  [mem 0x100000000-0xdfffffffff] page 1G
[    0.000000]  [mem 0xe000000000-0xe037ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000000-0x10fffffffff]
[    0.000000]  [mem 0x10000000000-0x10fffffffff] page 1G

Thanks!!

> 
> Thanks
> 
> Yinghai
> 

