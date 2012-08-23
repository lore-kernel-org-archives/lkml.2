Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab2HWWKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 18:10:16 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:59957 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab2HWWKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 18:10:10 -0400
Message-ID: <5036AA38.6010400@linux.vnet.ibm.com>
Date: Thu, 23 Aug 2012 17:10:00 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH 0/2] revert changes to zcache_do_preload()
References: <1345735991-6995-1-git-send-email-sjenning@linux.vnet.ibm.com> <20120823205648.GA2066@barrios>
In-Reply-To: <20120823205648.GA2066@barrios>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082322-7408-0000-0000-000007DFC6E9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 03:56 PM, Minchan Kim wrote:
> Hi Seth,
> 
> On Thu, Aug 23, 2012 at 10:33:09AM -0500, Seth Jennings wrote:
>> This patchset fixes a regression in 3.6 by reverting two dependent
>> commits that made changes to zcache_do_preload().
>>
>> The commits undermine an assumption made by tmem_put() in
>> the cleancache path that preemption is disabled.  This change
>> introduces a race condition that can result in the wrong page
>> being returned by tmem_get(), causing assorted errors (segfaults,
>> apparent file corruption, etc) in userspace.
>>
>> The corruption was discussed in this thread:
>> https://lkml.org/lkml/2012/8/17/494
> 
> I think changelog isn't enough to explain what's the race.
> Could you write it down in detail?

I didn't come upon this solution via code inspection, but
rather through discovering that the issue didn't exist in
v3.5 and just looking at the changes since then.

> And you should Cc'ed Xiao who is author of reverted patch.

Thanks for adding Xiao.  I meant to do this. For some reason
I thought that you submitted that patchset :-/
My bad.

Seth

