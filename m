Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab1CXTCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:02:22 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:33880 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751233Ab1CXTCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:02:21 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: EQ_GG8kVM1kjze._n3gX59aIslCTHrDFCxMBU2NpMQcTOJK
 CEeW7E0n3SIp7OqQxxgTrl4wYOVcyLvgPzhT0lP8swMegNLUrAnsQRMxNJ3F
 mLyvmcj3sMtzL.8MjMftdll50wl461CRY7AhAjt0RXVaSFgaErld5e5nA4Cm
 1ZlLupIHr0WE2rej9tqX7fNBz9Wk_jNePl.wtyOmuUXaVzzuonHck2jpTlb5
 dZ3pxQy18_KXa16JCuOu6vQ2vN8fGZigh98uqVf_Mf9S.GCRmsieTD0DEgyc
 HO4IYPv8mtef96GkYKOt73lugLNUtEoaMywK_Y3xite9VY43Fbp0db3n8_vE
 7WxYUUXj5XAuTkOCeFQYqktCr
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 24 Mar 2011 14:02:17 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tj@kernel.org, npiggin@kernel.dk, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
In-Reply-To: <1300992708.3747.211.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1103241401090.5576@router.home>
References: <alpine.DEB.2.00.1103221635400.4521@tiger>  <20110324142146.GA11682@elte.hu>  <alpine.DEB.2.00.1103240940570.32226@router.home>  <AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com>  <20110324172653.GA28507@elte.hu> 
 <alpine.DEB.2.00.1103241242450.32226@router.home>  <AANLkTimMcP-GikCCndQppNBsS7y=4beesZ4PaD6yh5y5@mail.gmail.com>  <alpine.DEB.2.00.1103241300420.32226@router.home>  <AANLkTi=KZQd-GrXaq4472V3XnEGYqnCheYcgrdPFE0LJ@mail.gmail.com>  <alpine.DEB.2.00.1103241312280.32226@router.home>
  <1300990853.3747.189.camel@edumazet-laptop>  <alpine.DEB.2.00.1103241346060.32226@router.home> <1300992708.3747.211.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1430651396-1300993340=:5576"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-1430651396-1300993340=:5576
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 24 Mar 2011, Eric Dumazet wrote:

> Le jeudi 24 mars 2011 =C3=A0 13:47 -0500, Christoph Lameter a =C3=A9crit =
:
>
> > Hmmm.. Could be. KVM would not really disable interrupts so this may
> > explain that the test case works here.
> >
> > Simple fix would be to do a load before the cli I guess.
> >
>
> Hmm...
>
> If we have a preemption and migration right after this load...

Cannot be the issue here since init_kmem_cache_cpus already
touches the per cpu data. At least if CONFIG_PREEMPT is on.
Is it on?


void init_kmem_cache_cpus(struct kmem_cache *s)
{
#if defined(CONFIG_CMPXCHG_LOCAL) && defined(CONFIG_PREEMPT)
        int cpu;

        for_each_possible_cpu(cpu)
                per_cpu_ptr(s->cpu_slab, cpu)->tid =3D init_tid(cpu);
#endif

}



---1463811839-1430651396-1300993340=:5576--
