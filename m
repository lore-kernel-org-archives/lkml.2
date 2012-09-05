Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240Ab2IEJOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:14:33 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:22376 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564Ab2IEJOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:14:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAAMXR1DCTtAn/2dsb2JhbABFuxyBB4IhAQU6PxALDjgUGDGIJLpCkTNgA5VYAYEUjwaCZQ
Date: Wed, 5 Sep 2012 11:14:26 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Stany MARCEL <stany.marcel@novasys-ingenierie.com>,
        linux-m68k@vger.kernel.org, geert@linux-m68k.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Add support to M54xx DMA FEC Driver
Message-ID: <20120905091426.GA16015@frolo.macqel>
References: <1345551531-15348-1-git-send-email-stany.marcel@novasys-ingenierie.com> <1345551531-15348-3-git-send-email-stany.marcel@novasys-ingenierie.com> <503C5C5C.8000901@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503C5C5C.8000901@snapgear.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stany & Greg

Seeing that I was not the only one wanting to have the m54xx fec dma
driver merged in, and hoping to compare Stany's version to mine,
I have rebased (step by step) my patch from v2.38 to v3.6rc2.
The driver still works and perhaps even better due to some fixes
in other m68k area.

Unfortunately I have not being able to compare it yet fully with Stany's
version because Stany's patch 2/2 did not apply (using `git am') to v3.5
or v3.6rc2.

I have checked my patch using a recent version of checkpatch.pl (not the
v3.5 version, because v3.5 version of checkpatch.pl fails with :
Nested quantifiers in regex; marked by <-- HERE in m/(\((?:[^\(\)]++ <-- HERE |(
?-1))*\))/ at scripts/checkpatch.pl line 340.))

and I am now at :
    464 WARNING: line over 80 characters
     90 WARNING: Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt

Many "volatile" warnings are about such definitions :

#define FEC_FECFRST(x)                 (*(volatile unsigned int *)(x + 0x1C4))
which are afterwards used with

+       FEC_FECFRST(base_addr) |= FEC_SW_RST;
+       FEC_FECFRST(base_addr) &= ~FEC_SW_RST;
+               FEC_FECFRST(base_addr) |= FEC_SW_RST;
+               FEC_FECFRST(base_addr) &= ~FEC_SW_RST;
+       FEC_FECFRST(base_addr) |= FEC_SW_RST | FEC_RST_CTL;
+       FEC_FECFRST(base_addr) &= ~FEC_SW_RST;

Any advice about those ones ?

while many "80 characters" ones are about :
#4014: FILE: arch/m68k/platform/coldfire/MCD_tasks.c:2406:
+       0x6000000b, /* 0098(:1560):      DRD2A: EU0=0 EU1=0 EU2=0 EU3=11 EXT ini
t=0 WS=0 RS=0 */

I would like to keep those lines intact because the comment seems to actually
be the assembler source of the hex value at left, which seems to be a
microcode, and it makes sense to me to keep that on one line.  What do
you think about that ?

I did not include the current status of the patch because of its size
(I did not separate the dma part of the ethernet driver part because
the dma part is useless without the ethernet driver, and linking the
ethernet driver cannot succeed without the dma part), but if you ask,
I'll send it privately.

Best regards

Philippe

-- 
Philippe De Muyter +32 2 6101532 Macq SA rue de l'Aeronef 2 B-1140 Bruxelles
