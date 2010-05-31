Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab0EaOtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 10:49:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42243 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab0EaOtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 10:49:08 -0400
Date: Tue, 1 Jun 2010 00:49:04 +1000
From: Nick Piggin <npiggin@suse.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Wrong DIF guard tag on ext2 write
Message-ID: <20100531144904.GL9453@laptop>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
 <yq1iq64kv9f.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1iq64kv9f.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 10:20:44AM -0400, Martin K. Petersen wrote:
> >>>>> "Christof" == Christof Schmitt <christof.schmitt@de.ibm.com> writes:
> 
> Christof> Since the guard tags are created in Linux, it seems that the
> Christof> data attached to the write request changes between the
> Christof> generation in bio_integrity_generate and the call to
> Christof> sd_prep_fn.
> 
> Yep, known bug.  Page writeback locking is messed up for buffer_head
> users.  The extNfs folks volunteered to look into this a while back but
> I don't think they have found the time yet.

What do you mean by messed up? Allowing modifications to the page while
it is under writeback? This is deliberate of course and not limited to
buffer_head users either.

