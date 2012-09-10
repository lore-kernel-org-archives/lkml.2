Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab2IJGT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 02:19:26 -0400
Received: from ares07.inai.de ([5.9.24.206]:54854 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014Ab2IJGTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 02:19:23 -0400
Date: Mon, 10 Sep 2012 08:19:21 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: "J. Bruce Fields" <bfields@fieldses.org>
cc: linux-kernel@vger.kernel.org, Jim Rees <rees@umich.edu>
Subject: Re: [PATCH] strings: helper for maximum decimal encoding of an
 unsigned integer
In-Reply-To: <20120821212910.GD18637@fieldses.org>
Message-ID: <alpine.LNX.2.01.1209100803060.22738@frira.zrqbmnf.qr>
References: <20120821212910.GD18637@fieldses.org>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 2012-08-21 23:29, J. Bruce Fields wrote:

>I've seen a couple examples recently where we've gotten this wrong.
>Maybe something like this would help?  Is there some better way?
>(Approximation due to Jim Rees).
>
>+/*
>+ * length of the decimal representation of an unsigned integer.  Just an
>+ * approximation, but it's right for types of size 1 to 36 bytes:
>+ */
>+#define base10len(i) (sizeof(i) * 24 / 10 + 1)


gcc provides... "interesting" features at times.

/* for unsigned "i"s */
#define base10len(i) ((const int[]){1,3,5,8,10,13,15,17,20}[i])

But enumerating it (using your ULONG_MAX_STR proposal) should be 
sufficient, since there is only a limited number of types that get e.g. 
sprintf'ed into a buffer.


Something else tho, it seems some don't know that sizeof("") is already 
1, and an extra \0 is often unneeded, like in:

arch/um/drivers/net_user.c:  char addr_buf[sizeof("255.255.255.255\0")];
