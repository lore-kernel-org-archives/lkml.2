Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab2BXGIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 01:08:13 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:51374 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753671Ab2BXGIM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 01:08:12 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of glikely@secretlab.ca designates 10.60.28.168 as permitted sender) smtp.mail=glikely@secretlab.ca
MIME-Version: 1.0
In-Reply-To: <20120224163042.4cc2633945c9799b997ff4e7@canb.auug.org.au>
References: <20120224162504.49480de981431c3fd95601a2@canb.auug.org.au> <20120224163042.4cc2633945c9799b997ff4e7@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 23 Feb 2012 23:07:51 -0700
X-Google-Sender-Auth: Az4nL1pAZT1GVvdrNyEObGU01-s
Message-ID: <CACxGe6tgrAj+sHJ211=pRcqYBSM0xq2f1ycctK4RXLT7rSNhww@mail.gmail.com>
Subject: Re: linux-next: manual merge of the irqdomain tree with the powerpc tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 10:30 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> [Just adding the PPC guys]
>
> On Fri, 24 Feb 2012 16:25:04 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> Hi Grant,
>>
>> Today's linux-next merge of the irqdomain tree got a conflict in
>> arch/powerpc/sysdev/mpic.c between commits 3a7a7176e840 ("powerpc/mpic:
>> Fix use of "flags" variable in mpic_alloc()") and c1b8d45db4db
>> ("powerpc/mpic: Add "last-interrupt-source" property to override
>> hardware") from the powerpc tree and commit a8db8cf0d894 ("irq_domain:
>> Replace irq_alloc_host() with revmap-specific initializers") from the
>> irqdomain tree.
>>
>> I fixed it up (see below) and can carry the fix as necessary.

Thanks Stephen.

g.

>> --
>> Cheers,
>> Stephen Rothwell                    sfr@canb.auug.org.au
>>
>> diff --cc arch/powerpc/sysdev/mpic.c
>> index b9b989d,c83a512..0000000
>> --- a/arch/powerpc/sysdev/mpic.c
>> +++ b/arch/powerpc/sysdev/mpic.c
>> @@@ -1351,9 -1345,9 +1351,8 @@@ struct mpic * __init mpic_alloc(struct
>>       mpic->isu_shift = 1 + __ilog2(mpic->isu_size - 1);
>>       mpic->isu_mask = (1 << mpic->isu_shift) - 1;
>>
>> -     mpic->irqhost = irq_alloc_host(mpic->node, IRQ_HOST_MAP_LINEAR,
>> -                                    mpic->isu_size, &mpic_host_ops,
>> -                                    intvec_top + 1);
>> +     mpic->irqhost = irq_domain_add_linear(mpic->node,
>>  -                                   isu_size ? isu_size : mpic->num_sources,
>>  -                                   &mpic_host_ops, mpic);
>> ++                                   mpic->isu_size, &mpic_host_ops, mpic);
>>
>>       /*
>>        * FIXME: The code leaks the MPIC object and mappings here; this



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
