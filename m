Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab0FAMjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:39:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328Ab0FAMjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:39:14 -0400
Message-ID: <4C04FF65.8020408@redhat.com>
Date: Tue, 01 Jun 2010 15:39:01 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Stefan Hajnoczi <stefanha@gmail.com>, linux-perf-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Darren Hart <darren@dvhart.com>
Subject: Re: Perf trace event parse errors for KVM events
References: <20100526123443.GB8905@stefan-thinkpad.transitives.com>	 <AANLkTil8BiuzrmacV7Lpx1wES0EvLSiVmcfwtSY6Zis2@mail.gmail.com>	 <1275083157.22648.593.camel@gandalf.stny.rr.com>	 <4C00FF9B.9000107@redhat.com>	 <1275139177.22648.610.camel@gandalf.stny.rr.com>	 <4C021D7E.1060705@redhat.com>	 <1275228182.15884.1.camel@gandalf.stny.rr.com>	 <4C027131.2010309@redhat.com>	 <1275233656.15884.4.camel@gandalf.stny.rr.com>	 <4C04C739.8050607@redhat.com> <1275393544.15884.19.camel@gandalf.stny.rr.com>
In-Reply-To: <1275393544.15884.19.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2010 02:59 PM, Steven Rostedt wrote:
>
>> One concern is performance.  Traces tend to be long, and running python
>> code on each line will be slow.
>>
>> If trace-cmd integrates a pager and a search mechanism that looks at the
>> binary data instead of the text, we could format only the lines that are
>> displayed.  But that is going to be a lot of work and I don't think it's
>> worth the effort.
>>
>>      
> Every event gets its own ID. The plugin registers a callback to that ID.
> When the ID is hit, the plugin is executed on that event to display its
> binary format.
>
> This is done after the data has been saved in binary format to a file.
> It may slow down the executing of reading a data file, but it does not
> affect the running of the trace one bit.
>    

I meant that viewing would be slowed down.  It's an important part of 
using ftrace!

How long does the Python formatter take to process 100k or 1M events?

-- 
error compiling committee.c: too many arguments to function

