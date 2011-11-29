Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab1K2Tdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 14:33:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756299Ab1K2Tds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 14:33:48 -0500
Date: Tue, 29 Nov 2011 14:33:36 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        Shuichi Ihara <sihara@ddn.com>, dm-devel@redhat.com
Subject: Re: [RFC PATCH] block: change max_segments default to USHRT_MAX
Message-ID: <20111129193335.GA6827@redhat.com>
References: <1322517615-28530-1-git-send-email-snitzer@redhat.com>
 <yq1mxbehkt6.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1mxbehkt6.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29 2011 at 12:59pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> The reported problem was that a DM multipath device's max_segemnts
> Mike> was constrained to BLK_MAX_SEGMENTS (128) even though the
> Mike> underlying paths' max_segments were larger.  For example, SCSI
> Mike> establishes a max_segments of SCSI_MAX_SG_CHAIN_SEGMENTS (2048).
> 
> I'd rather that we revisited the patches I posted a while back where we
> have different defaults for LLDs and stacking drivers.

Don't think I ever saw those patches.  But it isn't immediately clear to
me why we'd want to have to continue to think in different terms
depending on whether we're LLD or stacked (especially for max_segments).

Though I do understand why we need it in some cases, e.g.: the existing
conflicting default for discard_zeroes_data (block vs DM).  It is
unfortunate yet necessary given the current limits stacking.

(We _could_ make dzd=0 the uniform default if DM were made to look at
all devices in a table and decide whether dzd should be enabled,
something like we do for discards with dm_table_supports_discards())

Thing is we have the block layer doing the stacking of limits.. so
ideally the stacking drivers wouldn't need to work so hard to keep the
block layer non-committal on differentiating between LLD vs stacked.

I'd imagine your patches will formalize an interface that gets us away
from what may seem, to the uninitiated, like adhoc twiddling of certain
limits.

> I'll freshen those up and post them later today.

Great (please cc dm-devel when you post them).

Long story short, I look forward to seeing your patches ;)

Thanks!
