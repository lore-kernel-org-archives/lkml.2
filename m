Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab2HFPsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:48:01 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:37530 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab2HFPr6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:47:58 -0400
MIME-Version: 1.0
Message-ID: <aa61fb77-258b-4b6f-843f-689bc5c984cc@default>
Date: Mon, 6 Aug 2012 08:46:18 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Minchan Kim <minchan@kernel.org>, John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Mike Hommey <mh@glandium.org>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org
Subject: RE: [PATCH 4/5] [RFC][HACK] Add LRU_VOLATILE support to the VM
References: <1343447832-7182-1-git-send-email-john.stultz@linaro.org>
 <1343447832-7182-5-git-send-email-john.stultz@linaro.org>
 <20120806030451.GA11468@bbox>
In-Reply-To: <20120806030451.GA11468@bbox>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Minchan Kim [mailto:minchan@kernel.org]
> To: John Stultz
> Subject: Re: [PATCH 4/5] [RFC][HACK] Add LRU_VOLATILE support to the VM

Hi Minchan --

Thanks for cc'ing me on this!

> Targets for the LRU list could be following as in future
> 
> 1. volatile pages in this patchset.
> 2. ephemeral pages of tmem
> 3. madivse(DONTNEED)
> 4. fadvise(NOREUSE)
> 5. PG_reclaimed pages
> 6. clean pages if we write CFLRU(clean first LRU)
> 
> So if any guys have objection, please raise your hands
> before further progress.

I agree that the existing shrinker mechanism is too primitive
and the kernel needs to take into account more factors in
deciding how to quickly reclaim pages from a broader set
of sources.  However, I think it is important to ensure
that both the "demand" side and the "supply" side are
studied.  There has to be some kind of prioritization policy
among all the RAM consumers so that a lower-priority
alloc_page doesn't cause a higher-priority "volatile" page
to be consumed.  I suspect this policy will be VERY hard to
define and maintain.

Related, ephemeral pages in tmem are not truly volatile
as there is always at least one tmem data structure pointing
to it.  I haven't followed this thread previously so my apologies
if it already has this, but the LRU_VOLATILE list might
need to support a per-page "garbage collection" callback.

Dan
