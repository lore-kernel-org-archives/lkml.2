Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab0HSKB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 06:01:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:35963 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206Ab0HSKBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 06:01:55 -0400
Message-ID: <4C6D0021.4040601@kernel.org>
Date: Thu, 19 Aug 2010 11:57:53 +0200
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
        hare@suse.de
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100818094620.GA14707@lst.de>
In-Reply-To: <20100818094620.GA14707@lst.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 19 Aug 2010 10:01:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/18/2010 11:46 AM, Christoph Hellwig wrote:
> FYI: One issue with this series is that make_request based drivers
> not have to access all REQ_FLUSH and REQ_FUA requests.  We'll either
> need to add handling to empty REQ_FLUSH requests to all of them or
> figure out a way to prevent them getting sent.  That is assuming they'll
> simply ignore REQ_FLUSH/REQ_FUA on normal writes.

Can you be a bit more specific?  In most cases, request based drivers
should be fine.  They sit behind the front most request_queue which
would discompose REQ_FLUSH/FUAs into appropriate command sequence.
For the request based drivers, it's not different from the original
REQ_HARDBARRIER mechanism, it'll just see flushes and optionally FUA
writes.

Thanks.

-- 
tejun
