Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab2EGNUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 09:20:38 -0400
Received: from mga06.intel.com ([134.134.136.21]:4669 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755710Ab2EGNUh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 09:20:37 -0400
MIME-Version: 1.0
In-Reply-To: <1336182667-9784-1-git-send-email-root@hackmaster.in>
References: <1336182667-9784-1-git-send-email-root@hackmaster.in>
Date: Mon, 7 May 2012 16:20:35 +0300
Message-ID: <CALLzPKbA=x0Tu2Gat2Ppx9e=u7iy_M_x5Gczr+=hjL-PgOwNYg@mail.gmail.com>
Subject: Re: [PATCH 1/1] lib/mpi: Fixed erroneous check on return value of mpi_resize()
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Adarsh J <root@hackmaster.in>
Cc: James Morris <jmorris@namei.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Mimi Zohar <zohar@us.ibm.com>, David Howells <dhowells@redhat.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 5, 2012 at 4:51 AM, Adarsh J <root@hackmaster.in> wrote:
> mpi_resize() returns -ENOMEM on error and 0 on success.
>
> Signed-off-by: Adarsh J <root@hackmaster.in>

Acked-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>

Thanks.

> ---
>  lib/mpi/mpicoder.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
> index f26b41f..9949b69 100644
> --- a/lib/mpi/mpicoder.c
> +++ b/lib/mpi/mpicoder.c
> @@ -98,7 +98,7 @@ int mpi_fromstr(MPI val, const char *str)
>        nbytes = (nbits + 7) / 8;
>        nlimbs = (nbytes + BYTES_PER_MPI_LIMB - 1) / BYTES_PER_MPI_LIMB;
>        if (val->alloced < nlimbs)
> -               if (!mpi_resize(val, nlimbs))
> +               if (mpi_resize(val, nlimbs) < 0)
>                        return -ENOMEM;
>        i = BYTES_PER_MPI_LIMB - nbytes % BYTES_PER_MPI_LIMB;
>        i %= BYTES_PER_MPI_LIMB;
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
