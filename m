Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab0HQQ1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:27:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:53360 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757987Ab0HQQ1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:27:31 -0400
Message-ID: <4C6AB79B.2040303@kernel.org>
Date: Tue, 17 Aug 2010 18:23:55 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/11] block: rename barrier/ordered to flush
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <1281616891-5691-9-git-send-email-tj@kernel.org> <20100817132646.GA3577@lst.de>
In-Reply-To: <20100817132646.GA3577@lst.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 17 Aug 2010 16:27:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/17/2010 03:26 PM, Christoph Hellwig wrote:
>> -#define blk_queue_flushing(q)	((q)->ordseq)
>> +#define blk_queue_flushing(q)	((q)->flush_seq)
> 
> Btw, I think this one should just go away.  It's only used by
> ide in an attempt to make ordered sequences atomic, which isn't
> needed for the new design.

Yeap, agreed.  I couldn't really understand why the the sequence
needed to be atomic for ide in the first place so just left it alone.
Do you understand why it tried to be atomic?

Thanks.

-- 
tejun
