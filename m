Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab1KUKcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:32:52 -0500
Received: from mga07.intel.com ([143.182.124.22]:24364 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754035Ab1KUKcv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:32:51 -0500
MIME-Version: 1.0
In-Reply-To: <4EC9EBD2.3040708@xenotime.net>
References: <20111121133936.ae0ecadbf39ae50da6b842d1@canb.auug.org.au>
	<4EC9EBD2.3040708@xenotime.net>
Date: Mon, 21 Nov 2011 12:32:48 +0200
Message-ID: <CALLzPKYmmah9EcXgN2ruRLoFSjV-ozn1pBMans=n2_ouB8Tqsg@mail.gmail.com>
Subject: Re: [PATCH -next] digsig: fix build errors
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 8:12 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>
> Fix build errors by adding kconfig dependency on KEYS:
>
> lib/digsig.c:106:16: error: dereferencing pointer to incomplete type
> lib/digsig.c:107:11: error: dereferencing pointer to incomplete type
> lib/digsig.c:184:14: error: dereferencing pointer to incomplete type
> lib/digsig.c:223:3: error: 'key_ref_t' undeclared (first use in this function)
> lib/digsig.c:223:13: error: expected ';' before 'kref'
> lib/digsig.c:224:3: error: 'kref' undeclared (first use in this function)
> lib/digsig.c:224:3: error: implicit declaration of function 'keyring_search'
> lib/digsig.c:231:3: error: implicit declaration of function 'request_key'
>
> and after changing lib/Kconfig:
> warning: (INTEGRITY_DIGSIG) selects DIGSIG which has unmet direct dependencies (CRYPTO && KEYS)
>
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> ---
>  lib/Kconfig                |    4 ++--
>  security/integrity/Kconfig |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> --- next-2011-1121.orig/lib/Kconfig
> +++ next-2011-1121/lib/Kconfig
> @@ -294,10 +294,10 @@ config MPILIB_EXTRA
>
>  config DIGSIG
>        tristate "In-kernel signature checker"
> -       depends on CRYPTO
> +       depends on CRYPTO && KEYS

this patch was in /crypto dir before, now it is in /lib...
I think CRYPTO is not needed at all at the moment..


>        select MPILIB
>        help
>          Digital signature verification. Currently only RSA is supported.
> -         Implementation is done using GnuPG MPI library
> +         Implementation is done using GnuPG MPI library.
>
>  endmenu
> --- next-2011-1121.orig/security/integrity/Kconfig
> +++ next-2011-1121/security/integrity/Kconfig
> @@ -5,7 +5,7 @@ config INTEGRITY
>
>  config INTEGRITY_DIGSIG
>        boolean "Digital signature verification using multiple keyrings"
> -       depends on INTEGRITY
> +       depends on INTEGRITY && CRYPTO && KEYS

Is it really needed, because 2 lines bellow is "select DIGSIG", which
will depend on KEYS??


>        default n
>        select DIGSIG
>        help
>

Thanks!
