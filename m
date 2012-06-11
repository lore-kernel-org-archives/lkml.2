Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab2FKJdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:33:49 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:43353 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab2FKJds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:33:48 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V8 10/16] hugetlb/cgroup: Add the cgroup pointer to page lru
In-Reply-To: <20120611091658.GG12402@tiehlicka.suse.cz>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339232401-14392-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120611081653.GB12402@tiehlicka.suse.cz> <87oboq5ifb.fsf@skywalker.in.ibm.com> <20120611091658.GG12402@tiehlicka.suse.cz>
User-Agent: Notmuch/0.13.2+35~g0ff57e7 (http://notmuchmail.org) Emacs/24.1.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 11 Jun 2012 15:03:30 +0530
Message-ID: <87ipey5h1x.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12061109-2000-0000-0000-000007DFCFF6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko <mhocko@suse.cz> writes:

> On Mon 11-06-12 14:33:52, Aneesh Kumar K.V wrote:
>> Michal Hocko <mhocko@suse.cz> writes:
>> 
>> > On Sat 09-06-12 14:29:55, Aneesh Kumar K.V wrote:
>> >> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>> >> 
>> >> Add the hugetlb cgroup pointer to 3rd page lru.next.
>> >
>> > Interesting and I really like the idea much more than tracking by
>> > page_cgroup.
>> >
>> >> This limit the usage to hugetlb cgroup to only hugepages with 3 or
>> >> more normal pages. I guess that is an acceptable limitation.
>> >
>> > Agreed.
>> >
>> >> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>> >
>> > Other than some nits I like this.
>> > Thanks!
>> >
>> >> ---
>> >>  include/linux/hugetlb_cgroup.h |   31 +++++++++++++++++++++++++++++++
>> >>  mm/hugetlb.c                   |    4 ++++
>> >>  2 files changed, 35 insertions(+)
>> >> 
>> >> diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
>> >> index 5794be4..ceff1d5 100644
>> >> --- a/include/linux/hugetlb_cgroup.h
>> >> +++ b/include/linux/hugetlb_cgroup.h
>> >> @@ -26,6 +26,26 @@ struct hugetlb_cgroup {
>> >>  };
>> >>  
>> >>  #ifdef CONFIG_CGROUP_HUGETLB_RES_CTLR
>> >> +static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
>> >> +{
>> >> +	if (!PageHuge(page))
>> >> +		return NULL;
>> >> +	if (compound_order(page) < 3)
>> >
>> > Why 3? I think you wanted 2 here, right?
>> 
>> Yes that should be 2. I updated that in an earlier. Already in v9
>> version I have locally.
>
> ohh, I should have read replies to the patch first where you already
> mentioned that you are aware of that.
> Maybe it would be worth something like:
> /* Minimum page order trackable by hugetlb cgroup.
>  * At least 3 pages are necessary for all the tracking information.
>  */
> #define HUGETLB_CGROUP_MIN_ORDER	2

Excellent will do that.

-aneesh

