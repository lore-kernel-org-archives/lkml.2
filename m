Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759189Ab2EEDav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 23:30:51 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50805 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab2EEDat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 23:30:49 -0400
X-Nat-Received: from [202.181.97.72]:57958 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1336188633.2527
To: root@hackmaster.in
Cc: dmitry.kasatkin@intel.com, jmorris@namei.org, zohar@us.ibm.com,
        dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] lib/mpi: Fixed erroneous check on return value of mpi_resize()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1336182667-9784-1-git-send-email-root@hackmaster.in>
In-Reply-To: <1336182667-9784-1-git-send-email-root@hackmaster.in>
Message-Id: <201205051230.GCC69709.OQFLSOVtMHJFFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 5 May 2012 12:30:32 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 05052012 #7890344, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adarsh J wrote:
> mpi_resize() returns -ENOMEM on error and 0 on success.

Good catch.

But it seems to me that mpi_fromstr() has no in-tree users.
Also, mpi_fromstr() in RHEL 5.8/6.2 has no users.
We forgot to exclude when adding MPI support?

> 
> Signed-off-by: Adarsh J <root@hackmaster.in>
> ---
>  lib/mpi/mpicoder.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
> index f26b41f..9949b69 100644
> --- a/lib/mpi/mpicoder.c
> +++ b/lib/mpi/mpicoder.c
> @@ -98,7 +98,7 @@ int mpi_fromstr(MPI val, const char *str)
>  	nbytes = (nbits + 7) / 8;
>  	nlimbs = (nbytes + BYTES_PER_MPI_LIMB - 1) / BYTES_PER_MPI_LIMB;
>  	if (val->alloced < nlimbs)
> -		if (!mpi_resize(val, nlimbs))
> +		if (mpi_resize(val, nlimbs) < 0)
>  			return -ENOMEM;
>  	i = BYTES_PER_MPI_LIMB - nbytes % BYTES_PER_MPI_LIMB;
>  	i %= BYTES_PER_MPI_LIMB;
> -- 
> 1.7.9.5
