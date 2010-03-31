Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996Ab0CaCYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 22:24:18 -0400
Received: from mail.perches.com ([173.55.12.10]:1287 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932916Ab0CaCYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 22:24:10 -0400
Date: Tue, 30 Mar 2010 18:24:01 -0800 (PST)
From: Joe Perches <joe@perches.com>
To: Pavan Savoy <pavan_savoy@ti.com>
cc: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       <marcel@holtmann.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers:staging: sources for ST core
In-Reply-To: <54146.53246.qm@web94908.mail.in2.yahoo.com>
Message-ID: <Pine.LNX.4.30.1003301817330.22228-100000@mail.perches.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010, Pavan Savoy wrote:
> +bool is_protocol_list_empty(void)
> +{
> +	unsigned char i = 0;
> +	pr_debug(" %s ", __func__);

You need to add terminating '\n's to most all these messages.
It's also not necessary to have leading or trailing whitespace.

> +#ifdef VERBOSE
> +	printk(KERN_ERR "start data..\n");
> +	for (i = 0; i < count; i++)	/* no newlines for each datum */
> +		printk(" %x", data[i]);
> +	printk(KERN_ERR "\n ..end data\n");
> +#endif

	print_hex_dump(KERN_ERR, "data: ", DUMP_PREFIX_OFFSET, 16, 1,
                       data, count, true);

cheers, Joe

