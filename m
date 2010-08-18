Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab0HRGdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 02:33:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:50804 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728Ab0HRGc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 02:32:56 -0400
Message-ID: <4C6B7E92.6010408@kernel.org>
Date: Wed, 18 Aug 2010 08:32:50 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 5/5] dm: implement REQ_FLUSH/FUA support
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <1281977523-19335-6-git-send-email-tj@kernel.org> <20100816190203.GA22299@redhat.com> <4C6A5780.2090100@kernel.org> <20100817140734.GA30768@redhat.com> <4C6ABE12.40705@kernel.org> <20100817182130.GA31737@redhat.com>
In-Reply-To: <20100817182130.GA31737@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 18 Aug 2010 06:32:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/17/2010 08:21 PM, Mike Snitzer wrote:
> Why base your work on a partial 2.6.36 tree?  Why not rebase to linus'
> 2.6.36-rc1?

Because the block tree contains enough changes which are not in
mainline yet and bulk of the changes should go through the block tree.

> Once we get the changes in a more suitable state (across the entire
> tree) we can split the individual changes out to their respective
> trees.  Without a comprehensive tree I fear this code isn't going to get
> tested or reviewed properly.
> 
> For example: any review of DM changes, against stale DM code, is wasted
> effort.

Yeap, sure, it will happen all in a good time, but I don't really
agree that review against block tree would be complete waste of
effort.  Things usually don't change that drastically unless dm is
being rewritten as we speak.  Anyways, I'll soon post a rebased /
updated patch.

>> Oh, I was talking about the other way around.  Passing REQ_FUA in
>> bio->bi_rw down to member request_queues.  Sometimes while
>> constructing clone / split bios, the bit is lost (e.g. md raid5).
> 
> Seems we need to change __blk_rq_prep_clone to propagate REQ_FUA just
> like REQ_DISCARD: http://git.kernel.org/linus/3383977

Oooh, right.  I for some reason thought block layer was already doing
that.  I'll update it.  Thanks for pointing it out.

> Doesn't seem like we need to do the same for REQ_FLUSH (at least not for
> rq-based DM's benefit) because dm.c:setup_clone already special cases
> flush requests and sets REQ_FLUSH in cmd_flags.

Hmmm... but in general, I think it would be better to make
__blk_rq_prep_clone() to copy all command related bits.  If some
command bits shouldn't be copied, the caller should take care of them.

Thanks.

-- 
tejun
