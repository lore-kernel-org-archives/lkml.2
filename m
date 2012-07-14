Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab2GNUnm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 16:43:42 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60341 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751127Ab2GNUnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 16:43:37 -0400
Message-ID: <1342298616.8377.37.camel@joe2Laptop>
Subject: Re: [PATCH 2/3] x86/mm: Simplify for-loop in free_init_pages()
From: Joe Perches <joe@perches.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Tejun Heo <tj@kernel.org>
Date: Sat, 14 Jul 2012 13:43:36 -0700
In-Reply-To: <CAE9FiQUJNaRzBBF02RdSTQgAcMgJOLJDo7ukFaM_3RCa8NS-mA@mail.gmail.com>
References: <1342273267-2108-1-git-send-email-penberg@kernel.org>
	 <1342273267-2108-2-git-send-email-penberg@kernel.org>
	 <CAE9FiQUJNaRzBBF02RdSTQgAcMgJOLJDo7ukFaM_3RCa8NS-mA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-07-14 at 13:36 -0700, Yinghai Lu wrote:
> On Sat, Jul 14, 2012 at 6:41 AM, Pekka Enberg <penberg@kernel.org> wrote:
> > As a cleanup, move initial "addr" assignment to the for-loop construct
> > in free_init_pages().

Not really a good idea.

> > diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
[]
> > @@ -349,8 +349,6 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
> >         if (begin >= end)
> >                 return;
> >
> > -       addr = begin;
> > -
> >         /*
> >          * If debugging page accesses then do not free this memory but
> >          * mark them not present - any buggy init-section access will
> > @@ -371,7 +369,7 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
> >
> >         printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
> >
> > -       for (; addr < end; addr += PAGE_SIZE) {
> > +       for (addr = begin; addr < end; addr += PAGE_SIZE) {
> >                 ClearPageReserved(virt_to_page(addr));
> >                 init_page_count(virt_to_page(addr));
> >                 memset((void *)addr, POISON_FREE_INITMEM, PAGE_SIZE);
> > --

Now there's an unused variable warning when CONFIG_DEBUG_PAGEALLOC

