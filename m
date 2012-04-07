Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab2DGDAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 23:00:34 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:63438 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab2DGDAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 23:00:33 -0400
Message-ID: <4F7FADC3.3000209@gmail.com>
Date: Fri, 06 Apr 2012 20:00:19 -0700
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        kosaki.motohiro@gmail.com
Subject: Re: [RFC PATCH 0/2] Removal of lumpy reclaim
References: <1332950783-31662-1-git-send-email-mgorman@suse.de> <20120406123439.d2ba8920.akpm@linux-foundation.org> <alpine.LSU.2.00.1204061316580.3057@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1204061316580.3057@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/6/12 1:31 PM), Hugh Dickins wrote:
> On Fri, 6 Apr 2012, Andrew Morton wrote:
>> On Wed, 28 Mar 2012 17:06:21 +0100
>> Mel Gorman<mgorman@suse.de>  wrote:
>>
>>> (cc'ing active people in the thread "[patch 68/92] mm: forbid lumpy-reclaim
>>> in shrink_active_list()")
>>>
>>> In the interest of keeping my fingers from the flames at LSF/MM, I'm
>>> releasing an RFC for lumpy reclaim removal.
>>
>> I grabbed them, thanks.
>
> I do have a concern with this: I was expecting lumpy reclaim to be
> replaced by compaction, and indeed it is when CONFIG_COMPACTION=y.
> But when CONFIG_COMPACTION is not set, we're back to 2.6.22 in
> relying upon blind chance to provide order>0 pages.

I was putted most big objection to remove lumpy when compaction merging. But
I think that's ok. Because of, desktop and server people always use COMPACTION=y
kernel and embedded people don't use swap (then lumpy wouldn't work).

My thought was to keep gradual development and avoid aggressive regression. and
Mel did. compaction is now completely stable and we have no reason to keep lumpy,
I think.

Thanks.
