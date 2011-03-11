Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1CKAiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:38:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:46002 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767Ab1CKAip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 19:38:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,299,1297065600"; 
   d="scan'208";a="896072468"
Subject: Re: isci for 2.6.39?
From: Dan Williams <dan.j.williams@intel.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Nadolski, Edmund" <edmund.nadolski@intel.com>,
        "Ciechanowski, Ed" <ed.ciechanowski@intel.com>,
        "Danecki, Jacek" <jacek.danecki@intel.com>,
        "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>
In-Reply-To: <1299802219.11933.175.camel@mulgrave.site>
References: <1299801757.8641.21.camel@dwillia2-linux>
	 <1299802219.11933.175.camel@mulgrave.site>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Mar 2011 16:40:10 -0800
Message-ID: <1299804010.8641.46.camel@dwillia2-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 16:10 -0800, James Bottomley wrote:
> On Thu, 2011-03-10 at 16:02 -0800, Dan Williams wrote:
> > Given the impending opening of the 2.6.39 merge window I would like to
> > discuss the options for merging the isci driver.  Review has been
> > intermittent which is understandable given the size and flux of the
> > codebase.  It has received a good amount of cleanups, but additional
> > review issues and cleanups are still all too easy to spot.  I know you
> > have expressed reservations about taking scsi drivers through -staging
> > in the past [1], so I would like to propose an alternative.  Merge the
> > driver into scsi-misc but with a -staging style TODO file that tracks
> > the review issues.  If the TODO file is not addressed by the 2.6.40
> > window the driver would be moved to -staging.  This has the benefit of
> > keeping the driver under your purview and expected location, but still
> > have the imminent prospect of being de-staged to ensure the community's
> > concerns are ultimately addressed.  We fully intend to maintain the
> > current momentum on the driver cleanup effort and be ready in advance of
> > 2.6.40.
> 
> Given that you only posted the core files today, I think it's a bit late
> for the 2.6.39 merge window, which will be opening in under a week.

The core has been available for review via the git tree for a month.  We
waited to roll out the core in patch form to be considerate of people's
review bandwidth and to get focus on the lldd portion while additional
cleanups were applied to the core.

> You could send it all to staging ... it's just that pretty much seems to
> guarantee no SCSI review, which is what you seem to need at the moment.

Right, hence the proposal for provisional acceptance into scsi-misc.
Either way there will be a TODO file with issues to address by 2.6.40.
I realize this is unprecedented, but I believe you can derive the team's
ability and willingness to cleanup the driver from the git history [1]
(Note the Reported-by tags for all the review comments received to
date).

If the team gets hit by a bus and stops making cleanups we can always
de-stage the driver.

As a matter of process do you ever take git pull requests, or only
patches?

> > As a side note I'm still looking for a disposition for:
> > "libsas: flush initial device discovery before completing ->scan_finished()" [2]
> > "libsas: fix/amend device gone notification in sas_deform_port()" [3]
> 
> I thought I commented ... I'll go back and dig them out of email.

You did comment on the sas_flush_discovery() one, and I found that
flush_workqueue does not account for new work queued as a result of the
flush.

--
Dan

[1]: git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git

