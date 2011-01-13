Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab1AMNUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 08:20:18 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59977 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285Ab1AMNUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 08:20:14 -0500
Date: Thu, 13 Jan 2011 11:20:03 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [BUG] perf sched broken
Message-ID: <20110113132003.GA17903@ghostprotocols.net>
References: <AANLkTim=jawJyBj0iFd0r4-LCKzvjFW+NddzJMD5GUB9@mail.gmail.com> <4D2E5B33.2080305@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2E5B33.2080305@linux.vnet.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 12, 2011 at 05:53:55PM -0800, Corey Ashford escreveu:
> On 01/12/2011 01:29 AM, Stephane Eranian wrote:
>> Hi,
>>
>> I am trying to use perf sched from tip-x86 but it fails for all my attempts.
>>
>> First of, I think the event list is stale. This is not so much the
>> events themselves
>> but rather the flags.
>>
>> Looks to me like the :r modifier is not supported anymore, so a patch like the
>> one below is needed. That helps collect a trace. But then, you can dump
>> the trace.
>
> After looking at this in more detail, I agree with Stephane: the 'r'  
> option appears to only be supported for hardware breakpoint events.  My  
> patch just causes the 'r' to be properly processed and rejected as a  
> legal option.

And thus broke 'perf sched' because it uses it, thanks to this
discussion we figured out that 'perf sched' shouldn't be using it :)

So thank you and Stephane, I'm applying his patch. That ':r' stuff makes
no sense and I couldn't find it being parsed anywhere, historical
bitrotted baggage it seems.

Thanks a lot!

- Arnaldo
