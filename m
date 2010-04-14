Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab0DNXGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 19:06:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756198Ab0DNXGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 19:06:44 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/4] cfq-iosched: Keep track of average think time for the sync-noidle workload.
References: <1271279826-30294-1-git-send-email-jmoyer@redhat.com>
	<1271279826-30294-2-git-send-email-jmoyer@redhat.com>
	<20100414213745.GC3167@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 14 Apr 2010 19:06:38 -0400
In-Reply-To: <20100414213745.GC3167@redhat.com> (Vivek Goyal's message of
	"Wed, 14 Apr 2010 17:37:45 -0400")
Message-ID: <x49zl15k51d.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Wed, Apr 14, 2010 at 05:17:03PM -0400, Jeff Moyer wrote:

>> @@ -3678,11 +3710,14 @@ static void *cfq_init_queue(struct request_queue *q)
>>  
>>  	/* Init root service tree */
>>  	cfqd->grp_service_tree = CFQ_RB_ROOT;
>> +	cfqd->grp_service_tree.last_end_request = jiffies;
>>  
>
> This assignment is not required as we never update think time analsys of
> service tree where all the groups are hanging.  So for grp_service_tree,
> last_end_request can be zero and there will be no harm.

OK, thanks.

> Otherwise patch looks good to me. Can you please run some simple blkio
> cgroup tests to make sure that functionality is not broken.

Yes, I'll add that to my list and get back to you.

Thanks for the review, Vivek.

Cheers,
Jeff
