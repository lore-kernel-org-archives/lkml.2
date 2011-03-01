Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab1CAFZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 00:25:41 -0500
Received: from mail.perches.com ([173.55.12.10]:3998 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab1CAFZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 00:25:40 -0500
Subject: Re: [RFC v2 1/2] dynamic debug: add dynamic_hexdump_debug macro
From: Joe Perches <joe@perches.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Kiran Divekar <dkiran@marvell.com>, Frank Huang <frankh@marvell.com>
In-Reply-To: <1298956016-30673-2-git-send-email-bzhao@marvell.com>
References: <1298956016-30673-1-git-send-email-bzhao@marvell.com>
	 <1298956016-30673-2-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Feb 2011 21:25:38 -0800
Message-ID: <1298957138.4367.3.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-28 at 21:06 -0800, Bing Zhao wrote:
> dynamic_hexdump_debug(str, buf, len)

> diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
> +#define dynamic_hexdump_debug(str, buf, len)				\
> +do {									\
> +	static struct _ddebug descriptor				\
> +	__used								\
> +	__attribute__((section("__verbose"), aligned(8))) =		\
> +	{ KBUILD_MODNAME, __func__, __FILE__, str, __LINE__,		\
> +		_DPRINTK_FLAGS_DEFAULT };				\
> +	if (unlikely(descriptor.enabled)) {				\
> +		printk(KERN_DEBUG str);					\
> +		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, buf, len);	\

Perhaps
		print_hex_dump(str, DUMP_PREFIX_OFFSET, buf, len);

