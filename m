Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab1I0RHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:07:04 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:55671 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab1I0RHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:07:03 -0400
X-IronPort-AV: E=Sophos;i="4.68,450,1312171200"; 
   d="scan'208";a="164838942"
Message-ID: <4E820316.6070101@citrix.com>
Date: Tue, 27 Sep 2011 18:08:38 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Konrad Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH v2] xen: Fix selfballooning and ensure it doesn't go too
 far
References: <2de59b55-4ecc-4155-8709-f8b0f5e012bc@default 4E81F278.5040107@citrix.com> <f42e2a83-15f6-4767-a7df-8a23ceac239e@default>
In-Reply-To: <f42e2a83-15f6-4767-a7df-8a23ceac239e@default>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/09/11 17:19, Dan Magenheimer wrote:
>> From: David Vrabel [mailto:david.vrabel@citrix.com]
>> Subject: Re: [PATCH v2] xen: Fix selfballooning and ensure it doesn't go too far
>>
>> On 27/09/11 16:03, Dan Magenheimer wrote:
>>> Note: This patch is also now in a git tree at:
>>>
>>> git://oss.oracle.com/git/djm/tmem.git#selfballoon-fix-v2
>>>
>>> The balloon driver's "current_pages" is very different from
>>> totalram_pages.  Self-ballooning needs to be driven by
>>> the latter.
> 
> Hi David --
> 
> Thanks for the feedback!
>  
>> I don't think this part of the change makes any difference. It looks like it
>> rearranges the maths without changing the end result (other than
>> slightly increasing the rate of change).
>> I think this (partial, untested) patch is equivalent:
> 
> Actually it does.

Really?

Both patched and unpatched the new target, S, is (eventually):

   S = V + F + C - T

where V is vm_committed_as, F is frontswap_curr_pages(), C is
balloon_stats.current_pages, and T = totalram_pages.

Perhaps the refactoring of the maths is a good idea (I don't think so)
but it shouldn't be part of this patch and it shouldn't be described as
a fix.

David
