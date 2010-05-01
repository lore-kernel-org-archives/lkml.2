Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624Ab0EAWpS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 18:45:18 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50752 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134Ab0EAWpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 18:45:13 -0400
Date: Sat, 1 May 2010 23:44:29 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] ARM: PrimeCell DMA Interface v5
Message-ID: <20100501224429.GA17693@n2100.arm.linux.org.uk>
References: <1270681920-4461-1-git-send-email-linus.walleij@stericsson.com> <v2se9c3a7c21004071645u8180f4d7p3b4b1f96de11303e@mail.gmail.com> <CEE6BB42CAD6E947908279175AF8470A03A50F78@EXDCVYMBSTM006.EQ1STM.local> <t2qe9c3a7c21004141815x70ecf123p4364802681417da9@mail.gmail.com> <q2o63386a3d1004162158v296379fat2b376d5c4c087378@mail.gmail.com> <20100422110025.GC20008@n2100.arm.linux.org.uk> <g2qe9c3a7c21005011500l11511d43i12d971775b139c3b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g2qe9c3a7c21005011500l11511d43i12d971775b139c3b@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 01, 2010 at 03:00:09PM -0700, Dan Williams wrote:
> Just to clarify are you nak'ing these patches for upstream inclusion
> until this testing occurs?  Or do we just need a !ARCH_VERSATILE
> somewhere to allow any incompatibilities to be worked out later
> in-tree?

What I don't want to do is to get into the situation where we throw
this patchset into the kernel and then find that we have to invent a
whole new implementation in the various primecell drivers to support
the Versatile hardware.

Versatile has some MUXing on three of the DMA signals, so (eg) we
really don't want UARTs claiming DMAs just because they're in existence
and not in use - that would prevent DMAs from being used for (eg) AACI
or MMC.

The alternative is that we could just take the attitude that Versatile/
Realview will never have DMA support implemented, but that seems rather
silly, as they've tended to be the first platforms I get new CPU
architectures for.  (This is why DMA coherency stuff on new architectures
tends to be left for others to do...)
