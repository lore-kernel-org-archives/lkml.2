Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab2GWE63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 00:58:29 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:36906 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab2GWE61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 00:58:27 -0400
Message-ID: <500CD9E9.80602@linux.vnet.ibm.com>
Date: Mon, 23 Jul 2012 12:58:17 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        mingo@redhat.com, paul@paulmenage.org
Subject: Re: [PATCH 0/5] cpusets: dynamical scheduler domain flags
References: <50052A78.6000407@linux.vnet.ibm.com> <1342802550.2583.12.camel@twins> <500CB763.9020802@linux.vnet.ibm.com> <1343017683.7336.67.camel@marge.simpson.net>
In-Reply-To: <1343017683.7336.67.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12072304-3864-0000-0000-000003DDEFC9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2012 12:28 PM, Mike Galbraith wrote:
> On Mon, 2012-07-23 at 10:30 +0800, Michael Wang wrote: 
>> On 07/21/2012 12:42 AM, Peter Zijlstra wrote:
>>> On Tue, 2012-07-17 at 17:03 +0800, Michael Wang wrote:
>>>> This patch set provide a way for user to dynamically configure the scheduler
>>>> domain flags, which usually to be static. 
>>>
>>> NAK.. you don't get to expose all this nonsense in a 'stable' ABI.
>>>
>>> You shouldn't need to prod at them to begin with.
>>
>> So is that means expose those domain flags to user is a bad idea at all?
> 
> You can set/clear flags with scripts now, ie domain flags are already
> exposed.. as defined by the running kernel.
> 
> SD_SHARE_PKG_RESOURCES is a good flag look at.  What does flipping that
> switch do, and what did it stop doing recently?  So yeah, methinks
> exporting flags via cpusets is a bad idea.  Not only is existence of any
> particular flag volatile, functionality behind it is volatile as well,
> so having a button to poke does undefined things.  (not to mention
> non-exclusive sets)
> 

I think I got your and peter's opinion, so we could not make sure the
kernel could still work well if some flags was enabled because their
behave are always changing, and it's impossible to maintain such
volatile feature.

Actually I got this idea after reading:

http://marc.info/?l=linux-kernel&m=130822782111533

But looks like I don't get the point, so what we want is building the
domain according to some system topology designed by producer?

Regards,
Michael Wang

> -Mike
> 
> 


