Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab2L1INJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 03:13:09 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:38346 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab2L1INI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 03:13:08 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWekAOMedzr8Pj3d2O1g3KrN_Fd4F_D4SGz=gOTBZF8sA@mail.gmail.com>
References: <20121227185126.GA10207@x1.alien8.de>
	<CAE9FiQWekAOMedzr8Pj3d2O1g3KrN_Fd4F_D4SGz=gOTBZF8sA@mail.gmail.com>
Date: Fri, 28 Dec 2012 00:13:06 -0800
X-Google-Sender-Auth: C4brWcGOQf3M8rJYMuF_DI5Fj4Q
Message-ID: <CAE9FiQXgDGBsCHPC2m4mDx4JxgKu5tJ0ABMY2jch-1=JUdnm4w@mail.gmail.com>
Subject: Re: [PATCH] x86, mm: add generic kernel/ident mapping helper
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 4:34 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Thu, Dec 27, 2012 at 10:51 AM, Borislav Petkov <bp@alien8.de> wrote:
>>> +struct mapping_info {
>>> +     void *(*alloc)(void *);
>>
>>                 alloc_page
>
> alloc_page make me feel that it will return struct page *.

also will get error

arch/x86/mm/init_64.c: In function ‘ident_pud_init’:
arch/x86/mm/init_64.c:88:22: error: ‘struct mapping_info’ has no
member named ‘alloc_pages’
arch/x86/mm/init_64.c: In function ‘kernel_ident_mapping_init’:
arch/x86/mm/init_64.c:121:22: error: ‘struct mapping_info’ has no
member named ‘alloc_pages’

because include/linux/gfp.h has

#define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)

so will stay with alloc.

Yinghai
