Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab0F1Uod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 16:44:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752863Ab0F1Uoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 16:44:32 -0400
Date: Mon, 28 Jun 2010 13:44:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Samium Gromoff <_deepfire@feelingofgreen.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: MMIO32 support for 8250_early.c
Message-Id: <20100628134426.0558ac67.akpm@linux-foundation.org>
In-Reply-To: <87r5jxva3n.fsf@auriga.deep>
References: <87r5jxva3n.fsf@auriga.deep>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jun 2010 23:10:20 +0400
Samium Gromoff <_deepfire@feelingofgreen.ru> wrote:

> This should be fairly uncontroversial, but YMMV.
> 
> Available from master branch at git://git.feelingofgreen.ru/linux
> 
> commit 67e21ada6739e0730fb28f855abf4202a1bb3f8c
> Author: Samium Gromoff <deepfire@elvees.com>
> Date:   Thu Jun 24 00:36:16 2010 +0400
> 
>     Provide MMIO32 support in 8250_early (aka earlycon)

Please update Documentation/kernel-parameters.txt.

> ...
>
> @@ -182,9 +199,9 @@ static int __init parse_options(struct early_serial8250_device *device,
>  	}
>  
>  	printk(KERN_INFO "Early serial console at %s 0x%llx (options '%s')\n",
> -		mmio ? "MMIO" : "I/O port",
> -		mmio ? (unsigned long long) port->mapbase
> -		     : (unsigned long long) port->iobase,
> +		mmio ? "MMIO" : mmio32 ? "MMIO32" : "I/O port",
> +		(mmio | mmio32) ? (unsigned long long) port->mapbase
> +		                : (unsigned long long) port->iobase,
>  		device->options);

That printk has just got out of control.  We should at the very least
parenthesise that ?:?: thing before someone sees it and dies.  Or just
rip it up and reimplement it.  Note that mapbase can be printed with %p
and iobase with %pr, but the code munges them both into ull's and uses
%llx.

