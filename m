Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab2E1LmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 07:42:06 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:59483 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab2E1LmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 07:42:04 -0400
Message-ID: <4FC3645E.8040901@ce.jp.nec.com>
Date: Mon, 28 May 2012 20:41:18 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Kent Overstreet <koverstreet@google.com>
CC: device-mapper development <dm-devel@redhat.com>, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, tj@kernel.org,
        linux-bcache@vger.kernel.org, mpatocka@redhat.com, agk@redhat.com,
        bharrosh@panasas.com, linux-fsdevel@vger.kernel.org,
        yehuda@hq.newdream.net, drbd-dev@lists.linbit.com, vgoyal@redhat.com,
        sage@newdream.net
Subject: Re: [dm-devel] [PATCH v3 02/16] dm: Use bioset's front_pad for dm_rq_clone_bio_info
References: <1337977539-16977-1-git-send-email-koverstreet@google.com> <1337977539-16977-3-git-send-email-koverstreet@google.com> <4FC2CD93.1080009@ce.jp.nec.com>
In-Reply-To: <4FC2CD93.1080009@ce.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/12 09:57, Jun'ichi Nomura wrote:
> On 05/26/12 05:25, Kent Overstreet wrote:
>> -	pools->bs = bioset_create(pool_size, 0);
>> +	pools->bs = bioset_create(pool_size,
>> +				  offsetof(struct dm_rq_clone_bio_info, orig));
>>  	if (!pools->bs)
>>  		goto free_tio_pool_and_out;
> 
> Did you mean offset of *clone*?
> "offsetof(struct dm_rq_clone_bio_info, orig)" is zero.

Additional comment:
frontpad is not necessary if type is DM_TYPE_BIO_BASED.
Please check conditional switches done in the same function for
pools->tio_pool.

-- 
Jun'ichi Nomura, NEC Corporation
