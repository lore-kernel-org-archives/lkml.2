Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab1HWP0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 11:26:46 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45624 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab1HWP0m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 11:26:42 -0400
MIME-Version: 1.0
In-Reply-To: <20110822134348.a57db0e1.akpm@linux-foundation.org>
References: <1314030548-21082-1-git-send-email-akinobu.mita@gmail.com>
	<1314030548-21082-3-git-send-email-akinobu.mita@gmail.com>
	<20110822134348.a57db0e1.akpm@linux-foundation.org>
Date: Wed, 24 Aug 2011 00:26:41 +0900
Message-ID: <CAC5umygVhjAAH-o_KGp+hkHeqfGpX9J+GP8aS68H_=GSLEdNWg@mail.gmail.com>
Subject: Re: [PATCH 2/4] debug-pagealloc: add support for highmem pages
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/23 Andrew Morton <akpm@linux-foundation.org>:

> This seems more complicated than is needed.  Couldn't we just do
>
> static void poison_page(struct page *page)
> {
>        void *addr;
>
>        preempt_disable();
>        addr = kmap_atomic(page);
>        set_page_poison(page);
>        memset(addr, PAGE_POISON, PAGE_SIZE);
>        kunmap_atomic(addr);
>        preempt_enable();
> }
>
> ?

This code looks much better.  I'll update the patch.
