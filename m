Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab0HRJrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 05:47:05 -0400
Received: from verein.lst.de ([213.95.11.210]:47063 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab0HRJrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 05:47:03 -0400
Date: Wed, 18 Aug 2010 11:46:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with sequenced flush
Message-ID: <20100818094620.GA14707@lst.de>
References: <1281616891-5691-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281616891-5691-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI: One issue with this series is that make_request based drivers
not have to access all REQ_FLUSH and REQ_FUA requests.  We'll either
need to add handling to empty REQ_FLUSH requests to all of them or
figure out a way to prevent them getting sent.  That is assuming they'll
simply ignore REQ_FLUSH/REQ_FUA on normal writes.

