Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab1L1WOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 17:14:42 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:34490 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754616Ab1L1WOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 17:14:41 -0500
Message-ID: <1325110478.16729.7.camel@joe2Laptop>
Subject: Re: [PATCH] sep: SEP update
From: Joe Perches <joe@perches.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Mark Allyn <mark.a.allyn@intel.com>
Date: Wed, 28 Dec 2011 14:14:38 -0800
In-Reply-To: <20111228173748.3323.89307.stgit@bob.linux.org.uk>
References: <20111228173748.3323.89307.stgit@bob.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-28 at 17:37 +0000, Alan Cox wrote:
> From: Mark Allyn <mark.a.allyn@intel.com>
> The new driver supports the kernel crypto layer, passes the coding style checks,
> passes human taste checks and has proper kernel-doc formatted comments.

These are just taste comments.

> diff --git a/drivers/staging/sep/sep_crypto.c b/drivers/staging/sep/sep_crypto.c
[]
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

> +/* #define DEBUG */
> +#include <linux/init.h>
[]
> +	sep_work->callback = funct;
> +	sep_work->data = data;
> +	INIT_WORK(&sep_work->work, sep_do_callback);
> +	result = queue_work(work_queue, &sep_work->work);
> +	if (!result) {
> +		pr_debug("sep_crypto: queue_work failed\n");

So these pr_debug and any other pr_<level> become:
		pr_debug("queue_work failed\n");

> +/* Debug - prints only if DEBUG is defined; follows kernel debug model */
> +static void sep_dump(struct sep_device *sep, char *stg, void *start, int len)
> +{
> +#if 0
> +	int ct1;
> +	u8 *ptt;
> +
> +	dev_dbg(&sep->pdev->dev,
> +		"Dump of %s starting at %08lx for %08x bytes\n",
> +		stg, (unsigned long)start, len);
> +	for (ct1 = 0; ct1 < len; ct1 += 1) {
> +		ptt = (u8 *)(start + ct1);
> +		dev_dbg(&sep->pdev->dev, "%02x ", *ptt);
> +		if (ct1 % 16 == 15)
> +			dev_dbg(&sep->pdev->dev, "\n");
> +	}

While this is #if 0, more likely it should
use print_hex_dump_bytes

> +/**
> + * RFC2451: Weak key check
> + * Returns: 1 (weak), 0 (not weak)
> + */
> +static int sep_weak_key(const u8 *key, unsigned int keylen)
> +{
> +	static const u8 parity[] = {
> +	8, 1, 0, 8, 0, 8, 8, 0, 0, 8, 8, 0, 8, 0, 2, 8,
> +	0, 8, 8, 0, 8, 0, 0, 8, 8,
> +	0, 0, 8, 0, 8, 8, 3,

Any reason this is formatted with line lengths of 16, 9, 7
instea of all 16?

> +	0, 8, 8, 0, 8, 0, 0, 8, 8, 0, 0, 8, 0, 8, 8, 0,
> +	8, 0, 0, 8, 0, 8, 8, 0, 0,
> +	8, 8, 0, 8, 0, 0, 8,

> +	if (!((n - (w >> 3)) & w)) {
> +		if (n < 0x41415151) {

Perhaps use a switch/case instead of an 
difficult to read binary chop?


> +			/* Portion of msg is nulled (no data) */
> +			msg[0] = (u32)0;

The casts of zero are odd.

