Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab2FKDFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 23:05:53 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:50298
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752109Ab2FKDFv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 23:05:51 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: -7
X-BigFish: VPS-7(zz9371I542M1432Izz1202hzz8275dhz2dh2a8h668h839h944hd25hf0ah)
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Paul Bolle <pebolle@tiscali.nl>, Mike Frysinger <vapier@gentoo.org>
CC: "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "philippe.gerum@xenomai.org" <philippe.gerum@xenomai.org>
Date: Sun, 10 Jun 2012 23:05:42 -0400
Subject: RE: [uclinux-dist-devel] blackfin: how is the I-pipe code supposed
 to	be built?
Thread-Topic: [uclinux-dist-devel] blackfin: how is the I-pipe code supposed
 to	be built?
Thread-Index: Ac1HU1ilauscPz1PToeugLO5cszKMAAKyCpQ
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D170235830B4@NWD2CMBX1.ad.analog.com>
References: <1339365045.30984.78.camel@x61.thuisdomein>
In-Reply-To: <1339365045.30984.78.camel@x61.thuisdomein>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

The IPIPE patch is part of the ADEOS real time kernel patch. The common part of this patch hasn't been merged into mainline by the maintainer Philippe Gerum, although the Blackfin architecture part was. The relative Kbuild support and Kconfig symbols are defined in the ADOES common patch.

Regards,

Sonic

>-----Original Message-----
>From: uclinux-dist-devel-bounces@blackfin.uclinux.org [mailto:uclinux-dist-devel-
>bounces@blackfin.uclinux.org] On Behalf Of Paul Bolle
>Sent: Monday, June 11, 2012 5:51 AM
>To: Mike Frysinger
>Cc: uclinux-dist-devel@blackfin.uclinux.org; linux-kernel@vger.kernel.org
>Subject: [uclinux-dist-devel] blackfin: how is the I-pipe code supposed to be built?
>
>0) While working my way through the stack of apparently unused headers I
>also looked at arch/blackfin/include/asm/ipipe_base.h, as nothing seems
>to include that header. The last include of that file got removed in
>commit 1353d050facf5efd8dc05ba6c4d7852fcb423b15 ("Blackfin/ipipe:
>restore pipeline bits in irqflags"). So that header is unused since
>v2.6.39.
>
>1) Before submitting the (possibly trivial) patch to remove that header
>I did some further research, because I wanted to be sure that removing
>this header was a reasonable thing to do.
>
>2) I learned that arch/blackfin/include/asm/ipipe_base.h got added to
>the tree in commit 6a01f230339321292cf065551f8cf55361052461 ("Blackfin
>arch: merge adeos blackfin part to arch/blackfin/"). That commit also
>introduced the macro CONFIG_IPIPE. But it did not introduce the Kconfig
>symbol IPIPE. (Neither did it add code that defines a macro
>CONFIG_IPIPE.) So to me it looks like the I-pipe code got added to
>v2.6.29 without proper Kbuild support.
>
>3) And this is currently still the case. There seem to be no Kconfig
>symbols IPIPE, IPIPE_DEBUG, IPIPE_DEBUG_CONTEXT, or
>IPIPE_TRACE_IRQSOFF.
>(Neither seems there to be code that defines the macros CONFIG_IPIPE,
>CONFIG_IPIPE_DEBUG, CONFIG_IPIPE_DEBUG_CONTEXT, or
>CONFIG_IPIPE_TRACE_IRQSOFF.)
>
>4) Whether or not arch/blackfin/include/asm/ipipe_base.h should be
>removed isn't very interesting. What is more interesting is how the
>blackfin I-pipe code is supposed to be built. How can this code be built
>from what currently is in mainline?
>
>
>Paul Bolle
>
>_______________________________________________
>Uclinux-dist-devel mailing list
>Uclinux-dist-devel@blackfin.uclinux.org
>https://blackfin.uclinux.org/mailman/listinfo/uclinux-dist-devel


