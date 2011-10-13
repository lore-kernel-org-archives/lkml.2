Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab1JMKo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:44:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38264 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab1JMKoZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:44:25 -0400
Subject: Re: [PATCH RFC V4 10/10] jump-label: initialize jump-label
 subsystem much earlier
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Thu, 13 Oct 2011 12:43:48 +0200
In-Reply-To: <c133180533d7e520bb1e818e987117811a666fbc.1318464413.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1318464169.git.jeremy.fitzhardinge@citrix.com>
	 <c133180533d7e520bb1e818e987117811a666fbc.1318464413.git.jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318502628.24856.10.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-12 at 17:08 -0700, Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Initialize jump_labels much earlier, we can use them.

We can use them, where? how? what?, that sentence just begs for more.

> diff --git a/init/main.c b/init/main.c
> index 2a9b88a..f4094ed 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -637,6 +637,7 @@ asmlinkage void __init start_kernel(void)
>  	acpi_early_init(); /* before LAPIC and SMP init */
>  	sfi_init_late();
>  
> +	jump_label_init();
>  	ftrace_init();
>  
>  	/* Do the rest non-__init'ed, we're now alive */

Can we push them much earlier still? If possible I'd like them to be
before sched_init() so that I might use them there, if not possible, at
the very least before enabling interrupts would be nice.


