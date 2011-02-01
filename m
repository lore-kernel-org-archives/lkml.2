Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab1BAQAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 11:00:38 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:9607 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751436Ab1BAQAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 11:00:36 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBABu8R01Ld/sX/2dsb2JhbAAMhAvOA5A5gSeDN3UEhRM
X-IronPort-AV: E=Sophos;i="4.60,411,1291611600"; 
   d="scan'208";a="90120852"
Message-ID: <4D482E21.5040803@teksavvy.com>
Date: Tue, 01 Feb 2011 11:00:33 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alex Elder <aelder@sgi.com>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: Re: [GIT PULL] XFS update for 2.6.38-rc3
References: <201101311642.p0VGgXTS018851@stout.americas.sgi.com>
In-Reply-To: <201101311642.p0VGgXTS018851@stout.americas.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-31 11:42 AM, Alex Elder wrote:
> Linus, please accept the following updates for XFS, for 2.6.38-rc3
> (if it's not too late) or 2.6.38-rc4.
> 
> They are all fixes for bugs that have some pretty undesirable
> consequences.  They address:
> - One spot in which a hang can occur due to neglecting to drop a
>   lock
> - A bug which in some cases a bogus block number can be recorded in
>   a block map btree, resulting in a subsequent BUG_ON().
> - Two memory leaks
> - Three places in which extent sizes are allowed to exceed various
>   size limits
> - One place where code depends on behavior that is not well-defined
>   by the C standard
> - One problem in handling transaction commit errors


Are these bugs all new in 2.6.38, or should some of these fixes
also go out to -stable for earlier revisions?


> Dave Chinner (8):
>       xfs: fix log ticket leak on forced shutdown.
>       xfs: fix efi item leak on forced shutdown
>       xfs: speculative delayed allocation uses rounddown_power_of_2 badly
>       xfs: limit extent length for allocation to AG size
>       xfs: prevent extsize alignment from exceeding maximum extent size
>       xfs: limit extsize to size of AGs and/or MAXEXTLEN
>       xfs: handle CIl transaction commit failures correctly
>       xfs: fix dquot shaker deadlock
> 
> bpm@sgi.com (1):
>       xfs: xfs_bmap_add_extent_delay_real should init br_startblock
