Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671Ab1CXSr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:47:29 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:28053 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933447Ab1CXSr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:47:27 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 3bWGxJ4VM1nBA7_NALc1b9So2E6l1rcp1Ym8yAKHZesDHDS
 TPYnLeQf3f72n6A.exwpbPlpivQGCruFF488XoTSJ1GU7DTn_VRlG2WlBUQx
 JAYzZcpRdxZ40O3s2p_ySg0XRS0VgFUTlkyBbKulj81WpKcNtMUHD66EI6Do
 IV7GEt.LH0pBtdiWX1V3ZGt1ttP9_4yG.yg0Qp_zhdxzOy1CtQ2M3TBQXKxa
 R.A4D9lUXBT13D2nfOKyheOK7wO2EJOwnFT8qmNBCMBJxogUpK8.xUP4yTJR
 Kbs._xlFjgyfpLErOtDLvKCFHRDI_8crqtXJMGssej3ZXSNY0K6Da6PtGZf8
 5zacJ5LHjZ8V6nZBgTi7HvNDl
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 24 Mar 2011 13:47:23 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tj@kernel.org, npiggin@kernel.dk, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
In-Reply-To: <1300990853.3747.189.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1103241346060.32226@router.home>
References: <alpine.DEB.2.00.1103221635400.4521@tiger>  <20110324142146.GA11682@elte.hu>  <alpine.DEB.2.00.1103240940570.32226@router.home>  <AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com>  <20110324172653.GA28507@elte.hu> 
 <alpine.DEB.2.00.1103241242450.32226@router.home>  <AANLkTimMcP-GikCCndQppNBsS7y=4beesZ4PaD6yh5y5@mail.gmail.com>  <alpine.DEB.2.00.1103241300420.32226@router.home>  <AANLkTi=KZQd-GrXaq4472V3XnEGYqnCheYcgrdPFE0LJ@mail.gmail.com>  <alpine.DEB.2.00.1103241312280.32226@router.home>
 <1300990853.3747.189.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 24 Mar 2011, Eric Dumazet wrote:

> > this_cpu_cmpxchg16b_emu:
> >         pushf
> >         cli
> >
> >         cmpq %gs:(%rsi), %rax

> Random guess
>
> Masking interrupts, and accessing vmalloc() based memory for the first
> time ?

Hmmm.. Could be. KVM would not really disable interrupts so this may
explain that the test case works here.

Simple fix would be to do a load before the cli I guess.

