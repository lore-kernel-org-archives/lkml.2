Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab0LMP6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:58:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab0LMP6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:58:16 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aio: check return value of create_workqueue()
References: <1292252785-3683-1-git-send-email-namhyung@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 13 Dec 2010 10:58:08 -0500
In-Reply-To: <1292252785-3683-1-git-send-email-namhyung@gmail.com> (Namhyung
	Kim's message of "Tue, 14 Dec 2010 00:06:25 +0900")
Message-ID: <x4962uxd5rj.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim <namhyung@gmail.com> writes:

> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  fs/aio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/aio.c b/fs/aio.c
> index 8c8f6c5b6d79..c56153f5f73e 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -87,7 +87,7 @@ static int __init aio_setup(void)
>  
>  	aio_wq = create_workqueue("aio");
>  	abe_pool = mempool_create_kmalloc_pool(1, sizeof(struct aio_batch_entry));
> -	BUG_ON(!abe_pool);
> +	BUG_ON(!aio_wq || !abe_pool);
>  
>  	pr_debug("aio_setup: sizeof(struct page) = %d\n", (int)sizeof(struct page));

Acked-by: Jeff Moyer <jmoyer@redhat.com>
