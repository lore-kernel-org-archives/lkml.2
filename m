Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab1LTQbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 11:31:25 -0500
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:45383 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751418Ab1LTQbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 11:31:13 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: HIshzKQVM1ladIzPWTJScIznoT3Opb2vAM_12C9yXrbYkpJ
 vHwBvXXUGst64HBYLwIIPReLXhBPQFnrpQMa62Rn3uWFdWLZMrsDylrH5y7m
 79WRxSmyE7DBseyi.68asoGUwuhbBnbiOFnmcQk6kkvI7JB8UEU4Pbmrzv7p
 4X_DQTOZ4.DQER.BWyh3mKEg6WeY57Q8_b2WVOcRWjVACF0HAJHYXO.OD5y_
 SPzAZMyXakX_x_sg4K9YldNe7V1Yw9EBxJt.6INwNykE7TUfrg4NLF.Ve9Ew
 xtbVrI5C7la1pxg_41XfxxYMsK23QA5wVyCqd1UTR5b9TUY8EPTfwWmevx4g
 mAvUNparS.KN3aCHAAUU2ndurOVcrjk0O6X91uQkgTLDqbTtDudCVzct83ZK
 q_g0q8lJaYB6pZAaq9I8Dmw--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 20 Dec 2011 10:31:09 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
In-Reply-To: <20111220162315.GC10752@google.com>
Message-ID: <alpine.DEB.2.00.1112201027360.21231@router.home>
References: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain> <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com> <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com> <20111220162315.GC10752@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Dec 2011, Tejun Heo wrote:

> This is __this_cpu_add() + preemption disabled check.  Should be
> removed.  Christoph, is there a use case where __this_cpu_XXX() is
> used without preemption disabled?  Why doesn't it have preemption
> check?

We discussed this before and said that it would be possible to add a
preemption check there. We would need to verify that there is no use case
of __this_cpu_XXX operations in preemptable context. There used to be a
case where we did not care about the races for the vmstat counters but
that seems to have been changed. Not aware of any other use case like
that.

