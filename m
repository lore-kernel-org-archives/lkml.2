Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab0HWOMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 10:12:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:59855 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab0HWOMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 10:12:46 -0400
Message-ID: <4C728210.6040605@kernel.org>
Date: Mon, 23 Aug 2010 16:13:36 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Jens Axboe <jaxboe@fusionio.com>, Ric Wheeler <rwheeler@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "James.Bottomley@suse.de" <James.Bottomley@suse.de>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "chris.mason@oracle.com" <chris.mason@oracle.com>,
        "swhiteho@redhat.com" <swhiteho@redhat.com>,
        "konishi.ryusuke@lab.ntt.co.jp" <konishi.ryusuke@lab.ntt.co.jp>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "vst@vlnb.net" <vst@vlnb.net>, "jack@suse.cz" <jack@suse.cz>,
        "hare@suse.de" <hare@suse.de>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100820132214.GA6184@lst.de> <4C6E9CAF.5010202@redhat.com> <4C7269E9.9070304@kernel.org> <20100823124815.GA20095@lst.de> <4C727E96.5020801@redhat.com> <4C727F2B.6060501@fusionio.com> <20100823140823.GA23490@lst.de>
In-Reply-To: <20100823140823.GA23490@lst.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 23 Aug 2010 14:12:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/23/2010 04:08 PM, Christoph Hellwig wrote:
> On Mon, Aug 23, 2010 at 04:01:15PM +0200, Jens Axboe wrote:
>> The problem purely exists on arrays that report write back cache enabled
>> AND don't implement SYNC_CACHE as a noop. Do any of them exist, or are
>> they purely urban legend?
> 
> I haven't seen it.  I don't care particularly about this case, but once
> it a while people want to disable flushing for testing or because they
> really don't care.
> 
> What about adding a sysfs attribue to every request_queue that allows
> disabling the cache flushing feature?  Compared to the barrier option
> this controls the feature at the right level and makes it available
> to everyone instead of beeing duplicated.  After a while we can then
> simply ignore the barrier/nobarrier options.

Yeah, that sounds reasonable.  blk_queue_flush() can be called anytime
without locking anyway, so it should be really easy to implement too.

Thanks.

-- 
tejun
