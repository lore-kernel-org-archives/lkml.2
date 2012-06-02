Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468Ab2FBQXp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 12:23:45 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:48678 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758337Ab2FBQXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 12:23:43 -0400
Date: Sat, 2 Jun 2012 18:23:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: David Miller <davem@davemloft.net>, tglx@linutronix.de,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, yong.zhang0@gmail.com,
        akpm@linux-foundation.org, vatsa@linux.vnet.ibm.com, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        nikunj@linux.vnet.ibm.com, vapier@gentoo.org, konrad@gaisler.com,
        tkhai@yandex.ru, sparclinux@vger.kernel.org
Subject: Re: [UPDATED PATCH 21/27] sparc32, smpboot: Use generic SMP
	booting infrastructure
Message-ID: <20120602162340.GA27530@merkur.ravnborg.org>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com> <20120601091503.31979.52537.stgit@srivatsabhat.in.ibm.com> <20120601.135612.699120609738854050.davem@davemloft.net> <20120601185448.GA19148@merkur.ravnborg.org> <4FC94693.5050707@linux.vnet.ibm.com> <20120602065249.GA19558@merkur.ravnborg.org> <20120602074424.GA19690@merkur.ravnborg.org> <4FC9C871.60902@linux.vnet.ibm.com> <20120602151348.GA17409@merkur.ravnborg.org> <4FCA382B.6050601@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FCA382B.6050601@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> As I mentioned in my other mail, I am thinking of changing them to
> arch_cpu_pre_starting(), arch_cpu_pre_online() and arch_cpu_post_online().
> Let me know what you think of those names.
Much better than "__" - so if none of the guys that excel in core
code objects go for that.

> Would you kindly add a changelog and your sign-off to this patch?
Will do in next revision.

...

Thanks for the throughfull review.
I will address all points - including passing the pointer down,
as I assume you have some future plans with that pointer.

> 
> I still didn't get how this solves the original problem of
> not having sparc_cpu_model set to sparc_leon. You mentioned
> that by the time we reach leon_smp_cpu_startup, that variable
> is not set. Even inside leon_smp_cpu_startup, I don't immediately
> see where it is set. Am I missing something?

After looking more closely at the code it is my understanding
that a leon CPU when started will actually jump to the reset
vector and start from there.
So the secondary CPU's will run long time after
sparc_cpu_model is set so we can safely use it.

The sun based cpu will in comparsion jump to
an address supplied to a prom call - so they do not
jump to the reset vector.
But they also have sparc_cpu_model set so no problem there
either.

All this are my deductions from reading the code - but this
is not an area I have looked at otherwise..

I may not find time today to cook up a new version of
the patch - but then you will have it tomorrow.

	Sam
