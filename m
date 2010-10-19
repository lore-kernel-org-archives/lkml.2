Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab0JSQMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 12:12:01 -0400
Received: from tex.lwn.net ([70.33.254.29]:47898 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802Ab0JSQMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:12:00 -0400
Date: Tue, 19 Oct 2010 10:11:58 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] support polling of /proc/swaps
Message-ID: <20101019101158.29e8cd0f@bike.lwn.net>
In-Reply-To: <1287479956.1729.1.camel@yio.site>
References: <1287479956.1729.1.camel@yio.site>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: support polling of /proc/swaps
> 
> System management wants to subscribe to changes in swap
> configuration. Make /proc/swaps pollable like /proc/mounts.

Please forgive me...I'm probably undercaffeinated and even dumber than
usual, but...

Here we have this:

> +static unsigned swaps_poll(struct file *file, poll_table *wait)
> +{
> +	struct proc_swaps *s = file->private_data;

But here I see:

>  static int swaps_open(struct inode *inode, struct file *file)
>  {
> -	return seq_open(file, &swaps_op);
> +	struct proc_swaps *s;
> +	int ret;
> +
> +	s = kmalloc(sizeof(struct proc_swaps), GFP_KERNEL);
> +	if (!s)
> +		return -ENOMEM;
> +
> +	file->private_data = &s->seq;

It sure looks to me like private_data is a struct seq_file pointer, not a
struct proc_swaps pointer.  What am I missing?

Thanks,

jon
