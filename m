Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab1FVQiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 12:38:06 -0400
Received: from mail.perches.com ([173.55.12.10]:3119 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756627Ab1FVQiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 12:38:05 -0400
Subject: Re: [PATCH] kernel: escape non-ASCII and control characters in
 printk()
From: Joe Perches <joe@perches.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        security@kernel.org
In-Reply-To: <20110622095341.GA3353@albatros>
References: <20110622095341.GA3353@albatros>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 09:38:03 -0700
Message-ID: <1308760683.10423.16.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-22 at 13:53 +0400, Vasiliy Kulikov wrote:
> This patch escapes all characters outside of allowed '\n' plus 0x20-0x7E
> charset passed to printk().

[]

> diff --git a/kernel/printk.c b/kernel/printk.c
[]
> +static void emit_log_char_escaped(char c)
> +{
> +	char buffer[8];
> +	int i, len;
> +
> +	if ((c >= ' ' && c < 127) || c == '\n')

	if (isprint(c))

Why not add this to emit_log_char?


