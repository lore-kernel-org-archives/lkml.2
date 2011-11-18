Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab1KRK0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 05:26:32 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50296 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab1KRK0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 05:26:31 -0500
Date: Fri, 18 Nov 2011 10:16:28 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, mrst: Casting (void *) value returned by kmalloc
 is useless
Message-ID: <20111118101628.5013a1ea@pyx>
In-Reply-To: <1321569820.1624.244.camel@localhost.localdomain>
References: <1321569820.1624.244.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011 23:43:40 +0100
Thomas Meyer <thomas@m3y3r.de> wrote:

> The semantic patch that makes this change is available
> in scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
> 
> diff -u -p a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
> --- a/arch/x86/platform/mrst/mrst.c 2011-11-07 19:37:40.283168752 +0100
> +++ b/arch/x86/platform/mrst/mrst.c 2011-11-08 09:19:24.686513740 +0100
> @@ -331,7 +331,7 @@ static int __init sfi_parse_gpio(struct
>  	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_gpio_table_entry);
>  	pentry = (struct sfi_gpio_table_entry *)sb->pentry;
>  
> -	gpio_table = (struct sfi_gpio_table_entry *)
> +	gpio_table =
>  				kmalloc(num * sizeof(*pentry), GFP_KERNEL);

True but the formatting also wants fixing with that change.

