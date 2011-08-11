Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab1HKP2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 11:28:48 -0400
Received: from gateway.hbm.com ([213.157.30.2]:8858 "EHLO hbmntx5.hbm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab1HKP2p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 11:28:45 -0400
Thread-Index: AcxYO1tOU85hB7byS/G9s65ZGb0suA==
Thread-Topic: [ANNOUNCE] 3.0.1-rt8 - Regression to 3.0-rt7
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4862
Content-class: urn:content-classes:message
Importance: normal
From: "Tim Sander" <tim.sander@hbm.com>
Organization: Hottinger Baldwin Messtechnik
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [ANNOUNCE] 3.0.1-rt8 - Regression to 3.0-rt7
Date: Thu, 11 Aug 2011 17:28:29 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39; KDE/4.4.5; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>
References: <1312580681.28695.44.camel@twins> <201108111330.28168.tim.sander@hbm.com> <1313064142.7144.1.camel@twins>
In-Reply-To: <1313064142.7144.1.camel@twins>
MIME-Version: 1.0
Content-Type: text/Plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <201108111728.29405.tim.sander@hbm.com>
X-OriginalArrivalTime: 11 Aug 2011 15:28:44.0385 (UTC) FILETIME=[5B3B9D10:01CC583B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter
> Does the below (on top of -rt8) cure things for you? Shouldn't make a
> difference for PREEMPT_LL though, so maybe there's something else busted
> as well. But from what I can tell PREEMPT_BASE should be fine with such
> things disabling preemption..
> 
> ---
> Index: linux-2.6/include/linux/uaccess.h
> ===================================================================
> --- linux-2.6.orig/include/linux/uaccess.h
> +++ linux-2.6/include/linux/uaccess.h
> @@ -22,7 +22,7 @@ static inline void raw_pagefault_enable(
>  	preempt_check_resched();
>  }
> 
> -#ifndef CONFIG_PREEMPT_RT_FULL
> +#ifndef CONFIG_PREEMPT_RT_BASE
>  static inline void pagefault_disable(void)
>  {
>  	raw_pagefault_disable();
> Index: linux-2.6/mm/memory.c
> ===================================================================
> --- linux-2.6.orig/mm/memory.c
> +++ linux-2.6/mm/memory.c
> @@ -3438,7 +3438,7 @@ int handle_pte_fault(struct mm_struct *m
>  	return 0;
>  }
> 
> -#ifdef CONFIG_PREEMPT_RT_FULL
> +#ifdef CONFIG_PREEMPT_RT_BASE
>  void pagefault_disable(void)
>  {
>  	migrate_disable();
The patch fixes the problem for CONFIG_PREEMPT_RTB but not for 
CONFIG_PREEMPT_LL. With the latter the error is still there.

Thanks
Tim

Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich für den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.

