Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab0KRFkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 00:40:41 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:33948 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab0KRFkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 00:40:39 -0500
Message-ID: <4CE4BC49.10105@oracle.com>
Date: Thu, 18 Nov 2010 13:40:25 +0800
From: Tao Ma <tao.ma@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Milton Miller <miltonm@bga.com>
CC: Joel Becker <joel.becker@oracle.com>, ocfs2-devel@oss.oracle.com,
        Mark Fasheh <mfasheh@suse.com>, linux-kernel@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: ocfs2: char is not always signed
References: <1290054011_17741@mail4.comsite.net>
In-Reply-To: <1290054011_17741@mail4.comsite.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



2010-11-18 12:20, Milton Miller wrote:
> Commit 1c66b360fe262 (Change some lock status member in ocfs2_lock_res
> to char.)  states that these fields need to be signed due to comparision
> to -1, but only changed the type from unsigned char to char.   However, it
> is a compiler option if char is a signed or unsigned type.  Change these
> fields to signed char so the code will work with all compilers.
>
> Signed-off-by: Milton Miller<miltonm@bga.com>
oh, sorry I don't know this. Thanks.
Acked-by: Tao Ma <tao.ma@oracle.com>
> ---
> I did not look for other fields that might be char.  PowerPC compilers
> default to unsigned char, and aparently arm does as well from a quick
> google search, to name two examples.
>
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 1efea36..70dd3b1 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -159,9 +159,9 @@ struct ocfs2_lock_res {
>   	char                     l_name[OCFS2_LOCK_ID_MAX_LEN];
>   	unsigned int             l_ro_holders;
>   	unsigned int             l_ex_holders;
> -	char			 l_level;
> -	char			 l_requested;
> -	char			 l_blocking;
> +	signed char		 l_level;
> +	signed char		 l_requested;
> +	signed char		 l_blocking;
>
>   	/* Data packed - type enum ocfs2_lock_type */
>   	unsigned char            l_type;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
