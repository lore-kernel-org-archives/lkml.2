Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab0FNVGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:06:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756431Ab0FNVGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:06:11 -0400
Message-ID: <4C1699AA.3000900@gmail.com>
Date: Mon, 14 Jun 2010 23:05:46 +0200
From: Edward Shishkin <edward.shishkin@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
       linux-bluetooth@vger.kernel.org, clemens@ladisch.de,
       debora@linux.vnet.ibm.com, dri-devel@lists.freedesktop.org,
       linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 1/8]reiserfs:stree.c Fix variable set but not used.
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com> <1276547208-26569-2-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1276547208-26569-2-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock wrote:
> Not sure if this is correct or not.
> the below patch gets rid of this warning message
> produced by gcc 4.6.0
>
> fs/reiserfs/stree.c: In function 'search_by_key':
> fs/reiserfs/stree.c:602:6: warning: variable 'right_neighbor_of_leaf_node' set but not used
>
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>   

Acked-by: Edward Shishkin <edward.shishkin@gmail.com>

> ---
>  fs/reiserfs/stree.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
> index 313d39d..73086ad 100644
> --- a/fs/reiserfs/stree.c
> +++ b/fs/reiserfs/stree.c
> @@ -599,7 +599,6 @@ int search_by_key(struct super_block *sb, const struct cpu_key *key,	/* Key to s
>  	struct buffer_head *bh;
>  	struct path_element *last_element;
>  	int node_level, retval;
> -	int right_neighbor_of_leaf_node;
>  	int fs_gen;
>  	struct buffer_head *reada_bh[SEARCH_BY_KEY_READA];
>  	b_blocknr_t reada_blocks[SEARCH_BY_KEY_READA];
> @@ -617,8 +616,7 @@ int search_by_key(struct super_block *sb, const struct cpu_key *key,	/* Key to s
>  
>  	pathrelse(search_path);
>  
> -	right_neighbor_of_leaf_node = 0;
> -
> +	
>  	/* With each iteration of this loop we search through the items in the
>  	   current node, and calculate the next current node(next path element)
>  	   for the next iteration of this loop.. */
> @@ -695,8 +693,7 @@ int search_by_key(struct super_block *sb, const struct cpu_key *key,	/* Key to s
>  			   starting from the root. */
>  			block_number = SB_ROOT_BLOCK(sb);
>  			expected_level = -1;
> -			right_neighbor_of_leaf_node = 0;
> -
> +			
>  			/* repeat search from the root */
>  			continue;
>  		}
>   

