Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab0HQN1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 09:27:19 -0400
Received: from verein.lst.de ([213.95.11.210]:46974 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782Ab0HQN1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 09:27:17 -0400
Date: Tue, 17 Aug 2010 15:26:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/11] block: rename barrier/ordered to flush
Message-ID: <20100817132646.GA3577@lst.de>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <1281616891-5691-9-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281616891-5691-9-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -#define blk_queue_flushing(q)	((q)->ordseq)
> +#define blk_queue_flushing(q)	((q)->flush_seq)

Btw, I think this one should just go away.  It's only used by
ide in an attempt to make ordered sequences atomic, which isn't
needed for the new design.
