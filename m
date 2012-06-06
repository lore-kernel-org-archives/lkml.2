Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab2FFFar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 01:30:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:48309 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144Ab2FFFaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 01:30:46 -0400
Message-ID: <1338960617.7150.163.camel@pasglop>
Subject: RE: [PATCH] powerpc: Fix assmption of end_of_DRAM() returns end
 address
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Bhushan Bharat-R65777 <R65777@freescale.com>
Cc: David Miller <davem@davemloft.net>, Andrea Arcangeli <aarcange@redhat.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Wed, 06 Jun 2012 15:30:17 +1000
In-Reply-To: <6A3DF150A5B70D4F9B66A25E3F7C888D03D68F08@039-SN2MPN1-022.039d.mgd.msft.net>
References: <1338904504-2750-1-git-send-email-bharat.bhushan@freescale.com>
	 <1338934659.7150.113.camel@pasglop>
	 <20120605.152058.828742127223799137.davem@davemloft.net>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D03D68F08@039-SN2MPN1-022.039d.mgd.msft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 00:46 +0000, Bhushan Bharat-R65777 wrote:

> > >> memblock_end_of_DRAM() returns end_address + 1, not end address.
> > >> While some code assumes that it returns end address.
> > >
> > > Shouldn't we instead fix it the other way around ? IE, make
> > > memblock_end_of_DRAM() does what the name implies, which is to
> return
> > > the last byte of DRAM, and fix the -other- callers not to make bad
> > > assumptions ?
> > 
> > That was my impression too when I saw this patch.
> 
> Initially I also intended to do so. I initiated a email on linux-mm@
> subject "memblock_end_of_DRAM()  return end address + 1" and the only
> response I received from Andrea was:
> 
> "
> It's normal that "end" means "first byte offset out of the range". End
> = not ok.
> end = start+size.
> This is true for vm_end too. So it's better to keep it that way.
> My suggestion is to just fix point 1 below and audit the rest :)
> "

Oh well, I don't care enough to fight this battle in my current state so
unless Dave has more stamina than I have today, I'm ok with the patch.

Cheers,
Ben.


