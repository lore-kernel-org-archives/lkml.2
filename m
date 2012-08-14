Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab2HNFhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 01:37:40 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:43904 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab2HNFhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 01:37:38 -0400
Message-ID: <5029E320.3050603@ce.jp.nec.com>
Date: Tue, 14 Aug 2012 14:33:20 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Kent Overstreet <koverstreet@google.com>
CC: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, axboe@kernel.dk, agk@redhat.com,
        neilb@suse.de, drbd-dev@lists.linbit.com, vgoyal@redhat.com,
        mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v5 02/12] dm: Use bioset's front_pad for dm_rq_clone_bio_info
References: <1344290921-25154-1-git-send-email-koverstreet@google.com> <1344290921-25154-3-git-send-email-koverstreet@google.com>
In-Reply-To: <1344290921-25154-3-git-send-email-koverstreet@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/12 07:08, Kent Overstreet wrote:
>  struct dm_rq_clone_bio_info {
>  	struct bio *orig;
>  	struct dm_rq_target_io *tio;
> +	struct bio clone;
>  };
...
> -	pools->bs = bioset_create(pool_size, 0);
> +	pools->bs = bioset_create(pool_size,
> +				  offsetof(struct dm_rq_clone_bio_info, orig));
>  	if (!pools->bs)
>  		goto free_tio_pool_and_out;

Shouldn't this be offsetof(struct dm_rq_clone_bio_info, clone)?

-- 
Jun'ichi Nomura, NEC Corporation
