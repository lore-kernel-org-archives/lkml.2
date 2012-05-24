Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab2EXMa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 08:30:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:65316 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab2EXMa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 08:30:56 -0400
Message-ID: <4FBE29FB.9030405@tonian.com>
Date: Thu, 24 May 2012 15:30:51 +0300
From: Benny Halevy <bhalevy@tonian.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
CC: bfields@fieldses.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] NFSd: simplify locking in nfsd_recall_delegations()
References: <20120522102839.12440.14555.stgit@localhost.localdomain>
In-Reply-To: <20120522102839.12440.14555.stgit@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-22 13:28, Stanislav Kinsbursky wrote:
> Holding of client_mutex looks redundant here - holding of recall_lock looks
> enough.

Looking at the code, agreed.

Benny

> 
> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
> ---
>  fs/nfsd/nfs4state.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
> index f004e61..fdef9fc 100644
> --- a/fs/nfsd/nfs4state.c
> +++ b/fs/nfsd/nfs4state.c
> @@ -4744,11 +4744,9 @@ void nfsd_recall_delegations(u64 num)
>  {
>  	unsigned int count;
>  
> -	nfs4_lock_state();
>  	spin_lock(&recall_lock);
>  	count = nfsd_process_n_delegations(num, nfsd_break_one_deleg, NULL);
>  	spin_unlock(&recall_lock);
> -	nfs4_unlock_state();
>  
>  	printk(KERN_INFO "NFSD: Recalled %d delegations", count);
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
