Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab2AMODA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 09:03:00 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58366 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab2AMOC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 09:02:58 -0500
X-AuditID: b753bd60-98c60ba00000359c-c7-4f10398e4247
X-AuditID: b753bd60-98c60ba00000359c-c7-4f10398e4247
Message-ID: <4F103975.8070505@hitachi.com>
Date: Fri, 13 Jan 2012 23:02:29 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH v8 3.2.0-rc5 9/9] perf: perf interface for uprobes
References: <20111216122756.2085.95791.sendpatchset@srdronam.in.ibm.com> <20111216122951.2085.95511.sendpatchset@srdronam.in.ibm.com> <4F06D22D.9060906@hitachi.com> <20120109112236.GA10189@linux.vnet.ibm.com> <4F0F8F41.3060806@hitachi.com> <20120113051447.GD10189@linux.vnet.ibm.com>
In-Reply-To: <20120113051447.GD10189@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/01/13 14:14), Srikar Dronamraju wrote:
>>>>> +#define DEFAULT_FUNC_FILTER "!_*"
>>>>
>>>> This is a hidden rule for users ... please remove it.
>>>> (or, is there any reason why we need to have it?)
>>>>
>>>
>>> This is to be in sync with your commit
>>> 3c42258c9a4db70133fa6946a275b62a16792bb5
>>
>> I see, but that commit also provides filter option for changing
>> the function filter. Here, user can not change the filter rule.
>>
>> I think, currently, we don't need to filter any function by name
>> here, since the user obviously intends to probe given function :)
> 
> Actually this was discussed in LKML here
> https://lkml.org/lkml/2010/7/20/5, please refer the sub-thread.
> 
> Basically without this filter, the list of functions is too large
> including labels, weak, and local binding function which arent traced.

If you mean that this function is used for listing
function (perf probe -F), that's true. But it seems
this convert_name_to_addr() is used just for converting
given function.

As far as I can understand, this means that the user
specifies an actual and single function for the probe point.

If so, there is no need to list up all functions - just
find a function which has the given symbol. I guess, it
is enough to set given function name to
available_func_filter as below. :)

available_func_filter = function

then, map__load() loads only the function which has the
given function name, doesn't it? :)

>>>
>>> If the user provides a symbolic link, convert_name_to_addr would get the
>>> target executable for the given executable. This would handy if we were
>>> to compare existing probes registered on the same application using a
>>> different name (symbolic links). Since you seem to like that we register
>>> with the name the user has provided, I will just feed address here.
>>
>> Hmm, why do we need to compare the probe points? Of course, event-name
>> conflict should be solved, but I think it is acceptable that user puts
>> several probes on the same exec:vaddr. Since different users may want
>> to use it concurrently bit different ways.
>>
> 
> The event-names themselves are generated from the probe points. There is
> no problem as such if two or more people use a different symlinks to
> create probes. I was just trying to see if we could solve the
> inconsitency where we warn a person if he is trying to place a probe on
> a existing probe but allow the same if he is trying to place a probe on
> a existing probe using a different symlink.
> 
> This again I have changed as you suggested in the latest patches that I
> sent this week.

Yeah, I've checked out it. Thanks:)


Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
