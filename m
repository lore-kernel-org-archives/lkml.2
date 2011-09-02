Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998Ab1IBBSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 21:18:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:30662 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932809Ab1IBBSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 21:18:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,316,1312182000"; 
   d="scan'208";a="47874164"
Message-ID: <4E602EC8.9010306@intel.com>
Date: Fri, 02 Sep 2011 09:18:00 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110820 Iceowl/1.0b2 Icedove/3.1.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 1/2] irq_work, Use llist in irq_work
References: <1314681384-20881-1-git-send-email-ying.huang@intel.com>			 <1314681384-20881-2-git-send-email-ying.huang@intel.com>		 <1314785405.23993.21.camel@twins> <4E5EE409.3060102@intel.com>	 <1314863829.7945.9.camel@twins> <4E5F45F6.70009@intel.com> <1314871201.7945.17.camel@twins>
In-Reply-To: <1314871201.7945.17.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2011 06:00 PM, Peter Zijlstra wrote:
> On Thu, 2011-09-01 at 16:44 +0800, Huang Ying wrote:
> 
>> Because llist is in library, it may be used in highly contended case and
>> light/un-contended loads.  So maybe code as above is best choice for llist.
> 
> Well the thing is, if you're heavily contended you should probably be
> doing something else..

So which solution is preferable?

1) no cpu_relax
2) cpu_relax after first cmpxchg

Personally, I prefer 2).  It should have acceptable overhead in
ligh/un-contended loads.  Do you agree.

Best Regards,
Huang Ying
