Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab1EYOme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:42:34 -0400
Received: from mail.perches.com ([173.55.12.10]:1994 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757457Ab1EYOmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:42:33 -0400
Subject: Re: [PATCH 1/4] include/linux/printk.h is not self-contained
From: Joe Perches <joe@perches.com>
To: y@mail.of.borg
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
In-Reply-To: <1306314554-19198-1-git-send-email-y>
References: <1306314554-19198-1-git-send-email-y>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 07:42:31 -0700
Message-ID: <1306334551.2298.89.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 11:09 +0200, y@mail.of.borg wrote:
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> <linux/printk.h> needs to include
>   - <stdarg.h> for "va_list",
>   - <linux/linkage.h> for "asmlinkage",
>   - <linux/types.h> for "bool".

I wonder if printk should be self-contained.

If so, this patch should also add:

#include <linux/dynamic_debug.h>
#include <linux/ratelimit.h>

If not, maybe add:

#ifndef _LINUX_KERNEL_H
#error don't include <linux/printk.h> directly, use <linux/kernel.h>
#endif

Also asmlinkage is an ancient artifact and should
be removed from the declarations of early_printk,
vprintk, and printk.

