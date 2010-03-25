Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab0CYCU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 22:20:29 -0400
Received: from mail-px0-f181.google.com ([209.85.216.181]:46191 "EHLO
	mail-px0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab0CYCU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 22:20:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=xWDw/2XWY+12QNXsSOL/2+dM83l9uOqKxqdjRIdbjDMkCrOUb0l4cfMP5vLvBwWVc7
         xceHH9aqEh/xiydj2b6jT3BJx4FkhwFTAUOGwHh8LypReGne3tekBaWL4JOQEcVGgrmD
         PGMKOjC1vcpZhPFZw1jFH5CQeBc4wpWW8hAuU=
MIME-Version: 1.0
Date: Thu, 25 Mar 2010 10:20:27 +0800
X-Google-Sender-Auth: c6c97f3f44a1bf34
Message-ID: <5f6c52c61003241920i6b3eaaf7k946f67d1a6f9e384@mail.gmail.com>
Subject: x86_64 virtual memory map
From: hayfeng Lee <omycle@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: ak@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,folks.
Recently I'm studying some things of x86_64 on Linux. And the virsion
is 2.6.18.8. From the document of Documentation/x86_64/mm.txt,I found
the mapping method for x86_64 virtual memory map. I want to know ,why
use this method for virtual memory mapping?

-----------------------------------------------------------------------------------------------
  1
  2 <previous description obsolete, deleted>
  3
  4 Virtual memory map with 4 level page tables:
  5
  6 0000000000000000 - 00007fffffffffff (=47bits) user space, different per mm
  7 hole caused by [48:63] sign extension
  8 ffff800000000000 - ffff80ffffffffff (=40bits) guard hole
  9 ffff810000000000 - ffffc0ffffffffff (=46bits) direct mapping of
all phys. memory
 10 ffffc10000000000 - ffffc1ffffffffff (=40bits) hole
 11 ffffc20000000000 - ffffe1ffffffffff (=45bits) vmalloc/ioremap space
 12 ... unused hole ...
 13 ffffffff80000000 - ffffffff82800000 (=40MB)   kernel text mapping,
from phys 0
 14 ... unused hole ...
 15 ffffffff88000000 - fffffffffff00000 (=1919MB) module mapping space
 16
 17 The direct mapping covers all memory in the system upto the highest
 18 memory address (this means in some cases it can also include PCI memory
 19 holes)
 20
 21 vmalloc space is lazily synchronized into the different PML4 pages of
 22 the processes using the page fault handler, with init_level4_pgt as
 23 reference.
 24
 25 Current X86-64 implementations only support 40 bit of address space,
 26 but we support upto 46bits. This expands into MBZ space in the page tables.
 27
 28 -Andi Kleen, Jul 2004

I urgently want to know the answer.
