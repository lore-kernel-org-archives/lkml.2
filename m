Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951Ab1BYUI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:08:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932901Ab1BYUI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:08:26 -0500
Date: Fri, 25 Feb 2011 21:07:23 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Arthur Marsh <arthur.marsh@internode.on.net>,
        Clemens Ladisch <cladisch@googlemail.com>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Reduce the amount of time compaction disables IRQs
 for V2
Message-ID: <20110225200722.GU23252@random.random>
References: <1298664299-10270-1-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298664299-10270-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 08:04:57PM +0000, Mel Gorman wrote:
> Changelog since V1
>   o Fix initialisation of isolated (Andrea)
> 
> The following two patches are aimed at reducing the amount of time IRQs are
> disabled. It was reported by some ALSA people that transparent hugepages was
> causing slowdowns on MIDI playback but I strongly suspect that compaction
> running for smaller orders was also a factor. The theory was that IRQs
> were being disabled for too long and sure enough, compaction was found to
> be disabling IRQs for a long time. The patches reduce the length of time
> IRQs are disabled when scanning for free pages and for pages to migrate.
> 
> It's late in the cycle but the IRQs disabled times are sufficiently bad
> that it would be desirable to have these merged for 2.6.38 if possible.
> 
>  mm/compaction.c |   35 ++++++++++++++++++++++++++++++-----
>  1 files changed, 30 insertions(+), 5 deletions(-)

both patches:

Acked-by: Andrea Arcangeli <aarcange@redhat.com>
