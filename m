Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab2ARKiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 05:38:25 -0500
Received: from mga05.intel.com ([192.55.52.89]:37292 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752719Ab2ARKiX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 05:38:23 -0500
MIME-Version: 1.0
In-Reply-To: <20120118100354.20549.9321.stgit@warthog.procyon.org.uk>
References: <20120118100354.20549.9321.stgit@warthog.procyon.org.uk>
Date: Wed, 18 Jan 2012 12:38:22 +0200
Message-ID: <CALLzPKb1Vw+03rJEfrcYjf2zkRHkchup1=ht05bzna99L6NxQQ@mail.gmail.com>
Subject: Re: [PATCH] MPILIB: Add a missing ENOMEM check
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: David Howells <dhowells@redhat.com>
Cc: jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@kernel.org, Mimi Zohar <zohar@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 12:03 PM, David Howells <dhowells@redhat.com> wrote:
> Add a missing ENOMEM check.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Mimi Zohar <zohar@us.ibm.com>

Thanks.

> ---
>
>  lib/mpi/mpicoder.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
> index fe84bb9..716802b 100644
> --- a/lib/mpi/mpicoder.c
> +++ b/lib/mpi/mpicoder.c
> @@ -255,6 +255,8 @@ void *mpi_get_buffer(MPI a, unsigned *nbytes, int *sign)
>        if (!n)
>                n++;            /* avoid zero length allocation */
>        p = buffer = kmalloc(n, GFP_KERNEL);
> +       if (!p)
> +               return NULL;
>
>        for (i = a->nlimbs - 1; i >= 0; i--) {
>                alimb = a->d[i];
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
