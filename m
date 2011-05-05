Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab1EECVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 22:21:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:38223 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794Ab1EECVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 22:21:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,318,1301900400"; 
   d="scan'208";a="688382324"
Date: Thu, 5 May 2011 10:21:15 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "htejun@gmail.com" <htejun@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "djwong@us.ibm.com" <djwong@us.ibm.com>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>
Subject: Re: [patch v3 1/3] block: add a non-queueable flush flag
Message-ID: <20110505022115.GA19093@sli10-conroe.sh.intel.com>
References: <20110505015932.306763905@sli10-conroe.sh.intel.com>
 <20110505020417.586891398@sli10-conroe.sh.intel.com>
 <4DC208C3.7070902@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC208C3.7070902@pobox.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 10:17:39AM +0800, Jeff Garzik wrote:
> On 05/04/2011 09:59 PM, shaohua.li@intel.com wrote:
> > flush request isn't queueable in some drives. Add a flag to let driver
> > notify block layer about this. We can optimize flush performance with the
> > knowledge.
> >
> > Signed-off-by: Shaohua Li<shaohua.li@intel.com>
> > ---
> >   block/blk-settings.c   |    6 ++++++
> >   include/linux/blkdev.h |    7 +++++++
> >   2 files changed, 13 insertions(+)
> 
> hmmm.
> 
> This assumes that flush on new hardware, by default, is queueable.
> 
> I think the sense should be reversed:  don't enable the optimization, 
> unless we know the optimization works.
> 
> That seems safer than always enabling the optimization, unless we know 
> it does not work.  That is not a fail-safe mode of operation.
This assumes flush is queueable by default. but I only enable the optimization
for non-queueable flush. So the optimization is off by default, please see
the second patch.

Thanks,
Shaohua
