Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab1CaGsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:48:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48150 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab1CaGse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 02:48:34 -0400
Date: Thu, 31 Mar 2011 08:48:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>,
        Jack Steiner <steiner@sgi.com>, Robin Holt <holt@sgi.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] printk: Allocate kernel log buffer earlier v2
Message-ID: <20110331064820.GB5938@elte.hu>
References: <20110225180634.017570095@gulag1.americas.sgi.com>
 <20110227120949.GF16453@elte.hu>
 <20110227121518.GA19165@elte.hu>
 <4D6AFBB0.70401@kernel.org>
 <4D6BF63D.2020404@sgi.com>
 <AANLkTi=Sn6DKAjGHQjtWGiLGh8vpuS-vmXK=TMDrbjdv@mail.gmail.com>
 <4D6BFF46.3050001@sgi.com>
 <AANLkTi=Xf5RaF559QsRNijmG0YP7amkG569NZFhpt4QY@mail.gmail.com>
 <4D93CDD7.8000708@sgi.com>
 <4D93D180.6020300@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D93D180.6020300@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> Subject: printk: Allocate kernel log buffer earlier v2
> 
> On larger systems, because of the numerous ACPI, Bootmem and EFI
> messages, the static log buffer overflows before the larger one
> specified by the log_buf_len param is allocated.  Minimize the
> overflow by allocating the new log buffer as soon as possible.
> 
> The allocation method is passed in as an argument to make
> backporting to "pre-memblock" kernels easier.

Hm, all that allocation pointer magic looks a tad too complex and non-obvious.

Why not just make it as simple and obvious as possible for the current kernel - 
and we can still mark it -stable and you backport it to the non-memblock 
kernel? That keeps compatibility complexity out of upstream ...

Thanks,

	Ingo
