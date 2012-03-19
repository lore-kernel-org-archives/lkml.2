Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162150Ab2CSQbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:31:53 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:22546 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756590Ab2CSQbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:31:50 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 93bxshMVM1kpvndxBVgPsbhiJyzflYj1G60UJtF3RvcxorR
 h1P_zUhvto6LGvzGc_8bPc4eYNqQJwfNw.juklu_a0oJ1qcRSAkLOrhzW9xj
 UfMyM84cDLlhDhDyK2qO7ZjAZHW.Voth17s8hO7itKmzhhvkFhyazDJ4Wmez
 fDmstDMJjRvOX_FPHrzUFUXfoR3NznFcTZVx1tT1BQO4V7rKXbHTpKeTDsMA
 Ooqg4k0mhQYClg763ERrWNy7k6_OJKIH.uO2tp5TRlV_OtEBceb8pEUYmK4y
 Dym_S50c5xf3P_dElfjizGuooZIDVszUAta0kYHbwFk9mkzs_khr.1SU6Our
 fYrDY0YGJayfPgz41jK9qxs2DTbLLTvAJaB9zItGI8zOQjVsF3VFiS1A29t4
 R
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 19 Mar 2012 11:31:47 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Sasha Levin <levinsasha928@gmail.com>
cc: Pablo Neira Ayuso <pablo@netfilter.org>, kaber@trash.net,
        davem@davemloft.net, Dave Jones <davej@redhat.com>,
        netfilter-devel@vger.kernel.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: netfilter: Hung task
In-Reply-To: <CA+1xoqdo5zvUe+=BYr42iEEq9mU=kd1zVxrGhQc0sNYqbpBkNQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1203191129440.20196@router.home>
References: <CA+1xoqfCTXxXsbfUjttuOVutyD_FzYS8PoOoAOOtB72P8SwdVg@mail.gmail.com> <20120318141943.GA28850@1984> <CA+1xoqcQYqCgQb=1M5PVkm=6SBhV2oJxJ2CtBp=gAvZM36Kc2Q@mail.gmail.com> <20120319002811.GA30408@1984> <alpine.DEB.2.00.1203190854560.16879@router.home>
 <CA+1xoqdo5zvUe+=BYr42iEEq9mU=kd1zVxrGhQc0sNYqbpBkNQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012, Sasha Levin wrote:

> On Mon, Mar 19, 2012 at 3:56 PM, Christoph Lameter <cl@linux.com> wrote:
> > This is sually something causing memory corruption. Please enable
> > debugging to get backtrace that help to debutg this. CONFIG_SLUB_DEBUG_ON
> > will do the trick or passing "slub_debug" on the kernel command line.
>
> The kernel was compiled with SLUB_DEBUG_ON, there's nothing coming out
> of the slub before that hang message, nor after it.

Ok looking at the backtrace: This is kmem_cache_destroy and not the usual
failure following a pointer in alloc / free.

netfilter calls kmem_cache_destroy which calls into sysfs functions and
there the hang occurs.

Did you try to see if lockdep can detect any serialization problems ?

Is kmem_cache_destroy called with any locks held? Interrupts off?

