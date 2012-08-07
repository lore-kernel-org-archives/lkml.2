Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab2HGPQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 11:16:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab2HGPQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 11:16:01 -0400
Date: Tue, 7 Aug 2012 17:12:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Roland McGrath <roland@hack.frob.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ptrace: fix
	set_task_blockstep()->update_debugctlmsr() logic
Message-ID: <20120807151211.GA13390@redhat.com>
References: <20120803162912.GA19767@redhat.com> <20120803162954.GA19806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120803162954.GA19806@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Today I noticed by accident that starting from Aug 4 (at least)
all my emails went to nowhere. I am resending some of them...


On 08/03, Oleg Nesterov wrote:
>
> 2. It is wrong. The state of DEBUGCTLMSR_BTF bit in CPU register
>    should always match the state of current's TIF_BLOCKSTEP bit.

Yes.

But this means we should set/clear TIF_BLOCKSTEP and update
MSR_IA32_DEBUGCTLMSR "atomically" under preempt_disable().

I'll redo this patch.

Oleg.

