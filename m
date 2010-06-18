Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933705Ab0FRUZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 16:25:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46876 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898Ab0FRUZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 16:25:45 -0400
Message-ID: <4C1BD607.5000803@zytor.com>
Date: Fri, 18 Jun 2010 13:24:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
       Mitch Bradley <wmb@laptop.org>
Subject: Re: [PATCH] x86: OLPC: add support for calling into OpenFirmware
 (v5)
References: <20100618154245.2e00af2a@dev.queued.net>	<4C1BCDD5.5040805@zytor.com> <20100618161953.4a72a126@dev.queued.net>
In-Reply-To: <20100618161953.4a72a126@dev.queued.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2010 01:19 PM, Andres Salomon wrote:
> On Fri, 18 Jun 2010 12:49:41 -0700
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
>> On 06/18/2010 12:42 PM, Andres Salomon wrote:
>>> +
>>> +	/* install OFW's PDE permanently into the kernel's pgtable
>>> */
>>> +	set_pgd(&swapper_pg_dir[OLPC_OFW_PDE_NR], *ofw_pde);
>>> +	flush_tlb();
>>> +	early_iounmap(base, sizeof(olpc_ofw_pgd) * PTRS_PER_PGD);
>>
>> I just realized... this flush_tlb() is actually not necessary since on
>> x86 it is always legal to go from a less permissive configuration to a
>> more permissive, and the initial configuration is "not present" which
>> is maximally nonpermissive.
>>
>> Could you take it out and make sure it still works?
>>
>> 	-hpa
> 
> Yep, seems to work fine w/out it.  Anything else before I send off v6
> of the patch?

Not that I can see.

	-hpa

