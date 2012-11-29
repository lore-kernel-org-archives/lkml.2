Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab2K2OyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 09:54:17 -0500
Received: from science.horizon.com ([71.41.210.146]:14975 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753407Ab2K2OyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 09:54:16 -0500
Date: 29 Nov 2012 09:54:14 -0500
Message-ID: <20121129145414.9415.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, mgorman@suse.de
Subject: Re: 3.7-rc6 soft lockup in kswapd0
Cc: dave@linux.vnet.ibm.com, hannes@cmpxchg.org, jack@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, riel@redhat.com
In-Reply-To: <20121128113920.GU8218@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mgorman@suse.de> wrote:
> On Tue, Nov 27, 2012 at 04:25:14PM -0500, George Spelvin wrote:
>> Well, it just made it to 24 hours, 
>> it did before.  I'm going to wait a couple more days before declaring
>> victory, but it looks good so far.
>> 
>>  19:19:10 up 1 day, 0 min,  2 users,  load average: 0.15, 0.20, 0.22
>>  21:24:05 up 1 day,  2:05,  2 users,  load average: 0.25, 0.19, 0.18
>
> Superb. The relevant patches *should* be in flight for 3.7 assuming they
> make it through the confusion of last-minute fixes.

 14:53:54 up 2 days, 19:35,  2 users,  load average: 0.20, 0.24, 0.23

Almost three days, when it wouldn't live overnight before.
As promised, I'm declaring victory.

The patch that worked (on top of -rc7) was Johannes Weiner's
"mm: vmscan: fix endless loop in kswapd balancing"
that added the zone_balanced() function to mm/vmscan.c:2400.

Thank you all very much!
