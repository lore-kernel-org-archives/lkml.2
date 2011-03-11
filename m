Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab1CKS4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 13:56:38 -0500
Received: from mx2.compro.net ([12.186.155.4]:8781 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256Ab1CKS4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 13:56:36 -0500
X-IronPort-AV: E=Sophos;i="4.62,304,1297054800"; 
   d="scan'208";a="6396283"
Message-ID: <4D7A7064.6030607@compro.net>
Date: Fri, 11 Mar 2011 13:56:36 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Sam Ravnborg <sam@ravnborg.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kernel git bisect question
References: <4D793414.4090206@compro.net>	 <20110310215438.GE12521@home.goodmis.org> <4D7A6A99.5070304@compro.net>	 <20110311183711.GA559@merkur.ravnborg.org> <1299869490.9910.49.camel@gandalf.stny.rr.com>
In-Reply-To: <1299869490.9910.49.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 01:51 PM, Steven Rostedt wrote:
> On Fri, 2011-03-11 at 19:37 +0100, Sam Ravnborg wrote:
>> On Fri, Mar 11, 2011 at 01:31:53PM -0500, Mark Hounschell wrote:
>>> On 03/10/2011 04:54 PM, Steven Rostedt wrote:
>>>> On Thu, Mar 10, 2011 at 03:27:00PM -0500, Mark Hounschell wrote:
>>>>> Between git bisect [good | bad ]s should I always "make clean" or can I
>>>>> count on the build system to take care of everything properly?
>>>>
>>>
>>> I'm trying to bisect between 2.6.35 and 2.6.36. What have I done wrong?
>>> Here is exactly what I've done. Why after my second "git bisect bad" do
>>> I get a Makefile for 2.6.35-rc1 and then after the fourth I get a Makefile
>>> for 2.6.34??
>>
>> The development is not linear.
>> So you see a commit developed on top of 2.6.34 that was included in 2.6.35.
>> This is normal.
> 
> Right.
> 
> Mark, don't be embarrassed, this is a common question for those that
> start using git bisect. Because of the way git merges branches, you may
> end up in an old version of a kernel, while looking between two newer
> versions.
> 
> 
> 
>     v2.6.36
>         |
>         +
>         |\
>         | \
> v2.6.35 +  \
>         |   +---- developers branch
>         |  /
>         | /
>         |/
>         +--- v 2.6.34
>         |
> 
> If a developer branched off of 2.6.34 and then his work got merged after
> v2.6.35, your bisect may easily go into that developers branch between
> 2.6.35 and 2.6.36, where you will suddenly see 2.6.34 appear and
> disappear within bisect iterations. IOW, don't trust what you see in the
> Makefile ;)
> 
> Understand?
> 

Understood. I was starting to think it was me. Thanks.

Mark
