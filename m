Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab0DVPHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 11:07:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64892 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182Ab0DVPHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 11:07:41 -0400
Date: Thu, 22 Apr 2010 08:04:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Guillaume Knispel <gknispel@proformatique.com>
Cc: linux-kernel@vger.kernel.org, Linuxppc-dev@lists.ozlabs.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>, Ingo Molnar <mingo@elte.hu>,
       Lars-Peter Clausen <lars@metafoo.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Buesch <mb@bu3sch.de>, Peter Zijlstra <peterz@infradead.org>,
       Russell King <linux@arm.linux.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] genirq: update doc
Message-Id: <20100422080421.64a3006e.randy.dunlap@oracle.com>
In-Reply-To: <1271941798-9659-3-git-send-email-gknispel@proformatique.com>
References: <1271941798-9659-1-git-send-email-gknispel@proformatique.com>
	<1271941798-9659-3-git-send-email-gknispel@proformatique.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090205.4BD065C7.011B:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Apr 2010 15:09:58 +0200 Guillaume Knispel wrote:

> Following "genirq: always build resend_irqs" and previous changes, this
> commit updates the genirq DocBook.
> 
> ---
>  Documentation/DocBook/genericirq.tmpl |   73 ++++++++++++++++++--------------
>  1 files changed, 41 insertions(+), 32 deletions(-)
> 
> diff --git a/Documentation/DocBook/genericirq.tmpl b/Documentation/DocBook/genericirq.tmpl
> index 1448b33..5ee204c 100644
> --- a/Documentation/DocBook/genericirq.tmpl
> +++ b/Documentation/DocBook/genericirq.tmpl
> @@ -240,8 +240,6 @@ default_enable(irq)
>  
>  default_disable(irq)
>  {
> -	if (!delay_disable(irq))
> -		desc->chip->mask(irq);
>  }
>  
>  default_ack(irq)
> @@ -264,7 +262,11 @@ noop(irq)
>  }
>  
>  		</programlisting>
> -	        </para>
> +	        Note: default_disable is empty so that an edge-triggered

		      default_disable()

> +		interrupt happening between a disable_irq() and an enable_irq()
> +		is catched by the kernel for later replay. See

		   caught

> +		<xref linkend="Delayed_interrupt_disable"/> for details.
> +		</para>
>  	    </sect3>
>  	</sect2>
>  	<sect2 id="Default_flow_handler_implementations">

[snip]


---
~Randy
