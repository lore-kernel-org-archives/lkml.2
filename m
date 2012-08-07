Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab2HGPi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 11:38:27 -0400
Received: from sentry-two.sandia.gov ([132.175.109.14]:38223 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab2HGPiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 11:38:25 -0400
X-Greylist: delayed 1071 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Aug 2012 11:38:25 EDT
X-WSS-ID: 0M8E5A6-0B-2PZ-02
X-M-MSG: 
X-Server-Uuid: 6BFC7783-7E22-49B4-B610-66D6BE496C0E
Message-ID: <50213228.1030107@sandia.gov>
Date: Tue, 7 Aug 2012 09:20:08 -0600
From: "Jim Schutt" <jaschut@sandia.gov>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607
 Thunderbird/10.0.5
MIME-Version: 1.0
To: "Mel Gorman" <mgorman@suse.de>
cc: "Rik van Riel" <riel@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        "Minchan Kim" <minchan@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] mm: have order > 0 compaction start near a
 pageblock with free pages
References: <1344342677-5845-1-git-send-email-mgorman@suse.de>
 <1344342677-5845-7-git-send-email-mgorman@suse.de>
 <50212A05.2070503@redhat.com> <20120807145233.GG29814@suse.de>
In-Reply-To: <20120807145233.GG29814@suse.de>
X-TMWD-Spam-Summary: TS=20120807152011; ID=1; SEV=2.3.1;
 DFV=B2012080716; IFV=NA; AIF=B2012080716; RPD=5.03.0010; ENG=NA;
 RPDID=7374723D303030312E30413031303230392E35303231333232422E303031423A534346535441543838363133332C73733D312C6667733D30;
 CAT=NONE; CON=NONE; SIG=AAABAJsKIgAAAAAAAAAAAAAAAAAAAH0=
X-MMS-Spam-Filter-ID: B2012080716_5.03.0010
X-WSS-ID: 7C3FEDA34N0423246-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
X-RSA-Inspected: yes
X-RSA-Classifications: public
X-RSA-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 08:52 AM, Mel Gorman wrote:
> On Tue, Aug 07, 2012 at 10:45:25AM -0400, Rik van Riel wrote:
>> On 08/07/2012 08:31 AM, Mel Gorman wrote:
>>> commit [7db8889a: mm: have order>   0 compaction start off where it left]
>>> introduced a caching mechanism to reduce the amount work the free page
>>> scanner does in compaction. However, it has a problem. Consider two process
>>> simultaneously scanning free pages
>>>
>>> 				    			C
>>> Process A		M     S     			F
>>> 		|---------------------------------------|
>>> Process B		M 	FS
>>
>> Argh. Good spotting.
>>
>>> This is not optimal and it can still race but the compact_cached_free_pfn
>>> will be pointing to or very near a pageblock with free pages.
>>
>> Agreed on the "not optimal", but I also cannot think of a better
>> idea right now. Getting this fixed for 3.6 is important, we can
>> think of future optimizations in San Diego.
>>
>
> Sounds like a plan.
>
>>> Signed-off-by: Mel Gorman<mgorman@suse.de>
>>
>> Reviewed-by: Rik van Riel<riel@redhat.com>
>>
>
> Thanks very much.
>
> Jim, what are the chances of getting this series tested with your large
> data workload? As it's on top of 3.5, it should be less scary than
> testing 3.6-rc1 but if you are comfortable testing 3.6-rc1 then please
> test with just this patch on top.
>

As it turns out I'm already testing 3.6-rc1, as I'm on
the trail of a Ceph client messaging bug.  I think I've
about got that figured out, and am working on a patch, but
I need it fixed in order to generate enough load to trigger
the problem that your patch addresses.

Which is a long-winded way of saying:  no problem, I'll
roll this into my current testing, but I'll need another
day or two before I'm likely to be able to generate a
high enough load to test effectively.  OK?

Also FWIW, it occurs to me that you might be interested
to know that my load also involves lots of network load
where I'm using jumbo frames.  I suspect that puts even
more stress on higher page order allocations, right?

-- Jim

