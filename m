Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab1FNHDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 03:03:23 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:55894 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab1FNHDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 03:03:21 -0400
Subject: Re: [PATCH] unicore32, exec: remove redundant set_fs(USER_DS)
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Mathias Krause <minipli@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, arnd@arndb.de
In-Reply-To: <62714CC0-0928-49FB-8E64-0A95A53917DF@googlemail.com>
References: <BANLkTinv1teZEHMK0qymaVdcxPOErpqSyg@mail.gmail.com>
	 <1307711463-17752-1-git-send-email-minipli@googlemail.com>
	 <1307956780.1878.13.camel@epip-laptop>
	 <62714CC0-0928-49FB-8E64-0A95A53917DF@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: MPRC, PKU
Date: Tue, 14 Jun 2011 15:03:07 +0800
Message-ID: <1308034987.4727.1.camel@epip-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 18:02 +0200, Mathias Krause wrote:
> On 13.06.2011, 11:19 Guan Xuetao wrote:
> > On Fri, 2011-06-10 at 15:11 +0200, Mathias Krause wrote:
> >> The address limit is already set in flush_old_exec() so this
> >> set_fs(USER_DS) is redundant.
> >> 
> >> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> >> ---
> >> arch/unicore32/include/asm/processor.h |    1 -
> >> 1 files changed, 0 insertions(+), 1 deletions(-)
> >> 
> >> diff --git a/arch/unicore32/include/asm/processor.h b/arch/unicore32/include/asm/processor.h
> >> index e11cb07..f0d780a 100644
> >> --- a/arch/unicore32/include/asm/processor.h
> >> +++ b/arch/unicore32/include/asm/processor.h
> >> @@ -53,7 +53,6 @@ struct thread_struct {
> >> #define start_thread(regs, pc, sp)					\
> >> ({									\
> >> 	unsigned long *stack = (unsigned long *)sp;			\
> >> -	set_fs(USER_DS);						\
> >> 	memset(regs->uregs, 0, sizeof(regs->uregs));			\
> >> 	regs->UCreg_asr = USER_MODE;					\
> >> 	regs->UCreg_pc = pc & ~1;	/* pc */                        \
> > 
> > Hi Mathias,
> > I searched for the code in flush_old_exec(), but I can't find the code
> > you mentioned. Could you make it more clear?
> 
> Sorry, this statement is based on a commit post v3.0-rc2. Before dac853a (exec:
> delay address limit change until point of no return) it was done in
> search_binary_handler(), now it is done in flush_old_exec(). Either way
> set_fs(USER_DS) gets called before start_thread() so the call there is
> redundant.
> 
> > And, if all fs codes (not only elf and aout) have the similar
> > implementations,
> 
> I've checked that all binary format handler call flush_old_exec() before
> start_thread(). So: yes.
> 
> > perhaps all arch-specific codes should be manipulated
> > in the meanwhile.
> 
> That's what this LKML thread is for: https://lkml.org/lkml/2011/6/10/65
> 
> Thanks,
> Mathias
Thanks for your explanations.
The patch looks good to me.

Guan Xuetao


