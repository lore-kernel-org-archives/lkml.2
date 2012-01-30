Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab2A3GiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 01:38:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51867 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab2A3GiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 01:38:16 -0500
Message-ID: <4F263B6C.1050804@cn.fujitsu.com>
Date: Mon, 30 Jan 2012 14:40:44 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC][PATCH] tracing/module: Move tracepoint out of module.h
References: <1326754637.7642.177.camel@gandalf.stny.rr.com>	 <20120117095418.GG10397@elte.hu>	 <1326807145.17534.26.camel@gandalf.stny.rr.com>	 <20120118120711.GB14863@elte.hu>	 <1326909412.17534.91.camel@gandalf.stny.rr.com>	 <877h0jgx80.fsf@rustcorp.com.au>	 <1327545664.22710.78.camel@gandalf.stny.rr.com>	 <20120126102836.GD3853@elte.hu>	 <1327585945.22710.87.camel@gandalf.stny.rr.com>	 <20120126135504.GA13107@elte.hu>	 <1327586669.22710.89.camel@gandalf.stny.rr.com> <1327588606.22710.100.camel@gandalf.stny.rr.com>
In-Reply-To: <1327588606.22710.100.camel@gandalf.stny.rr.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-30 14:36:43,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-30 14:36:56,
	Serialize complete at 2012-01-30 14:36:56
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Thu, 2012-01-26 at 09:04 -0500, Steven Rostedt wrote:
>> [ Added Li who added the original tracepoint ]
>>
>> On Thu, 2012-01-26 at 14:55 +0100, Ingo Molnar wrote:
>>> * Steven Rostedt <rostedt@goodmis.org> wrote:
>>>
>>>> On Thu, 2012-01-26 at 11:28 +0100, Ingo Molnar wrote:
>>>>
>>>>> How much more do we save if we move all of try_module_get() out 
>>>>> of line? It still seems a rather thick inline function with 
>>>>> preempt section and all. I'd *really* suggest that it should all 
>>>>> be uninlined.
>>>>>
>>>>
>>>> Here's the #'s
>>>>
>>>>    text	   data	    bss	    dec	    hex	filename
>>>> 7489488	2249584	9719808	19458880	128eb40	vmlinux-prepatch
>>>>    text	   data	    bss	    dec	    hex	filename
>>>> 7482458	2248048	9719808	19450314	128c9ca	vmlinux-postpatch
>>>>    text	   data	    bss	    dec	    hex	filename
>>>> 7477393	2248080	9719808	19445281	128b621	vmlinux-updatedpatch
> 
> 
> New numbers:
> 
>    text	   data	    bss	    dec	    hex	filename
> 7476509	2248048	9719808	19444365	128b28d	vmlinux-updatedpatch2
> 
> Just 916 bytes savings more. But gets rid of the hot path changes.
> 
> New patch below: (and the IP still works)
> 
> -- Steve
> 

This looks good to me. Thanks!

--
Li Zefan
