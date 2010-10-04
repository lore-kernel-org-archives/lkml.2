Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab0JDRnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 13:43:09 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:16867 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab0JDRnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 13:43:07 -0400
Message-ID: <4CAA122B.40502@caviumnetworks.com>
Date: Mon, 04 Oct 2010 10:43:07 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Rabin Vincent <rabin@rab.in>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, jbaron@redhat.com,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] jump label: Add MIPS support.
References: <1285697432-29244-1-git-send-email-ddaney@caviumnetworks.com> <AANLkTimEJQE3i9Wa1X=Rkw1goJA9c5Sso-iWV=hLG6KF@mail.gmail.com>
In-Reply-To: <AANLkTimEJQE3i9Wa1X=Rkw1goJA9c5Sso-iWV=hLG6KF@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Oct 2010 17:43:12.0896 (UTC) FILETIME=[9DF87000:01CB63EB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2010 11:15 AM, Rabin Vincent wrote:
> On Tue, Sep 28, 2010 at 11:40 PM, David Daney<ddaney@caviumnetworks.com>  wrote:
>> +void arch_jump_label_text_poke_early(jump_label_t addr)
>> +{
>> +       union mips_instruction *insn_p =
>> +               (union mips_instruction *)(unsigned long)addr;
>> +
>> +       insn_p->word = 0; /* nop */
>> +       flush_icache_range((unsigned long)insn_p,
>> +                          (unsigned long)insn_p + sizeof(*insn_p));
>> +}
>
> Can't this function be a no-op on MIPS?  This seems to be
> used on x86 to patch in the optimal nop instruction, but
> on MIPS the optimal/only nop instruction should already
> be in place at build time.  Same thing for the SPARC
> implementation.
>

Yes, I think you are correct.

On MIPS the NOP is already optimal.  I will respin the MIPS patch to 
make arch_jump_label_text_poke_early() be empty.

davem wasn't CCed on the original message, so I added him.  I would 
defer to him on the SPARC version.


Thanks,
David Daney
