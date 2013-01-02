Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab3ABQaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 11:30:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736Ab3ABQay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 11:30:54 -0500
Date: Wed, 2 Jan 2013 11:30:10 -0500
From: Dave Jones <davej@redhat.com>
To: Chris Mason <chris.mason@fusionio.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Mason <clmason@fusionio.com>
Subject: Re: memory corruption, possibly caused by i915
Message-ID: <20130102163010.GB14219@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Chris Mason <chris.mason@fusionio.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Chris Mason <clmason@fusionio.com>
References: <20130102155233.GA12479@redhat.com>
 <20130102160115.GB12838@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130102160115.GB12838@shiny>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2013 at 11:01:15AM -0500, Chris Mason wrote:
 > > [52460.280346] BUG: Bad page map in process panel-6-systray  pte:ffff8800b665a0e8 pmd:b6659067
 > > [52460.280848] addr:00000038bf3fd000 vm_flags:00000070 anon_vma:          (null) mapping:ffff88011052fd98 index:1fd
 > > [52460.281547] vma->vm_ops->fault: filemap_fault+0x0/0x470
 > > [52460.281878] vma->vm_file->f_op->mmap: btrfs_file_mmap+0x0/0x60 [btrfs]
 > > 
 > > It's falling over in btrfs's mmap op, but I think it's just the victim here,
 > > of something else corrupting what had been mmaped in the panel process.
 > 
 > It's a btrfs file, but this isn't in our mmap op.  The traces are
 > finding bad pages at unmap time. 

Sorry, bad wording on my part.
 
 > > Daniel, can you think of additional sanity checks that could be added to
 > > the i915 driver ? (Even if at the expense of speed: a CONFIG_DEBUG option
 > > to prove correctness would be very worthwhile imo)
 > 
 > If the bad pages are getting all the way to btrfs,
 > CONFIG_DEBUG_PAGE_ALOC may help?  You've got lockdep on so maybe you
 > already enabled it.

Yeah, already enabled.

Thanks.

	Dave.
