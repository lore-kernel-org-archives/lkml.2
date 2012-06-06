Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab2FFAqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 20:46:51 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:20573
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754187Ab2FFAqX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 20:46:23 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -15
X-BigFish: VS-15(zz9371I936eI542M1432N98dKzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ahbe9i)
From: Bhushan Bharat-R65777 <R65777@freescale.com>
To: David Miller <davem@davemloft.net>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        Andrea Arcangeli <aarcange@redhat.com>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH] powerpc: Fix assmption of end_of_DRAM() returns end
 address
Thread-Topic: [PATCH] powerpc: Fix assmption of end_of_DRAM() returns end
 address
Thread-Index: AQHNQyHQxqfK7c+rIkeAALFeKlrMkJbsn5eAgAAA7QD//9KCoA==
Date: Wed, 6 Jun 2012 00:46:17 +0000
Message-ID: <6A3DF150A5B70D4F9B66A25E3F7C888D03D68F08@039-SN2MPN1-022.039d.mgd.msft.net>
References: <1338904504-2750-1-git-send-email-bharat.bhushan@freescale.com>
	<1338934659.7150.113.camel@pasglop>
 <20120605.152058.828742127223799137.davem@davemloft.net>
In-Reply-To: <20120605.152058.828742127223799137.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [122.176.148.233]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Wednesday, June 06, 2012 3:51 AM
> To: benh@kernel.crashing.org
> Cc: Bhushan Bharat-R65777; linuxppc-dev@lists.ozlabs.org; linux-
> kernel@vger.kernel.org; galak@kernel.crashing.org; Bhushan Bharat-R65777
> Subject: Re: [PATCH] powerpc: Fix assmption of end_of_DRAM() returns end address
> 
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date: Wed, 06 Jun 2012 08:17:39 +1000
> 
> > On Tue, 2012-06-05 at 19:25 +0530, Bharat Bhushan wrote:
> >> memblock_end_of_DRAM() returns end_address + 1, not end address.
> >> While some code assumes that it returns end address.
> >
> > Shouldn't we instead fix it the other way around ? IE, make
> > memblock_end_of_DRAM() does what the name implies, which is to return
> > the last byte of DRAM, and fix the -other- callers not to make bad
> > assumptions ?
> 
> That was my impression too when I saw this patch.

Initially I also intended to do so. I initiated a email on linux-mm@  subject "memblock_end_of_DRAM()  return end address + 1" and the only response I received from Andrea was:

"
It's normal that "end" means "first byte offset out of the range". End = not ok.
end = start+size.
This is true for vm_end too. So it's better to keep it that way.
My suggestion is to just fix point 1 below and audit the rest :)
"

Thanks
-Bharat

