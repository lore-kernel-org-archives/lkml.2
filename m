Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab0JGVGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:06:14 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:29367 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755967Ab0JGVGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:06:13 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: XGOdPJMVM1k0kQW_lFkD8izzKs6BJ.FYL2DBdcVWYK9aeox
 gKX1ZDHN_gHsZIR4K2qfEu5.1YnUJrZxSw4aIFA8x72XGCsEoVKw3jMvZGFY
 vulqxqx9g4KADdrdUBC_xxuahon3jyCaygxUTLj5tZdL7eymSBLUwYX.CjbI
 24a0VQ2lsPy6TzQTqE6dpLR0lHwemWxFMDTRPaA0kRiygJZUpifxnKTPcKQJ
 9BAstKgEdcRZlMWUq35_jH6K1MscV
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 7 Oct 2010 16:06:10 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] percpu_counter: change inaccurate comment
In-Reply-To: <1286484131.3745.88.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1010071604250.4460@router.home>
References: <1286469421.2912.240.camel@edumazet-laptop>  <alpine.DEB.2.00.1010071440220.28032@router.home>  <1286481860.3745.30.camel@edumazet-laptop>  <alpine.DEB.2.00.1010071509180.28032@router.home> <1286484131.3745.88.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Oct 2010, Eric Dumazet wrote:

> >
> > The only difference between __this_cpu_ptr and this_cpu_ptr is that
> > this_cpu_ptr checks that preempt was disabled. __this_cpu_ptr allows use
> > even without preempt. Preempt must be disabled here so the use of
> > this_cpu_ptr is appropriate.
> >
> >
>
> Thats not how I read the thing.
>
> In both variants, preemption _must_ be disabled, its only the context
> that can tell how sure we are...

Correct. One checks the other one does not check.

> <quote>
>
> commit 7340a0b15280c
>
> __this_cpu_ptr  -> Do not check for preemption context
> this_cpu_ptr    -> Check preemption context
>
> </quote>
>
> If preemption was enabled, both pointers would not be very useful...
>
> We use __this_cpu_ptr() in contexts where cpu _cannot_ change under us,
> (we just disabled preemption one line above), so its not necessary to
> perform the check.

Someone could screw up the code in the future. Thats what its there for.


