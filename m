Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab0HWMlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 08:41:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:35026 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab0HWMlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 08:41:46 -0400
Message-ID: <4C726B55.80503@kernel.org>
Date: Mon, 23 Aug 2010 14:36:37 +0200
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
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100820132214.GA6184@lst.de>
In-Reply-To: <20100820132214.GA6184@lst.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 23 Aug 2010 12:41:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/20/2010 03:22 PM, Christoph Hellwig wrote:
> Many storage devices, especially in the consumer market, come with volatile
> write back caches.  That means the devices signal I/O completion to the
> operating system before data actually has hit the physical medium.

A bit nit picky but flash devices can also have writeback caches and
the term physical medium sounds a bit off for those cases.  Maybe just
saying "non-volatile media" is better?

> Implementation details for filesystems
> --------------------------------------
> 
> Filesystem can simply set the REQ_FLUSH and REQ_FUA bits and do not have to
> worry if the underlying devices need any explicit cache flushing and how
> the Forced Unit Access is implemented.  The REQ_FLUSH and REQ_FUA flags
> may both be set on a single bio.

It may be worthwhile to explain the sequence of operations when
REQ_FLUSH + data + REQ_FUA is executed.  It can be extrapolated from
the previous two descriptions but I think giving examples of different
sequences depending on FLUSH/FUA configuration would be helpful to
help understanding the overall picture of things.

Other than those, looks good to me.

Thanks.

-- 
tejun
