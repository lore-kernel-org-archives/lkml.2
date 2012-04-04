Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226Ab2DDEB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 00:01:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab2DDEBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 00:01:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1333494844-3802-1-git-send-email-paul.gortmaker@windriver.com>
References: <1333494844-3802-1-git-send-email-paul.gortmaker@windriver.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: Re: [PATCH v2] avr32: fix nop compile fails from system.h split up
Date: Wed, 04 Apr 2012 05:01:41 +0100
Message-ID: <12149.1333512101@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> To fix:
> 
>   In file included from kernel/exit.c:61:
>   arch/avr32/include/asm/mmu_context.h: In function 'enable_mmu':
>   arch/avr32/include/asm/mmu_context.h:135: error: implicit
>   declaration of function 'nop'
> 
> It needs an include of the new file created in:
> 
> commit ae473946586680b01c13975a3b674de23ad7c93e
> 
>     "Disintegrate asm/system.h for AVR32"
> 
> But since that file only contains "nop", and since other
> arch already have precedent of putting nop in asm/barrier.h
> we should just delete the new file and put nop in barrier.h
> 
> Suggested-by: David Howells <dhowells@redhat.com>
> Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: David Howells <dhowells@redhat.com>
