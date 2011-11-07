Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717Ab1KGQn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:43:57 -0500
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:40521 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab1KGQnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:43:55 -0500
Date: Mon, 7 Nov 2011 17:43:51 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Steffen Maier <maier@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        "Taraka R. Bodireddy" <tarak.reddy@in.ibm.com>,
        "Seshagiri N. Ippili" <seshagiri.ippili@in.ibm.com>,
        "Manvanthara B. Puttashankar" <mputtash@in.ibm.com>,
        Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
        gmuelas@de.ibm.com
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Message-ID: <20111107164351.GA2483@osiris.boeblingen.de.ibm.com>
References: <20111018154542.GB3869@osiris.boeblingen.de.ibm.com>
 <1318955380.5169.15.camel@dabdike.int.hansenpartnership.com>
 <20111031100557.GA2621@osiris.boeblingen.de.ibm.com>
 <1320057746.2964.1.camel@dabdike>
 <4EAE8A7E.8000504@ce.jp.nec.com>
 <20111031130004.GB4768@osiris.boeblingen.de.ibm.com>
 <20111103182548.GA12131@redhat.com>
 <20111104091936.GB2397@osiris.boeblingen.de.ibm.com>
 <4EB7C159.8020009@ce.jp.nec.com>
 <20111107153649.GA9935@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111107153649.GA9935@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 10:36:49AM -0500, Mike Snitzer wrote:
> > struct pgpath is freed before dm_target when tearing down dm table.
> > So if the problematic completion was being done after freeing pgpath
> > but before freeing dm_target, crash would look like that
> > and what's happening seems the same for these dm crashes:
> > dm table was somehow destroyed while I/O was in-flight.
> 
> Could be the block layer's onstack plugging changes are at the heart of
> this.
> 
> I voiced onstack plugging concerns relative to DM some time ago
> (https://lkml.org/lkml/2011/3/9/450) but somehow convinced myself DM was
> fine to no longer need dm_table_unplug_all() etc.  Unfortunately I
> cannot recall _why_ I felt that was the case.
> 
> So DM needs further review relative to block's onstack plugging changes
> and DM IO completion.
> 
> > It's interesting that your test started to crash in dm with v3.0.7.
> > Have you gotten these dm crashes with v3.0.6 or before?
> > Have you hit the initially-reported scsi oops with v3.0.7?
> > Are your v3.0.6 and v3.0.7 compiled with same config and the tests
> > ran on same system?
> 
> If all 3.0.x fail: it would be interesting to know if 2.6.39 (which
> introduced the onstack plugging) also has these problems.

At least 2.6.39.1 failed as well, as reported already in June. At least
the crash looked similar back then:

http://marc.info/?l=linux-scsi&m=130824013229933&w=2

> Testing with
> 2.6.38 would be very insightful because it obviously doesn't have any of
> the onstack plugging churn.

Ok, we might try 2.6.38.8 (latest stable) and see what happens.
