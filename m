Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab0DURy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 13:54:28 -0400
Received: from relay3.sgi.com ([192.48.152.1]:40834 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756033Ab0DURy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 13:54:27 -0400
Message-ID: <4BCF3BCE.7050906@sgi.com>
Date: Wed, 21 Apr 2010 10:54:22 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Hedi Berriche <hedi@sgi.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] init: Provide a kernel start parameter to increase
 pid_max v2
References: <4BCE579C.5070100@sgi.com> <4BCE5A73.3000904@sgi.com> <20100421102350.4c222e6b@lxorguk.ukuu.org.uk> <20100421165934.GN16427@zorg.emea.sgi.com> <4BCF336B.1050706@redhat.com>
In-Reply-To: <4BCF336B.1050706@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Rik van Riel wrote:
> On 04/21/2010 12:59 PM, Hedi Berriche wrote:
>> On Wed, Apr 21, 2010 at 10:20 Alan Cox wrote:
>> |>  of 32k will not be enough.  A system with 1664 CPU's, there are 
>> 25163 processes
>> |>  started before the login prompt.  It's estimated that with 2048 
>> CPU's we will pass
>> |
>> | Is that perhaps the bug not the 32K limit?
>>
>> Doubt it: I just checked on an *idle* 1664 CPUs system and I can see 
>> 26844
>> tasks, all but few being kernel threads.
> 
> That is 15 kernel threads per CPU.
> 
> Reducing the number of kernel threads sounds like a
> useful thing to do.

I'm doing more research but all the udev modprobes seem to spawn
quite a few tasks.  And even though they go away, when the pid
pool is limited, I'm guessing many of them are waiting.

On the last test I did yesterday, the pid # was up in the 77000
range at the login prompt (I started the 1664 cpu system with
pid_max=128k).
