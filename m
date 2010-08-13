Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab0HMHWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 03:22:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:42449 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab0HMHW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 03:22:27 -0400
Message-ID: <4C64F21D.7010409@kernel.org>
Date: Fri, 13 Aug 2010 09:19:57 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, rwheeler@redhat.com, hare@suse.de,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/11] fs, block: propagate REQ_FLUSH/FUA interface to
 upper layers
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <1281616891-5691-11-git-send-email-tj@kernel.org> <20100812212404.GB3665@quack.suse.cz>
In-Reply-To: <20100812212404.GB3665@quack.suse.cz>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 13 Aug 2010 07:21:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jan.

On 08/12/2010 11:24 PM, Jan Kara wrote:
> On Thu 12-08-10 14:41:30, Tejun Heo wrote:
>> Propagate deprecation of REQ_HARDBARRIER and new REQ_FLUSH/FUA
>> interface to upper layers.
>>
>> * WRITE_BARRIER is marked deprecated and WRITE_FLUSH, WRITE_FUA and
>>   WRITE_FLUSH_FUA are added.
>>
>> * REQ_COMMON_MASK now includes REQ_FLUSH | REQ_FUA so that they are
>>   copied from bio to request.
>>
>> * BH_Ordered is marked deprecated and BH_Flush and BH_FUA are added.
>
>   Deprecating BH_Ordered is fine but I wouldn't introduce new BH flags for
> this. BH flags should be used for buffer state, not for encoding how the
> buffer should be written (there were actually bugs in the past because of
> this). Being able to set proper flags when calling submit_bh() in the rw
> parameter is enough.

Ah, okay, I was just trying to match the BH_Ordered usage but you're
saying just requiring submit_bh() users to specify appropriate REQ_*
(or WRITE_*) in @rw is okay, right?  I'll drop the bh part then.

Thanks.

-- 
tejun
