Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab0DRUl2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 16:41:28 -0400
Received: from mail.perches.com ([173.55.12.10]:1517 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab0DRUl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 16:41:27 -0400
Subject: Re: is there any chance of cleaning up the "inline" chaos?
From: Joe Perches <joe@perches.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1004181605220.4775@localhost>
References: <alpine.LFD.2.00.1004181605220.4775@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 18 Apr 2010 13:41:25 -0700
Message-ID: <1271623285.1730.56.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-04-18 at 16:06 -0400, Robert P. J. Day wrote:
> i mean, how many different definitions of inline are necessary?
> 
> #if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) || \
>     !defined(CONFIG_OPTIMIZE_INLINING) || (__GNUC__ < 4)
> # define inline         inline          __attribute__((always_inline))
> # define __inline__     __inline__      __attribute__((always_inline))
> # define __inline       __inline        __attribute__((always_inline))
> #endif

Heave to, have at it.

$ git grep -w "inline" * | wc -l
35526
$ git grep -w "__inline__" * | wc -l
872
$ git grep -w "__inline" * | wc -l
17

It looks like __inline is almost exclusively in staging
and should be easy to fix/change

__inline__ is spread around all over the place

$ git grep -wl __inline__ * | wc -l
265

It could be converted over time or in a single sweep
like the recent slab changes.


