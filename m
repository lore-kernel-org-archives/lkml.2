Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab2FFQDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:03:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36744 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786Ab2FFQDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:03:09 -0400
Date: Wed, 06 Jun 2012 09:03:08 -0700 (PDT)
Message-Id: <20120606.090308.608629832776499558.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: R65777@freescale.com, aarcange@redhat.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, galak@kernel.crashing.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] powerpc: Fix assmption of end_of_DRAM() returns end
 address
From: David Miller <davem@davemloft.net>
In-Reply-To: <1338960617.7150.163.camel@pasglop>
References: <20120605.152058.828742127223799137.davem@davemloft.net>
	<6A3DF150A5B70D4F9B66A25E3F7C888D03D68F08@039-SN2MPN1-022.039d.mgd.msft.net>
	<1338960617.7150.163.camel@pasglop>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 06 Jun 2012 15:30:17 +1000

> On Wed, 2012-06-06 at 00:46 +0000, Bhushan Bharat-R65777 wrote:
> 
>> > >> memblock_end_of_DRAM() returns end_address + 1, not end address.
>> > >> While some code assumes that it returns end address.
>> > >
>> > > Shouldn't we instead fix it the other way around ? IE, make
>> > > memblock_end_of_DRAM() does what the name implies, which is to
>> return
>> > > the last byte of DRAM, and fix the -other- callers not to make bad
>> > > assumptions ?
>> > 
>> > That was my impression too when I saw this patch.
>> 
>> Initially I also intended to do so. I initiated a email on linux-mm@
>> subject "memblock_end_of_DRAM()  return end address + 1" and the only
>> response I received from Andrea was:
>> 
>> "
>> It's normal that "end" means "first byte offset out of the range". End
>> = not ok.
>> end = start+size.
>> This is true for vm_end too. So it's better to keep it that way.
>> My suggestion is to just fix point 1 below and audit the rest :)
>> "
> 
> Oh well, I don't care enough to fight this battle in my current state so
> unless Dave has more stamina than I have today, I'm ok with the patch.

I'm definitely without the samina to fight something like this right now :)
