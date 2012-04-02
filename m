Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab2DBCIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 22:08:22 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56700 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab2DBCIV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 22:08:21 -0400
MIME-Version: 1.0
In-Reply-To: <1333195133-4944-1-git-send-email-consul.kautuk@gmail.com>
References: <1333195133-4944-1-git-send-email-consul.kautuk@gmail.com>
Date: Sun, 1 Apr 2012 19:08:20 -0700
Message-ID: <CAF8ieYX0h2zaJN7ns345uXwZWoa3hzEZAJ331eJOTX4_pj-ZdQ@mail.gmail.com>
Subject: Re: [PATCH 01/19 v2] avr32/mm/fault.c: Port OOM changes to do_page_fault
From: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-kernel@vger.kernel.org, "Mohd. Faris" <mohdfarisq2010@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 4:58 AM, Kautuk Consul <consul.kautuk@gmail.com> wrote:
> Commit d065bd810b6deb67d4897a14bfe21f8eb526ba99
> (mm: retry page fault when blocking on disk transfer) and
> commit 37b23e0525d393d48a7d59f870b3bc061a30ccdb
> (x86,mm: make pagefault killable)
>
> The above commits introduced changes into the x86 pagefault handler
> for making the page fault handler retryable as well as killable.
>
> These changes reduce the mmap_sem hold time, which is crucial
> during OOM killer invocation.
>
> Port these changes to AVR32.
>
> Signed-off-by: Mohd. Faris <mohdfarisq2010@gmail.com>
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>

Looks very good, thanks.

> @@ -122,6 +124,7 @@ good_area:
>                if (!(vma->vm_flags & VM_WRITE))
>                        goto bad_area;
>                writeaccess = 1;
> +               flags |= FAULT_FLAG_WRITE;

Could you remove the 'writeaccess' variable as well? It looks unused
after applying your patch.

Ug...the avr32 arch is in a terrible state. Someone appears to have
removed the atmel_nand driver...

Havard
