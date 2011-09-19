Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab1ISJBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 05:01:40 -0400
Received: from symlink.to.noone.org ([85.10.207.172]:34848 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab1ISJBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 05:01:38 -0400
Date: Mon, 19 Sep 2011 11:01:37 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (input
	tree related)
Message-ID: <20110919090137.GM11405@distanz.ch>
References: <20110919184621.ac27f3d519e397a82efc6d4a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110919184621.ac27f3d519e397a82efc6d4a@canb.auug.org.au>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-19 at 10:46:21 +0200, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc allyesconfig)
> failed like this:
> 
> drivers/input/keyboard/gpio_keys.c: In function 'gpio_keys_get_devtree_pdata':
> drivers/input/keyboard/gpio_keys.c:500:3: warning: passing argument 3 of 'of_property_read_u32' from incompatible pointer type
> include/linux/of.h:268:19: note: expected 'u32 *' but argument is of type 'const u32 **'
> drivers/input/keyboard/gpio_keys.c:504:19: warning: assignment makes integer from pointer without a cast
> drivers/input/keyboard/gpio_keys.c:508:3: warning: passing argument 3 of 'of_property_read_u32' from incompatible pointer type
> include/linux/of.h:268:19: note: expected 'u32 *' but argument is of type 'const u32 **'
> drivers/input/keyboard/gpio_keys.c:509:20: warning: assignment makes integer from pointer without a cast
> drivers/input/keyboard/gpio_keys.c:515:3: warning: passing argument 3 of 'of_property_read_u32' from incompatible pointer type
> include/linux/of.h:268:19: note: expected 'u32 *' but argument is of type 'const u32 **'
> drivers/input/keyboard/gpio_keys.c:516:33: warning: assignment makes integer from pointer without a cast
> drivers/input/keyboard/gpio_keys.c:502:4: error: label 'out_fail' used but not defined
> drivers/input/keyboard/gpio_keys.c: At top level:
> drivers/input/keyboard/gpio_keys.c:523:7: error: expected '=', ',', ';', 'asm' or '__attribute__' before '->' token
> drivers/input/keyboard/gpio_keys.c:525:2: error: expected identifier or '(' before 'return'
> drivers/input/keyboard/gpio_keys.c:527:9: error: expected '=', ',', ';', 'asm' or '__attribute__' before ':' token
> drivers/input/keyboard/gpio_keys.c:529:2: error: expected identifier or '(' before 'return'
> drivers/input/keyboard/gpio_keys.c:530:1: error: expected identifier or '(' before '}' token
> drivers/input/keyboard/gpio_keys.c: In function 'gpio_keys_get_devtree_pdata':
> drivers/input/keyboard/gpio_keys.c:521:2: warning: control reaches end of non-void function
> 
> Caused by commit d6ba97c9806b ("Input: gpio_keys - use
> of_property_read_u32()").  Mostly by a brace mismatch.

Sorry, my fault. I thought I compile-tested this but obviously didn't.
I'll send an updated patch to Dmitry.

Tobias
