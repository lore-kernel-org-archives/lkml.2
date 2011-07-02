Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab1GBQjK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 12:39:10 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60348 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab1GBQjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 12:39:09 -0400
MIME-Version: 1.0
In-Reply-To: <1309622006-28343-1-git-send-email-jonas@southpole.se>
References: <1309622006-28343-1-git-send-email-jonas@southpole.se>
From: Mike Frysinger <vapier@gentoo.org>
Date: Sat, 2 Jul 2011 12:38:48 -0400
X-Google-Sender-Auth: wH9otxo-hrgcYAkNuPQ9xPQnVKA
Message-ID: <CAMjpGUfZwZu-ZCJj2cmq1w6B71-gQ8G27FpYdhseyq3hoZRL+Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] asm-generic: add MMU variants of io.h functions
To: Jonas Bonn <jonas@southpole.se>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        liqin.chen@sunplusct.com, gxt@mprc.pku.edu.cn
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 2, 2011 at 11:53, Jonas Bonn wrote:
> Some of the implementations, in particular the ioremap variants, in
> asm-generic/io.h are for systems with an MMU.

do you mean "without an MMU" ?

> +#ifdef CONFIG_MMU
> +#define xlate_dev_mem_ptr(p)   __va(p)
> +#else
>  #define xlate_dev_mem_ptr(p)   ((void *) (p))
> +#endif

i wonder if we could do:
#ifndef __va
#define __va(p) ((void *)(p))
#endif
#define xlate_dev_mem_ptr(p)   __va(p)
-mike
