Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab2FKI1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 04:27:35 -0400
Received: from mga07.intel.com ([143.182.124.22]:23284 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751048Ab2FKI1d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 04:27:33 -0400
MIME-Version: 1.0
In-Reply-To: <1339169631.30984.2.camel@x61.thuisdomein>
References: <1339169631.30984.2.camel@x61.thuisdomein>
Date: Mon, 11 Jun 2012 11:27:32 +0300
Message-ID: <CALLzPKak-GLPehY84_h-wURdrfnOW1nNeML_hpwdJi7mf-XkcQ@mail.gmail.com>
Subject: Re: [PATCH] Remove lib/mpi/generic_mpi-asm-defs.h
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Indeed like that...
That patch has been already reverted and unused code removed.
Changes are available in the #next-queue branch of Linux security tree.

Thanks!

- Dmitry

On Fri, Jun 8, 2012 at 6:33 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> This header got added by commit 7e8dec918ef8e0f68b4937c3c50fa57002077a4d
> ("crypto: GnuPG based MPI lib - additional sources (part 4)"). Nothing
> includes it.
>
> The sole named constant it defines is BYTES_PER_MPI_LIMB. That named
> constant is already provided by <linux/mpi.h> (which is made available
> to the files in lib/mpi via mpi-internal.h). In this header that define
> depends on the undefined macro SIZEOF_UNSIGNED_LONG.
>
> So this header is unused, unneeded and broken. It can safely be removed.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> This patch is, once again, tested only with "git grep".
>
>  lib/mpi/generic_mpi-asm-defs.h |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
>  delete mode 100644 lib/mpi/generic_mpi-asm-defs.h
>
> diff --git a/lib/mpi/generic_mpi-asm-defs.h b/lib/mpi/generic_mpi-asm-defs.h
> deleted file mode 100644
> index 047d1f5..0000000
> --- a/lib/mpi/generic_mpi-asm-defs.h
> +++ /dev/null
> @@ -1,4 +0,0 @@
> -/* This file defines some basic constants for the MPI machinery.  We
> - * need to define the types on a per-CPU basis, so it is done with
> - * this file here.  */
> -#define BYTES_PER_MPI_LIMB  (SIZEOF_UNSIGNED_LONG)
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
