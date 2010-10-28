Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760993Ab0J1SSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:18:12 -0400
Received: from mx2.netapp.com ([216.240.18.37]:1706 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755321Ab0J1SSK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:18:10 -0400
X-IronPort-AV: E=Sophos;i="4.58,253,1286175600"; 
   d="scan'208";a="474375924"
Subject: Re: [PATCH] nfs4: The difference of 2 pointers is size_t
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Benny Halevy <bhalevy@panasas.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1010282004390.31018@ayla.of.borg>
References: <alpine.DEB.2.00.1010282004390.31018@ayla.of.borg>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Thu, 28 Oct 2010 14:17:14 -0400
Message-ID: <1288289834.14221.12.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
X-OriginalArrivalTime: 28 Oct 2010 18:17:54.0364 (UTC) FILETIME=[70893FC0:01CB76CC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-28 at 20:06 +0200, Geert Uytterhoeven wrote:
> On m68k, which is 32-bit:
> 
> fs/nfs/nfs4proc.c: In function ‘nfs41_sequence_done’:
> fs/nfs/nfs4proc.c:432: warning: format ‘%ld’ expects type ‘long int’, but argument 3 has type ‘int’
> fs/nfs/nfs4proc.c: In function ‘nfs4_setup_sequence’:
> fs/nfs/nfs4proc.c:576: warning: format ‘%ld’ expects type ‘long int’, but argument 5 has type ‘int’
> 
> On 32-bit, size_t is int; on 64-bit, size_t is long.
> 
> Introduced by commit dfb4f309830359352539919f23accc59a20a3758 ("NFSv4.1: keep
> seq_res.sr_slot as pointer rather than an index")
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  fs/nfs/nfs4proc.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
> index 32c8758..80229dc 100644
> --- a/fs/nfs/nfs4proc.c
> +++ b/fs/nfs/nfs4proc.c
> @@ -429,7 +429,7 @@ static int nfs41_sequence_done(struct rpc_task *task, struct nfs4_sequence_res *
>  		 * returned NFS4ERR_DELAY as per Section 2.10.6.2
>  		 * of RFC5661.
>  		 */
> -		dprintk("%s: slot=%ld seq=%d: Operation in progress\n",
> +		dprintk("%s: slot=%zd seq=%d: Operation in progress\n",
>  			__func__,
>  			res->sr_slot - res->sr_session->fc_slot_table.slots,
>  			res->sr_slot->seq_nr);
> @@ -573,7 +573,7 @@ int nfs4_setup_sequence(const struct nfs_server *server,
>  		goto out;
>  	}
>  
> -	dprintk("--> %s clp %p session %p sr_slot %ld\n",
> +	dprintk("--> %s clp %p session %p sr_slot %zd\n",
>  		__func__, session->clp, session, res->sr_slot ?
>  			res->sr_slot - session->fc_slot_table.slots : -1);
>  

Thanks! Applied.

Trond
