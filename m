Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab0LYXz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 18:55:27 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:47805 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751107Ab0LYXz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 18:55:26 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: tVIltT0VM1luiCzmiCwUjbxaA355q1WHmTEWPU7AV8rnRyw
 vCdSPwk1QBaMjLFEqd7rB3au87KR9p52DyHCzSKfFCwLgBNFmedpmRjJ4r.x
 dtzGqb7MEAGg4Wara14nOsieKu5LCAsOuZfdpWVVe6qG.tmDjNGzOg54D2yo
 kzZLUwlRAGAmoBADZl2cWbIpLSPr4IpUjv9qel9Yal46EUTlD.K0DFEbC3OK
 z_eNlqAgm.qw2aEHgLzEvgkud5KbXB4_j5K8neY1nFyDd5NGudX5U4EaCRcC
 CG1k93sWk2OjJVRpp3tEl5iWCShkqpkjwauGmFZWjhK4mbbs-
X-Yahoo-Newman-Property: ymail-3
Date: Sat, 25 Dec 2010 17:55:22 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V1 1/4] Generic support for
 this_cpu_cmpxchg_double
In-Reply-To: <AANLkTikSwwMtDwx4wGM8hO4riZFVmtkq_bihVvPirO8F@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1012251753530.8506@router.home>
References: <20101214174847.887713690@linux.com> <20101214174900.058235985@linux.com> <4D0CC982.3030905@kernel.org> <alpine.DEB.2.00.1012211634560.3769@router.home> <4D11373D.9010205@zytor.com> <20101222091358.GC27861@htj.dyndns.org>
 <alpine.DEB.2.00.1012231812280.22549@router.home> <4D13E7D5.7020503@zytor.com> <alpine.DEB.2.00.1012242251090.23107@router.home> <AANLkTikSwwMtDwx4wGM8hO4riZFVmtkq_bihVvPirO8F@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Dec 2010, Tejun Heo wrote:

> ABI.  But that said, it might still be problematic on other
> architectures when we try to apply it to different architectures.  Is
> everyone against just taking a scalar for the first variable instead
> of taking a pointer?  I'd be happier with that than the current one.

How about replacing that with two scalars? Macro will check that the
scalaers are properly aligned and that the second follows the first. Then
there is also better symmetry in the parameters.

bool this_cpu_cmpxchg_double(
          percpu_1, percpu_2
          old_1, old_2
          new_1, new_2
)

