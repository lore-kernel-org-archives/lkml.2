Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab1FMQDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 12:03:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44601 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab1FMQDH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 12:03:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:x-duff:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=fPv7wMpuI/vdl4hCYcIj3y9VOt3EiJdYGb/ic+ojIsfn6eiu7/PF6F+1m5BKbPWZav
         1AjWw1iGEMDVEZDi1yrLASHwzItjjGOzIEqiZOBRv0Aqn2TR5PrT2N7je78X2jmo93pm
         RRPbotIA2WwjPKHpE5Fl9xNXAYPJeA9cwSFEI=
Subject: Re: [PATCH] unicore32, exec: remove redundant set_fs(USER_DS)
X-Duff: Duff Lite, Duff Dry, Duff Dark, Lady Duff, Raspberry Duff, Duff Zero
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Mathias Krause <minipli@googlemail.com>
In-Reply-To: <1307956780.1878.13.camel@epip-laptop>
Date: Mon, 13 Jun 2011 18:02:59 +0200
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Content-Transfer-Encoding: 8BIT
Message-Id: <62714CC0-0928-49FB-8E64-0A95A53917DF@googlemail.com>
References: <BANLkTinv1teZEHMK0qymaVdcxPOErpqSyg@mail.gmail.com> <1307711463-17752-1-git-send-email-minipli@googlemail.com> <1307956780.1878.13.camel@epip-laptop>
To: gxt@mprc.pku.edu.cn
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.06.2011, 11:19 Guan Xuetao wrote:
> On Fri, 2011-06-10 at 15:11 +0200, Mathias Krause wrote:
>> The address limit is already set in flush_old_exec() so this
>> set_fs(USER_DS) is redundant.
>> 
>> Signed-off-by: Mathias Krause <minipli@googlemail.com>
>> ---
>> arch/unicore32/include/asm/processor.h |    1 -
>> 1 files changed, 0 insertions(+), 1 deletions(-)
>> 
>> diff --git a/arch/unicore32/include/asm/processor.h b/arch/unicore32/include/asm/processor.h
>> index e11cb07..f0d780a 100644
>> --- a/arch/unicore32/include/asm/processor.h
>> +++ b/arch/unicore32/include/asm/processor.h
>> @@ -53,7 +53,6 @@ struct thread_struct {
>> #define start_thread(regs, pc, sp)					\
>> ({									\
>> 	unsigned long *stack = (unsigned long *)sp;			\
>> -	set_fs(USER_DS);						\
>> 	memset(regs->uregs, 0, sizeof(regs->uregs));			\
>> 	regs->UCreg_asr = USER_MODE;					\
>> 	regs->UCreg_pc = pc & ~1;	/* pc */                        \
> 
> Hi Mathias,
> I searched for the code in flush_old_exec(), but I can't find the code
> you mentioned. Could you make it more clear?

Sorry, this statement is based on a commit post v3.0-rc2. Before dac853a (exec:
delay address limit change until point of no return) it was done in
search_binary_handler(), now it is done in flush_old_exec(). Either way
set_fs(USER_DS) gets called before start_thread() so the call there is
redundant.

> And, if all fs codes (not only elf and aout) have the similar
> implementations,

I've checked that all binary format handler call flush_old_exec() before
start_thread(). So: yes.

> perhaps all arch-specific codes should be manipulated
> in the meanwhile.

That's what this LKML thread is for: https://lkml.org/lkml/2011/6/10/65

Thanks,
Mathias