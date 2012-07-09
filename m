Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab2GIWz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 18:55:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63542 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab2GIWz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 18:55:57 -0400
Date: Mon, 9 Jul 2012 15:55:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joe Perches <joe@perches.com>
cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
        apw@canonical.com
Subject: Re: + checkpatch-add-check-for-use-of-sizeof-without-parenthesis.patch
 added to -mm tree
In-Reply-To: <1341873376.6118.56.camel@joe2Laptop>
Message-ID: <alpine.DEB.2.00.1207091553120.3552@chino.kir.corp.google.com>
References: <20120709215256.9A4F71E0043@wpzn4.hot.corp.google.com> <alpine.DEB.2.00.1207091514310.32082@chino.kir.corp.google.com> <1341873376.6118.56.camel@joe2Laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2012, Joe Perches wrote:

> Huh?  Maybe I misunderstand you.
> 
> $ cat sizeof.c
> #include <stdio.h>
> #include <stdlib.h>
> #include <strings.h>
> 
> struct foo {
> 	int bar[20];
> 	char *baz;
> };
> 
> int main(int argc, char **argv)
> {
> 	struct foo bar;
> 	struct foo *baz;
> 
> 	printf("1: %zu\n", sizeof(struct foo));

Parenthesis are required for type names such as this and is normally 
written as "sizeof (struct foo)" in gcc, glibc, the C99 standard, etc., 
but the Linux coding style asks that no space is introduced.

> 	printf("2: %zu\n", sizeof bar);

This is a unary expression and no parenthesis are required either by the 
C99 standard nor the Linux coding style and there are over 1000 
occurrences where there are no parenthesis for unary operators currently 
in the kernel.

So, nack, don't start enforcing your own coding style and preferences in 
checkpatch.pl.
