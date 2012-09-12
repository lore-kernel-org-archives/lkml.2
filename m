Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab2ILXM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:12:28 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53716 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab2ILXM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:12:26 -0400
MIME-Version: 1.0
X-Originating-IP: [121.44.88.132]
In-Reply-To: <20120912185824.GS7677@google.com>
References: <3029802.oqG0dEY71l@fat-tyre>
	<20120905084915.GF3195@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120905100724.GA27527@soda.linbit>
	<20120906212952.GP29092@google.com>
	<20120907084221.GD7028@soda.linbit>
	<20120910225442.GE7677@google.com>
	<20120910230654.GF7677@google.com>
	<20120910233159.GE19739@google.com>
	<20120911155820.74f1f918@notabene.brown>
	<20120911082501.GH7028@soda.linbit>
	<20120912185824.GS7677@google.com>
Date: Thu, 13 Sep 2012 09:12:25 +1000
Message-ID: <CAOzFzEjCf7ZPbheq-tfhts-E=Ep1kvn0muksaaTFqJ=cMm772w@mail.gmail.com>
Subject: Re: [Drbd-dev] FLUSH/FUA documentation & code discrepancy
From: Joseph Glanville <joseph.glanville@orionvm.com.au>
To: Tejun Heo <tj@kernel.org>
Cc: NeilBrown <neilb@suse.de>, Kent Overstreet <koverstreet@google.com>,
        Jens Axboe <axboe@kernel.dk>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Vivek Goyal <vgoyal@redhat.com>, drbd-dev@lists.linbit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 September 2012 04:58, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Tue, Sep 11, 2012 at 10:25:01AM +0200, Lars Ellenberg wrote:
>> Or do we have a better place to document write ordering requirements?
>>
>> "To enforce write-after-write dependencies, you *have* to drain the
>> queue (do we have a generic interface available for that?),
>> or at least wait for the completion of all the requests you
>> (potentially) depend upon, before even submitting the dependent request.
>>
>> Additionally, to avoid integrity issues due to volatile caches,
>> you need to use FLUSH/FUA as appropriate."
>
> I think it would be best to note the lack of any ordering guarantee in
> the comment of bio_submit()?  Any one interested in submitting a
> patch?
>
> Thanks.
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Something along the lines of this?

diff --git a/block/blk-core.c b/block/blk-core.c
index 4b4dbdf..68b5671 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1809,6 +1809,9 @@ EXPORT_SYMBOL(generic_make_request);
  * uses that function to do most of the work. Both are fairly rough
  * interfaces; @bio must be presetup and ready for I/O.
  *
+ * Ordering of requests is not guaranteed, callers should drain the queue
+ * and issue a flush before submission of any dependent bios.
+ *
  */
 void submit_bio(int rw, struct bio *bio)
 {

-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
