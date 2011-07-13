Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab1GMRKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 13:10:15 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:56945 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab1GMRKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 13:10:13 -0400
Date: Wed, 13 Jul 2011 11:10:11 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Jiang, Dave" <dave.jiang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Foong, Annie" <annie.foong@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nadolski, Edmund" <edmund.nadolski@intel.com>,
        "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>
Subject: Re: rq_affinity doesn't seem to work?
Message-ID: <20110713171011.GA11864@parisc-linux.org>
References: <D010E79907AF0D4E90B603DE907837D504CA6365D6@azsmsx504.amr.corp.intel.com> <4E1CAEEB.8050506@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1CAEEB.8050506@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 10:30:35PM +0200, Jens Axboe wrote:
> It's probably the grouping, we need to do something about that. Does the
> below patch make it behave as you expect?

"something", absolutely.  But there is benefit from doing some aggregation
(we tried disabling it entirely with the "well-known OLTP benchmark" and
performance went down).

Ideally we'd do something like "if the softirq is taking up more than 10%
of a core, split the grouping".  Do we have enough stats to do that kind
of monitoring?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
