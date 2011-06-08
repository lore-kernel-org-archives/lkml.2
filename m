Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab1FHIZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 04:25:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51821 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab1FHIZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 04:25:11 -0400
Date: Wed, 8 Jun 2011 10:25:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Fix sys_call_table type in asm/syscall.h
Message-ID: <20110608082500.GA20162@elte.hu>
References: <1307490307-27443-1-git-send-email-andi@firstfloor.org>
 <20110608080346.GA11110@elte.hu>
 <20110608081711.GG27166@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110608081711.GG27166@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > There's an obvious problem with this patch, please fix it and resend.
> 
> Nothing obvious to me. Can you be more specific?

Sure, a trivial git grep of the sys_call_ptr_t typedef you added to 
syscall.h shows:

 ~/tip> git grep sys_call_ptr_t
 arch/um/sys-x86_64/syscall_table.c:typedef void (*sys_call_ptr_t)(void);
 arch/x86/include/asm/syscall.h:typedef void (*sys_call_ptr_t)(void);
 arch/x86/kernel/syscall_64.c:typedef void (*sys_call_ptr_t)(void);

So you've now added a third typedef in addition to the two existing 
ones. We obivously only want one in the kernel - the one you added to 
the header file.

Thanks,

	Ingo
