Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab0LGPHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:07:40 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:44108 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753073Ab0LGPHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:07:38 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: .hKCbBEVM1l0wsrunwoAwJaBqacVN7V8monejTxRmgoGdBO
 0nwyxBeloTUjCDJ6NXTup43zvTxhfCwhlCUkSpvDnjZI3y_9..KvjOnl8_wi
 BmPFWrFv_RhH2.KXAHo1_bGdHFYV3CSM_elXpDcVD.Hkvsvx9ecthEXZlXK5
 s4cWU0uw3gnujIpw2jbYBDma6QbFWw.rc8z.LKFDjr7zTJGeLnESC7w1x..8
 Dj5lzYnuv31TTMeIBE6v3F2R5ecrYEzX5b49yPNQ-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 7 Dec 2010 09:07:35 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: akpm@linux-foundation.org, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [Use cpuops V1 04/11] x86: Use this_cpu_ops for current_cpu_data
 accesses
In-Reply-To: <4CFE4BE0.9040203@kernel.org>
Message-ID: <alpine.DEB.2.00.1012070906290.26552@router.home>
References: <20101206171618.302060721@linux.com> <20101206171638.595205962@linux.com> <4CFE41F8.7040400@kernel.org> <4CFE4294.30001@kernel.org> <alpine.DEB.2.00.1012070846050.25976@router.home> <4CFE4BE0.9040203@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Dec 2010, Tejun Heo wrote:

> >> Ooh, was too fast.  I think mixing the use of percpu accesses to
> >> cpu_info and the wrapper macro current_cpu_data is quite confusing.
> >> There aren't too many current_cpu_data users in x86 anyway.  Can you
> >> please make the conversion complete?  I'm moving the above misplaced
> >> chunk into 03 and not applying 04 for now.
> >
> > We cannot make that conversion complete since we cannot obtain the address
> > if we use a this_cpu operation. Then its better to drop this patch.
>
> No, I was talking about dropping current_cpu_data macro.  We can use
> __this_cpu_ptr() for addresses.  I just find it very confusing to mix
> current_cpu_data and using direct percpu accessors on cpu_info.

Hmmm... Ok 21 occurrences. So two patches: Conversion and then
this_cpu_ops. Or one doing both?

