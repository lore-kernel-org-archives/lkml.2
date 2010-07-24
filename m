Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab0GXPBX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 11:01:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:33453 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab0GXPBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 11:01:21 -0400
Date: Sat, 24 Jul 2010 08:05:51 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: torvalds@linux-foundation.org, dmitry.torokhov@gmail.com
Subject: Re: Input: twl40300-keypad - fix handling of "all ground" rows
Message-ID: <20100724080551.22893752@infradead.org>
In-Reply-To: <201007221959.o6MJx9VQ023618@hera.kernel.org>
References: <201007221959.o6MJx9VQ023618@hera.kernel.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jul 2010 19:59:09 GMT
Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:
> http://git.kernel.org/linus/3fea60261e73dbf4a51130d40cafcc8465b0f2c3
> Commit:     3fea60261e73dbf4a51130d40cafcc8465b0f2c3 Parent:
> c25f7b763cc35a249232ce612a36a811b0e263f9 Author:     Dmitry Torokhov
> <dmitry.torokhov@gmail.com> AuthorDate: Tue Jul 20 20:25:35 2010 -0700
> Committer:  Dmitry Torokhov <dmitry.torokhov@gmail.com>
> CommitDate: Tue Jul 20 20:29:48 2010 -0700
> 
>     Input: twl40300-keypad - fix handling of "all ground" rows
>     
>     The Nokia RX51 board code
> (arch/arm/mach-omap2/board-rx51-peripherals.c) defines a key map for
> the matrix keypad keyboard. The hardware seems to use all of the 8
> rows and 8 columns of the keypad, although not all possible locations
> are used. 



> +	KEY(4, 8, KEY_10),
> +
>  	KEY(5, 0, KEY_Y),
> +	KEY(5, 8, KEY_11),
>

This patch, as merged, is broken. Nowhere in the kernel are KEY_10 and
KEY_11 defined.... so this causes a compile failure.

Are you sure you didn't mean KEY_F10 / KEY_F11 ?


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
