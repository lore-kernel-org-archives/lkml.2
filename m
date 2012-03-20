Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab2CTSHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 14:07:12 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:60871 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab2CTSHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 14:07:08 -0400
Message-ID: <4F68C693.8020209@linaro.org>
Date: Tue, 20 Mar 2012 11:04:03 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] [RFC] Range tree implementation
References: <1331938267-13583-1-git-send-email-john.stultz@linaro.org> <1331938267-13583-2-git-send-email-john.stultz@linaro.org> <CAO6Zf6D_uREG5n=yZ04CicHkYsXQp_Zs1xJX2z6C9tyKrP=+Kg@mail.gmail.com>
In-Reply-To: <CAO6Zf6D_uREG5n=yZ04CicHkYsXQp_Zs1xJX2z6C9tyKrP=+Kg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032018-3352-0000-0000-000003734265
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2012 03:00 AM, Dmitry Adamushko wrote:
> Hi John,
>
> On 16 March 2012 23:51, John Stultz<john.stultz@linaro.org>  wrote:
>> After Andrew suggested something like his mumbletree idea
>> to better store a list of ranges, I worked on a few different
>> approaches, and this is what I've finally managed to get working.
>>
>> I suspect range-tree isn't a totally accurate name, but I
>> couldn't quite make out the difference between range trees
>> and interval trees, so I just picked one to call it. Do
>> let me know if you have a better name.
>>
>> The idea of storing ranges in a tree is nice, but has a number
>> of complications. When adding a range, its possible that a
>> large range will consume and merge a number of smaller ranges.
> Have you considered using 'prio_tree' (include/linux/prio_tree.h)? If
> we aim at addressing a wide range of possible use-cases (different
> patterns of adding/removing volatile ranges), then, at first glance,
> prio_tree looks like a better approach.
I'll take a closer look at that!

> e.g. for the "consume and merge a number of smaller ranges" scenario
> above, prio_tree gives O(log n) [ O(log n + m) ] behavior iso O(m log
> n) in your case.
Yea, one of the items I was looking at yesterday was to improve the 
range insert/remove usage, since I end up starting each lookup from the 
root node over and over.  I'm thinking of adding a iterate-next type 
call so that we don't re-start the lookup each iteration of the loop 
once we've found an item.

Thanks again for the great feedback!

-john

