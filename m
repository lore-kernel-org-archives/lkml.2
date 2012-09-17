Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab2IQVm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 17:42:59 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:50276 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab2IQVm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 17:42:58 -0400
Message-ID: <50579954.7030009@oracle.com>
Date: Mon, 17 Sep 2012 16:42:44 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120910 Thunderbird/15.0.1
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: yongjun_wei@trendmicro.com.cn, jfs-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] JFS: use list_move instead of list_del/list_add
References: <CAPgLHd-TqJzoPYcE8b=g=_v9fyc+7wtBJ3FtbWns_3Q1GUPm1Q@mail.gmail.com>
In-Reply-To: <CAPgLHd-TqJzoPYcE8b=g=_v9fyc+7wtBJ3FtbWns_3Q1GUPm1Q@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Meant to reply earlier. I've sent this to linux-next and will target for
the next mainline merge window.

Thanks,
Shaggy

On 09/06/2012 02:33 AM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Using list_move() instead of list_del() + list_add().
> 
> spatch with a semantic match is used to found this problem.
> (http://coccinelle.lip6.fr/)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  fs/jfs/jfs_txnmgr.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
> index bb8b661..5fcc02e 100644
> --- a/fs/jfs/jfs_txnmgr.c
> +++ b/fs/jfs/jfs_txnmgr.c
> @@ -2977,12 +2977,9 @@ int jfs_sync(void *arg)
>  				 * put back on the anon_list.
>  				 */
>  
> -				/* Take off anon_list */
> -				list_del(&jfs_ip->anon_inode_list);
> -
> -				/* Put on anon_list2 */
> -				list_add(&jfs_ip->anon_inode_list,
> -					 &TxAnchor.anon_list2);
> +				/* Move from anon_list to anon_list2 */
> +				list_move(&jfs_ip->anon_inode_list,
> +					  &TxAnchor.anon_list2);
>  
>  				TXN_UNLOCK();
>  				iput(ip);
> 
