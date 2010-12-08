Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338Ab0LHFHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 00:07:12 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45599 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab0LHFHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 00:07:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RwKIT+Y+e5GhBTFrNfHzEY+mxLxR903DHEJDO1FQQsNUE2O0C0QOQwFjnAxb62QVsI
         pq+IV46/cWRsFIyhdsaXb0OlaK44nGbYCdFAudKwTO0/gLs6tK2Bi1XvUBHQjctpqKi6
         Mhm7Jbvs2PFrxuLZXlk4FfgJzdMUB6DqhU2D4=
Subject: Re: [06/44] numa: fix slab_node(MPOL_BIND)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <cl@linux.com>
In-Reply-To: <1291782782.5324.54.camel@edumazet-laptop>
References: <20101208000640.115606851@clark.site>
	 <1291777422.26147.70.camel@zaphod>
	 <1291782782.5324.54.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Dec 2010 06:07:05 +0100
Message-ID: <1291784825.5324.59.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 08 décembre 2010 à 05:33 +0100, Eric Dumazet a écrit :

> By the way, anybody knows how I can emulate a memoryless node on a dual
> node x86_64 machine (with memory present on both nodes) ?
> 
> 

this hack works for me :

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index a35cb9d..1087333 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -261,6 +261,7 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 	end = start + ma->length;
 	pxm = ma->proximity_domain;
 	node = setup_node(pxm);
+	node = 0;
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains.\n");
 		bad_srat();

[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x10 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x11 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x12 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x13 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x14 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x15 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x16 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x17 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 0-80000000
[    0.000000] SRAT: Node 0 PXM 1 80000000-e0000000
[    0.000000] SRAT: Node 0 PXM 1 100000000-120000000
[    0.000000] SRAT: Node 0 [0,80000000) + [80000000,e0000000) -> [0,e0000000)
[    0.000000] SRAT: Node 0 [0,e0000000) + [100000000,120000000) -> [0,120000000)
[    0.000000] NUMA: Using 63 for the hash shift.


