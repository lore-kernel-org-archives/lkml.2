Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab0IQDUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 23:20:47 -0400
Received: from verein.lst.de ([213.95.11.210]:38933 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab0IQDUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 23:20:46 -0400
Date: Fri, 17 Sep 2010 05:20:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/8] scsi: Drop struct Scsi_Host->host_lock around SHT->queuecommand()
Message-ID: <20100917032021.GB25217@lst.de>
References: <1284676529-10756-1-git-send-email-nab@linux-iscsi.org> <1284691571.26423.50.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284691571.26423.50.camel@mulgrave.site>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 10:46:11PM -0400, James Bottomley wrote:
> So at least from where I stand, my object is to reduce the number of
> times we take and release the lock, which this doesn't do.  As I said
> before: we need to figure out the rest, which likely includes an atomic
> for the serial number (which is almost unused).  I think the check
> against SHOST_DEL is fine unlocked.


The check by itself for sure is.  But I wonder whether we make any
assumptions about it not changing while we are in ->queuecommand, which
isn't nessecarily the case after this patch.
