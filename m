Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab1CQSmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 14:42:16 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:47590 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755068Ab1CQSmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 14:42:14 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: W8WBpioVM1n45zAp80Cz68lRur2Z9Yj5wZiuBSR7WJrxj4o
 NJe9d8OGlZQjL5SVWfYjzL0f3q0HmVYMkbH0.NhYsGCH.j2XAxJsxJCNZeSI
 XaLEa3E3bCBe.m4gcAexPOZtKAJ6ZnT1955MuMO8.E9_M.kbcGcegYlVj_oD
 uQNufz4pqRRiHya0XjNg_7.7F9QeI.5lWE5QlWKGr99D5vEuIkz.yze2MFPP
 y5lb3ptZ4uEw3GPJu1Ls4efaZDg6gBJ_nVdTTNxeEbvPIwKG9rD83HbRFf3J
 Vs4LBdrDJWdiWEP342Yy2.qdDAySgvB8lY_THKmCYCK6oS0HG
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 17 Mar 2011 13:42:10 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: Poll about irqsafe_cpu_add and others
In-Reply-To: <1300386569.6315.404.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1103171338350.18529@router.home>
References: <1300371834.6315.93.camel@edumazet-laptop>  <20110317.081420.71114992.davem@davemloft.net>  <alpine.DEB.2.00.1103171016270.12540@router.home>  <1300380801.6315.306.camel@edumazet-laptop>  <alpine.DEB.2.00.1103171245430.16620@router.home>
 <1300386569.6315.404.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011, Eric Dumazet wrote:

> By the way, I noticed :
>
> DECLARE_PER_CPU(u64, xt_u64);
> __this_cpu_add(xt_u64, 2) translates to following x86_32 code :
>
> 	mov	$xt_u64,%eax
> 	add	%fs:0x0,%eax
> 	addl	$0x2,(%eax)
> 	adcl	$0x0,0x4(%eax)
>
>
> I wonder why we dont use :
>
> 	addl	$0x2,%fs:xt_u64
> 	addcl	$0x0,%fs:xt_u64+4

The compiler is fed the following

	*__this_cpu_ptr(xt_u64) += 2

__this_cpu_ptr makes it:

	*(xt_u64 + __my_cpu_offset) += 2

So the compiler calculates the address first and then increments it.

The compiler could optimize this I think. Wonder why that does not happen.




