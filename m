Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab0JDRvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 13:51:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756293Ab0JDRvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 13:51:53 -0400
Date: Mon, 4 Oct 2010 13:50:39 -0400
From: Jason Baron <jbaron@redhat.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Rabin Vincent <rabin@rab.in>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] jump label: Add MIPS support.
Message-ID: <20101004175039.GC2900@redhat.com>
References: <1285697432-29244-1-git-send-email-ddaney@caviumnetworks.com> <AANLkTimEJQE3i9Wa1X=Rkw1goJA9c5Sso-iWV=hLG6KF@mail.gmail.com> <4CAA122B.40502@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CAA122B.40502@caviumnetworks.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 10:43:07AM -0700, David Daney wrote:
> On 10/03/2010 11:15 AM, Rabin Vincent wrote:
>> On Tue, Sep 28, 2010 at 11:40 PM, David Daney<ddaney@caviumnetworks.com>  wrote:
>>> +void arch_jump_label_text_poke_early(jump_label_t addr)
>>> +{
>>> +       union mips_instruction *insn_p =
>>> +               (union mips_instruction *)(unsigned long)addr;
>>> +
>>> +       insn_p->word = 0; /* nop */
>>> +       flush_icache_range((unsigned long)insn_p,
>>> +                          (unsigned long)insn_p + sizeof(*insn_p));
>>> +}
>>
>> Can't this function be a no-op on MIPS?  This seems to be
>> used on x86 to patch in the optimal nop instruction, but
>> on MIPS the optimal/only nop instruction should already
>> be in place at build time.  Same thing for the SPARC
>> implementation.
>>
>
> Yes, I think you are correct.
>
> On MIPS the NOP is already optimal.  I will respin the MIPS patch to  
> make arch_jump_label_text_poke_early() be empty.
>
> davem wasn't CCed on the original message, so I added him.  I would  
> defer to him on the SPARC version.
>
>

that's right, arch_jump_label_text_poke_early() can probably be a no-op
for most arches.

We can also look at adding an empty definition into the generic
header. So that arches don't have to provide an empty definition.

thanks,

-Jason
