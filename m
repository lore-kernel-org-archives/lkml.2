Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab2DUXst (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 19:48:49 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:55876 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab2DUXss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 19:48:48 -0400
MIME-Version: 1.0
In-Reply-To: <1335015755-2881-1-git-send-email-rajman.mekaco@gmail.com>
References: <1335015755-2881-1-git-send-email-rajman.mekaco@gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Sat, 21 Apr 2012 19:48:27 -0400
X-Google-Sender-Auth: gcviDwhofK2l33wQLPdhAkR5_n4
Message-ID: <CAHGf_=ovyXxNwc8o=MjL9-6eReCA2UzDvLeLMqEHVPxiLiKOPQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] mmap.c: find_vma: remove unnecessary if(mm) check
To: Rajman Mekaco <rajman.mekaco@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Kautuk Consul <consul.kautuk@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 9:42 AM, Rajman Mekaco <rajman.mekaco@gmail.com> wrote:
> The if(mm) check is not required in find_vma, as the kernel
> code calls find_vma only when it is absolutely sure that the
> mm_struct arg to it is non-NULL.
>
> Removing the if(mm) check and adding the a WARN_ONCE(!mm)
> for now.
> This will serve the purpose of mandating that the execution
> context(user-mode/kernel-mode) be known before find_vma is called.
> Also fixed 2 checkpatch.pl errors in the declaration
> of the rb_node and vma_tmp local variables.
>
> I was browsing through the internet and read a discussion
> at https://lkml.org/lkml/2012/3/27/342 which discusses removal
> of the validation check within find_vma.
> Since no-one responded, I decided to send this patch with Andrew's
> suggestions.
>
> Signed-off-by: Rajman Mekaco <rajman.mekaco@gmail.com>
> Cc: Kautuk Consul <consul.kautuk@gmail.com>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
