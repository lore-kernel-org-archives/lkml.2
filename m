Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab0HWMfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 08:35:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:56164 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab0HWMft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 08:35:49 -0400
Message-ID: <4C7269E9.9070304@kernel.org>
Date: Mon, 23 Aug 2010 14:30:33 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Ric Wheeler <rwheeler@redhat.com>
CC: Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu,
        chris.mason@oracle.com, swhiteho@redhat.com,
        konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net,
        jack@suse.cz, hare@suse.de
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100820132214.GA6184@lst.de> <4C6E9CAF.5010202@redhat.com>
In-Reply-To: <4C6E9CAF.5010202@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 23 Aug 2010 12:35:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/20/2010 05:18 PM, Ric Wheeler wrote:
> On 08/20/2010 09:22 AM, Christoph Hellwig wrote:
>> FYI: here's a little writeup to document the new cache flushing scheme,
>> intended to replace Documentation/block/barriers.txt.  Any good
>> suggestion for a filename in the kernel tree?
>>
> 
> I was thinking that we might be better off using the "durable
> writes" term more since it is well documented (at least in the
> database world, where it is the "D" in ACID properties).  Maybe
> "durable_writes_support.txt" ?

The term is very foreign to people outside of enterprise / database
loop.  writeback-cache.txt or write-cache-control.txt sounds good
enough to me.

>> The Linux block layer provides a two simple mechanism that lets filesystems
>> control the caching behavior of the storage device.  These mechanisms are
>> a forced cache flush, and the Force Unit Access (FUA) flag for requests.
>>
> 
> Should we mention that users can also disable the write cache on the
> target device?
> 
> It might also be worth mentioning that storage needs to be properly
> configured - i.e., an internal hardware RAID card with battery
> backing needs can expose itself as a writethrough cache *only if* it
> actually has control over all of the backend disks and can
> flush/disable their write caches.

It might be useful to give several example configurations with
different cache configurations.  I don't have much experience with
battery backed arrays but aren't they suppose to report write through
cache automatically?

Thanks.

-- 
tejun
