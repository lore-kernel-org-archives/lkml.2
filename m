Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab1AVBbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 20:31:19 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:64929 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab1AVBbR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 20:31:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AcNJOiSRL7+uGLWRR3XlxIQ9R7hplk2hcDNn0h1K3nfr/C4alp2vVE1CO3VwVZMdEJ
         QmXjG0m1uUs3tMBRh9yuUL+tJkxkTUEdswvSsxWyRDUDPf7+9kMf7ZDYiTeu/alxf8lY
         JAPAIu/tCdsRn9Ql3YT3stvNaE/aKLXJLRMbs=
MIME-Version: 1.0
In-Reply-To: <1295659049-2688-6-git-send-email-jaxboe@fusionio.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
	<1295659049-2688-6-git-send-email-jaxboe@fusionio.com>
Date: Sat, 22 Jan 2011 12:31:16 +1100
Message-ID: <AANLkTimqx7FT9FTgzw7Ca_96dnTX4Jh47DtFKhfhcKsR@mail.gmail.com>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
From: Nick Piggin <npiggin@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 22, 2011 at 12:17 PM, Jens Axboe <jaxboe@fusionio.com> wrote:

> -/**
> - * __lock_page_nosync - get a lock on the page, without calling sync_page()
> - * @page: the page to lock
> - *
> - * Variant of lock_page that does not require the caller to hold a reference
> - * on the page's mapping.
> - */
> -void __lock_page_nosync(struct page *page)
> -{
> -       DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
> -       __wait_on_bit_lock(page_waitqueue(page), &wait, __sleep_on_page_lock,
> -                                                       TASK_UNINTERRUPTIBLE);
> -}

RIP to this guy, won't be missed :)

Nice work.
