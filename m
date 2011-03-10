Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab1CJGl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 01:41:28 -0500
Received: from mga02.intel.com ([134.134.136.20]:2516 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab1CJGl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 01:41:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,294,1297065600"; 
   d="scan'208";a="718538223"
Message-ID: <4D787294.4040906@linux.intel.com>
Date: Wed, 09 Mar 2011 22:41:24 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        mrubin@google.com
Subject: Re: [PATCH trace-cmd 3/3] Revert "trace-cmd: Use conditional assignment
 of CC and AR"
References: <1299715137-22768-1-git-send-email-dhsharp@google.com>	 <1299715137-22768-3-git-send-email-dhsharp@google.com>	 <4D7828F9.7000906@linux.intel.com>	 <1299720997.15854.276.camel@gandalf.stny.rr.com>	 <4D783038.8080103@linux.intel.com>	 <AANLkTikHy1pZP0=cpmSD_HG-jeJvgne3u2ivOif6DHP8@mail.gmail.com>	 <1299725486.15854.281.camel@gandalf.stny.rr.com> <1299727594.15854.310.camel@gandalf.stny.rr.com>
In-Reply-To: <1299727594.15854.310.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2011 07:26 PM, Steven Rostedt wrote:
> On Wed, 2011-03-09 at 21:51 -0500, Steven Rostedt wrote:
>
>> I'll play with some other make tricks and see if I can come up with a
>> better solution.
>
> OK, it didn't take me long to come up with "Makefiles suck" ;)

Yeah, that little tidbit I sent took longer to come up with than it 
should have :/

>
> But I did come up with a solution:
>
> ifneq ("$(origin CC)", "environment")
> CC = gcc
> endif
>
> CC := $(CROSS_COMPILE)$(CC)

Why do we want to force CC=gcc? Isn't the right thing to make your OS 
setup cc to point to your preferred compiler since it is known to be the 
default for make?

On Ubuntu, cc -> gcc
On Fedora 13, cc -> ccache

seems strange to force it to be gcc when users/distros have gone through 
the trouble to set it up on their system.


> This wont let make CC=xx work unless I also add a:
>
> ifneq ("$(origin CC)", "command line")
>
> around the above if, but do we care?
>

This starts to get to the point where others looking at it will choke on 
the expert Makefile usage.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
