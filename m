Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab0DETtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 15:49:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:29834 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756165Ab0DETtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 15:49:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,366,1267430400"; 
   d="scan'208";a="610400661"
Message-ID: <4BBA3EAB.6010800@linux.intel.com>
Date: Mon, 05 Apr 2010 12:48:59 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: david@lang.hm
CC: paulmck@linux.vnet.ibm.com, Dominik Brodowski <linux@dominikbrodowski.net>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: A few questions and issues with dynticks, NOHZ and powertop
References: <20100403223328.GA4507@comet.dominikbrodowski.net> <Pine.LNX.4.44L0.1004041110010.2750-100000@netrider.rowland.org> <20100404163924.GA18428@comet.dominikbrodowski.net> <20100404204725.GC2644@linux.vnet.ibm.com> <20100404233702.GA24102@linux.vnet.ibm.com> <4BB95C85.80205@linux.intel.com> <20100405042222.GD2644@linux.vnet.ibm.com> <4BB9F657.4050901@linux.intel.com> <20100405151401.GA2525@linux.vnet.ibm.com> <4BBA0AC5.1080905@linux.intel.com> <alpine.DEB.2.00.1004051137160.12764@asgard.lang.hm>
In-Reply-To: <alpine.DEB.2.00.1004051137160.12764@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/5/2010 11:44, david@lang.hm wrote:
> On Mon, 5 Apr 2010, Arjan van de Ven wrote:
>
>> On 4/5/2010 8:14, Paul E. McKenney wrote:
>>> So the main issue is that for many workloads, it is best to run full
>>> bore
>>> and get done quickly, thus allowing the entire machine to be powered
>>> down?
>>
>> yep
>
> Race To Idle works extremely well in a batch type situation where there
> is not going to be any work to do after you finish what you have.
>
> It doesn't work quite as well if you are going to have new work to do in
> the near future.
>
> You cannot power down the entire machine if you have to look for user
> input.
>
> It takes time (and power) to shut down and start back up, if you are
> going to have more work to do before you can make the complete cycle
> (and save more power than it costs to make the transitions), it's best
> to stay at full power, even if you are idle.

for the things we're talking about here (memory controllers etc) we're talking
about single to low double digit microseconds (or even less) of time to go up and down.
Many of the things you talk about are in the millisecond timeframe.

