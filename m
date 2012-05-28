Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab2E1A7U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 20:59:20 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:64124 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab2E1A7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 20:59:17 -0400
Message-ID: <4FC2CD93.1080009@ce.jp.nec.com>
Date: Mon, 28 May 2012 09:57:55 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Kent Overstreet <koverstreet@google.com>
CC: device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk, yehuda@hq.newdream.net,
        mpatocka@redhat.com, vgoyal@redhat.com, bharrosh@panasas.com,
        tj@kernel.org, sage@newdream.net, agk@redhat.com,
        drbd-dev@lists.linbit.com
Subject: Re: [dm-devel] [PATCH v3 02/16] dm: Use bioset's front_pad for dm_rq_clone_bio_info
References: <1337977539-16977-1-git-send-email-koverstreet@google.com> <1337977539-16977-3-git-send-email-koverstreet@google.com>
In-Reply-To: <1337977539-16977-3-git-send-email-koverstreet@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/12 05:25, Kent Overstreet wrote:
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

Did you mean offset of *clone*?
"offsetof(struct dm_rq_clone_bio_info, orig)" is zero.

And now _rq_bio_info_cache has no user and can be removed.

Otherwise, I think it's nicer than the previous version.
Thank you.
-- 
Jun'ichi Nomura, NEC Corporation
