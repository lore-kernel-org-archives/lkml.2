Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317Ab1CQFVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 01:21:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37080 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab1CQFVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 01:21:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4D819A2A.8050606@jp.fujitsu.com>
Date: Thu, 17 Mar 2011 14:20:42 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Check whether pages are poisoned before copying
References: <4D817234.9070106@jp.fujitsu.com> <4D8172D7.3040201@jp.fujitsu.com> <20110317041424.GD11094@one.firstfloor.org>
In-Reply-To: <20110317041424.GD11094@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/03/17 13:14), Andi Kleen wrote:
> On Thu, Mar 17, 2011 at 11:32:55AM +0900, Hidetoshi Seto wrote:
>> So to avoid the above problem, add poison checks for both of 4K pages
>> and the THP before copying in __collapse_huge_page_copy().
> 
> I don't think you need the check for the huge page -- it should not be allocated
> in this case.

Is there no case that the THP is once allocated but poison flag
is set before copy?  Though I know it is one of corner cases,
having this check for THP is worse than nothing.

Thanks,
H.Seto

