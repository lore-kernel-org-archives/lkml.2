Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab2IFDWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 23:22:10 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:60584 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab2IFDVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 23:21:48 -0400
Message-ID: <504816AB.8080105@ce.jp.nec.com>
Date: Thu, 06 Sep 2012 12:21:15 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>,
        Kent Overstreet <koverstreet@google.com>
CC: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org,
        Alasdair Kergon <agk@redhat.com>, vgoyal@redhat.com
Subject: Re: [dm-devel] [PATCH v8 3/8] dm: Use bioset's front_pad for dm_rq_clone_bio_info
References: <1346876849-15820-1-git-send-email-koverstreet@google.com> <1346876849-15820-4-git-send-email-koverstreet@google.com>
In-Reply-To: <1346876849-15820-4-git-send-email-koverstreet@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/12 05:27, Kent Overstreet wrote:
> @@ -2718,7 +2705,8 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity)
>  	if (!pools->tio_pool)
>  		goto free_io_pool_and_out;
>  
> -	pools->bs = bioset_create(pool_size, 0);
> +	pools->bs = bioset_create(pool_size,
> +				  offsetof(struct dm_rq_clone_bio_info, clone));
>  	if (!pools->bs)
>  		goto free_tio_pool_and_out;

frontpad is not necessary if type is DM_TYPE_BIO_BASED.

Other pool creation in that function do something like:
	pools->bs = (type == DM_TYPE_BIO_BASED) ?
		    bioset_create(pool_size, 0) :
		    bioset_create(pool_size, offsetof(struct dm_rq_clone_bio_info, clone));

-- 
Jun'ichi Nomura, NEC Corporation

