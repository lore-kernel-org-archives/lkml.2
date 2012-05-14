Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab2ENQwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:52:24 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:13325 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967Ab2ENQwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:52:23 -0400
Date: Mon, 14 May 2012 18:52:21 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 3/4] memblock: limit memory address from memblock
Message-ID: <20120514165221.GA14426@merkur.ravnborg.org>
References: <4FACA79C.9070103@cn.fujitsu.com> <4FB0F174.1000400@jp.fujitsu.com> <4FB0F37E.2040805@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB0F37E.2040805@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 08:58:54PM +0900, Yasuaki Ishimatsu wrote:
> Setting kernelcore_max_pfn means all memory which is bigger than
> the boot parameter is allocated as ZONE_MOVABLE. So memory which
> is allocated by memblock also should be limited by the parameter.
>
> The patch limits memory from memblock.

I see no reason why we need two limits for memblock.
And if we really require two limits then please use a function
to set it.
All other setup/etc. towoards memblock is via function,
and starting to introduce magic variables is confusing.

Also new stuff in memblock shal have a nice comment
describing the usage. that we in the past has failed to
do so is no excuse.

	Sam
