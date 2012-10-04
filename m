Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab2JDGcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 02:32:12 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:37455 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab2JDGcK convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:2>);
	Thu, 4 Oct 2012 02:32:10 -0400
Message-Id: <506D4988020000780009F86E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 04 Oct 2012 07:32:08 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Matt Fleming" <matt.fleming@intel.com>
Cc: <mingo@kernel.org>, <x86@kernel.org>, <mjg@redhat.com>,
        <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86, mm: Include the entire kernel memory map
 in trampoline_pgd
References: <1349269157-25956-1-git-send-email-matt@console-pimps.org>
 <1349269157-25956-2-git-send-email-matt@console-pimps.org>
 <506C4C3A020000780008D041@nat28.tlf.novell.com>
 <1349273028.7223.35.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1349273028.7223.35.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 03.10.12 at 16:03, Matt Fleming <matt.fleming@intel.com> wrote:
> On Wed, 2012-10-03 at 14:31 +0100, Jan Beulich wrote:
>> >>> Matt Fleming <matt@console-pimps.org> 10/03/12 2:59 PM >>>
>> >@@ -163,6 +258,10 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
>> >    ret_addr = (void __iomem *) (vaddr + offset);
>> >    mmiotrace_ioremap(unaligned_phys_addr, unaligned_size, ret_addr);
>>  >
>> >+    if (insert_identity_mapping(phys_addr, vaddr, size))
>> >+        printk(KERN_WARNING "ioremap: unable to map 0x%llx in identity pagetable\n",
>> >+                    (unsigned long long)phys_addr);
>> 
>> Isn't that going to trigger quite frequently on 32-bit kernels?
> 
> Hmmm... yeah, probably, though it didn't during my testing. If it is

That's suspicious, isn't it? In general, on any machine with more
than 3Gb of memory below the 4Gb boundary this ought to
trigger for _all_ mappings of MMIO space, and that's already only
considering the default of VMSPLIT_3G.

> likely to trigger a lot then we might be best only inserting the
> identity mmio mapping for 64-bit, and addressing the 32-bit case if we
> ever actually need the identity pagetable.

I think that would be the best choice for the moment.

Btw., once this set of yours is in - will I need to resubmit the
time handling patch that actually triggered this work, or will
you just reinstate it without further action on my part?

Jan

