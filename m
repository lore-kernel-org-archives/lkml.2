Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab1DYHai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 03:30:38 -0400
Received: from mail.perches.com ([173.55.12.10]:4958 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756270Ab1DYHag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 03:30:36 -0400
Subject: RE: [PATCH 2/2] misc: add real function
 open/read/write/ioctl/close for moxa_serial_io driver
From: Joe Perches <joe@perches.com>
To: Jimmy Chen =?UTF-8?Q?=28=E9=99=B3=E6=B0=B8=E9=81=94=29?= 
	<jimmy.chen@moxa.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
In-Reply-To: <ECB3782BB8F03341905DD923270296115F67B2@mhqms01.moxa.com>
References: <ECB3782BB8F03341905DD923270296115F67B2@mhqms01.moxa.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Apr 2011 00:30:34 -0700
Message-ID: <1303716634.1745.44.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-25 at 14:44 +0800, Jimmy Chen (陳永達) wrote:
> From: Jimmy Chen <jimmy.chen@moxa.com>
> 
> Add real function and GPL license.
> Check with script/checkpatch.pl

Just some trivia:
There is a mechanism used to prefix logging messages.

> diff --git a/drivers/misc/moxa_serial_io.c b/drivers/misc/moxa_serial_io.c

You could add

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

before any #include

> +#include <linux/module.h>
> +#include <linux/kernel.h>
[]
> +static int __init io_init_module(void)
> +{
> +	unsigned char val;
> +	printk(KERN_INFO "initializing MOXA SERIAL IO module\n");

And convert all the printks to pr_<level>

	pr_info("Initializing module\n");
> +
> +	if (misc_register(&dio_miscdev) != 0) {
> +		printk(KERN_INFO "Moxa serial io driver: Register misc fail !\n");

	pr_err("misc_register failed\n");

[]
> +	printk(KERN_INFO "Moxa V2100 serial io driver, version "
> +			MOXA_SERIAL_IO_VERSION ", " "init OK\n");

	pr_info("Initialized version %s\n", MOXA_SERIAL_IO_VERSION);

> +static void __exit io_cleanup_module(void)
> +{
> +	printk("cleaning up module\n");

	pr_info("Removed\n");


