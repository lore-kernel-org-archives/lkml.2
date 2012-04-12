Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762298Ab2DLTU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 15:20:29 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:53645 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab2DLTU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 15:20:28 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: David Daney <ddaney.cavm@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] iqrdomain: Improve formatting in debugfs.
References: <1334016417-18748-1-git-send-email-ddaney.cavm@gmail.com>
	<20120411070332.6F3C03E081E@localhost>
X-Yow: Either CONFESS now or we go to ``PEOPLE'S COURT''!!
Date: Thu, 12 Apr 2012 21:20:23 +0200
In-Reply-To: <20120411070332.6F3C03E081E@localhost> (Grant Likely's message of
	"Wed, 11 Apr 2012 01:03:32 -0600")
Message-ID: <m2k41kycy0.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely <grant.likely@secretlab.ca> writes:

> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 9310a8d..eb05e40 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -643,8 +643,8 @@ static int virq_debug_show(struct seq_file *m, void *private)
>  	void *data;
>  	int i;
>  
> -	seq_printf(m, "%-5s  %-7s  %-15s  %-18s  %s\n", "virq", "hwirq",
> -		      "chip name", "chip data", "domain name");
> +	seq_printf(m, "%-5s  %-7s  %-15s  %-*s  %s\n", "irq", "hwirq",
> +		      "chip name", 2 * sizeof(void *) + 2, "chip data", "domain name");

kernel/irq/irqdomain.c:647:9: warning: field width specifier ‘*’ expects argument of type ‘int’, but argument 6 has type ‘long unsigned int’ [-Wformat]

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
