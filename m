Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab2A3WD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:03:26 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49938 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab2A3WDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:03:25 -0500
Date: Mon, 30 Jan 2012 22:04:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
Cc: linux-kernel@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>,
        "Huang, Shane" <Shane.Huang@amd.com>, Borislav Petkov <bp@amd64.org>,
        "Nguyen, Dong" <Dong.Nguyen@amd.com>, jesse.brandeburg@gmail.com
Subject: Re: [PATCH] Unhandled IRQs on AMD E-450: temporarily switch to
 low-performance polling IRQ mode
Message-ID: <20120130220426.4d4d48a7@pyramind.ukuu.org.uk>
In-Reply-To: <CAPRPZsAt+e3cy1YTriikpb2SNN=jOusvnPF0ByFeun+uaBa5Og@mail.gmail.com>
References: <CAPRPZsAt+e3cy1YTriikpb2SNN=jOusvnPF0ByFeun+uaBa5Og@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +				printk("Polling IRQ %d\n", irq);

printk levels would be good.


> -		__report_bad_irq(irq, desc, action_ret);
> +		/* __report_bad_irq(irq, desc, action_ret); */

And this removes debugging for a reason that isn't described ?


In general this looks sane although it may do bad stuff on some platforms
I guess - notably irqpoll has an x86 ism in it still that now may need
dealing with (the IRQ 0 magic)

Alan
