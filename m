Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab3AGOdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 09:33:49 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:47066 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab3AGOds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 09:33:48 -0500
Message-ID: <50EADCC0.4070704@oracle.com>
Date: Mon, 07 Jan 2013 08:33:36 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
CC: linux-kernel@vger.kernel.org, jfs-discussion@lists.sourceforge.net
Subject: Re: [PATCH] jfs: avoid undefined behavior from left-shifting by 32
 bits
References: <1357413561-42508-1-git-send-email-nickolai@csail.mit.edu>
In-Reply-To: <1357413561-42508-1-git-send-email-nickolai@csail.mit.edu>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2013 01:19 PM, Nickolai Zeldovich wrote:
> Shifting a 32-bit int by 32 bits is undefined behavior in C, and
> results in different behavior on different architectures (e.g., x86
> and PowerPC).  diAlloc() in fs/jfs/jfs_imap.c computes a mask using
> 0xffffffffu<<(32-bitno), which can left-shift by 32 bits.  To avoid
> unexpected behavior, explicitly check for bitno==0 and use a 0 mask.

Thanks. Pushed to
git://github.com/kleikamp/linux-shaggy.git jfs-next

Shaggy

> 
> Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
> ---
>  fs/jfs/jfs_imap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/jfs/jfs_imap.c b/fs/jfs/jfs_imap.c
> index 6ba4006..f7e042b 100644
> --- a/fs/jfs/jfs_imap.c
> +++ b/fs/jfs/jfs_imap.c
> @@ -1493,7 +1493,7 @@ int diAlloc(struct inode *pip, bool dir, struct inode *ip)
>  		/* mask any prior bits for the starting words of the
>  		 * summary map.
>  		 */
> -		mask = ONES << (EXTSPERSUM - bitno);
> +		mask = (bitno == 0) ? 0 : (ONES << (EXTSPERSUM - bitno));
>  		inosmap = le32_to_cpu(iagp->inosmap[sword]) | mask;
>  		extsmap = le32_to_cpu(iagp->extsmap[sword]) | mask;
>  
> 
