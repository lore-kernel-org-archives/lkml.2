Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab2KENcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:32:21 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:46516 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab2KENcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:32:17 -0500
Subject: [Q][Process Step Wise]
From: anish kumar <anish198519851985@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Nov 2012 22:32:05 +0900
Message-ID: <1352122325.4968.18.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have below question and I would really appreciate a _CORRECT_ answer.

What are the sequence of steps that happen in CPU, cache, TLB, VM, HDD
leading to execution of “x = 7” which isn’t present in cache or sysmem
nor translation in TLB. Also specify if any interrupts, exceptions or
faults are generated.

I have given a rough idea here. Not very clear about specific interrupts
at each step.I request to please correct me and provide a precise
answer.

1) CPU first fetches the instruction x = 7 from the Instruction cache
(when it reads this address in the PC/IR)
2) After decoding and executing the instruction, it sees that, it needs
to access the memory location of variable x (which will be a virtual
address)
3) Hence it issues a request to the TLB to return the physical
address/tag. 
Assuming the cache is Virtually indexed, it will parallely calculate the
index for this virtual address.
4) Since it's a TLB miss, it accesses the Page table which resides
mostly in Memory.Page table can also reside in Hardware as well in that
case it will page traversal.
//Not sure what the interrupt here is?
5) But since, the translation is not found, meaning the page for this
address is not in RAM, it issues a DMA request to transfer the page from
Secondary storage to the RAM. It knows the address of the page on
Secondary storage through the vm_area struct for this process, which
maintains the location of all the pages. 
// This is done in page fault handler. Page fault is raised when this
even occurs.
6) Once DMA is complete, the processor is interrupted with this event.
It then updates the page table with this entry and also the TLB.
//This would be an I/O interrupt to the processor
7) Once it gets the tag, it checks if that tag matches in the cache. 
8) It won't, since cache does not have this entry. 
9) Hence it fetches this block (cache block) from memory and places into
the cache and restarts the execution. 
10) In the MEM phase of the execution pipeline, it writes the value 7 to
this location in the cache.

As I understand the exact steps which happens in the processor is
specific to the arch but what I want is the standard way in which linux
deals with different archs.

As always thanks to Linux and the community.

