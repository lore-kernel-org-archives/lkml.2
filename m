Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751129Ab0EGEKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 00:10:17 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:40807 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab0EGEKP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 00:10:15 -0400
MIME-Version: 1.0
In-Reply-To: <20100507034510.GA20935@thegnar.org>
References: <20100505202826.GB7450@linux.intel.com>
	 <Pine.LNX.4.44L0.1005051705200.1885-100000@iolanthe.rowland.org>
	 <z2ta55d774e1005051437heb584584q6afca0b4b254d5d0@mail.gmail.com>
	 <20100505234755.GI29604@atomide.com>
	 <20100506134015.GA23426@srcf.ucam.org>
	 <20100506170151.GA30928@atomide.com>
	 <20100506170956.GA28104@srcf.ucam.org>
	 <20100507034510.GA20935@thegnar.org>
Date: Thu, 6 May 2010 21:10:14 -0700
Message-ID: <s2hd6200be21005062110p27491d9l16f93f1d6d713e36@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: markgross@thegnar.org
Cc: Matthew Garrett <mjg@redhat.com>, Tony Lindgren <tony@atomide.com>,
       Brian Swetland <swetland@google.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       mark gross <mgross@linux.intel.com>, Len Brown <len.brown@intel.com>,
       linux-doc@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 6, 2010 at 8:45 PM, mgross <markgross@thegnar.org> wrote:
> On Thu, May 06, 2010 at 06:09:56PM +0100, Matthew Garrett wrote:
>> On Thu, May 06, 2010 at 10:01:51AM -0700, Tony Lindgren wrote:
>>
>> > Or are you suspending constantly, tens of times per minute even if
>> > there's no user activity?
>>
>> In this case you'd be repeatedly trying to suspend until the modem
>> driver stopped blocking it. It's pretty much a waste.
>
>
> lets not go off in the weeds for the wrong things now.  The answer to
> the retry is at most one time.  The first time would be blocked, then
> the suspend enable would need to re-enabled under user mode control that
> would, buy that time, know it has to ack to the modem to stop rejecting
> the suspend attempt.
>

This is incorrect in the general case. User-space has no way of
knowing which driver blocked suspend or when it will stop blocking
suspend.

-- 
Arve Hjønnevåg
