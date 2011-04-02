Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab1DBBht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 21:37:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49957 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753451Ab1DBBhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 21:37:47 -0400
Message-ID: <4D967ECF.8050802@cn.fujitsu.com>
Date: Sat, 02 Apr 2011 09:41:35 +0800
From: liubo <liubo2009@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC PATCH] Trace: use unsigned long long in trace print frames
References: <4D9573DB.4010009@cn.fujitsu.com> <1301665762.2160.22.camel@gandalf.stny.rr.com>
In-Reply-To: <1301665762.2160.22.camel@gandalf.stny.rr.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-02 09:36:11,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-02 09:36:11,
	Serialize complete at 2011-04-02 09:36:11
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2011 09:49 PM, Steven Rostedt wrote:
> On Fri, 2011-04-01 at 14:42 +0800, liubo wrote:
>> While adding tracepoint for btrfs, I got a problem:
>>
>> btrfs uses some macros with "ULL" type, but tracepoint's macros,
>> __print_[flags,symbols](), only have "unsigned long", so on 32bit box
>> there will be 64->32 truncate WARNINGs when compiling.
>>
>> Here I'm inclined to make the replacement to clear those WARNINGs.
> 
> Hmm, I don't like this. unsigned long is a natural word for
> architectures, I don't want to have 32 bit suffer because one user is
> doing something with ULL.
> 
> A better solution is to add a trace_print_flags_u64 or something, that
> can be used for cases that u64 is needed. For archs were sizeof(long) ==
> sizeof(u64) we can have the two macros/structs be the same.
> 

All right, a u64 specific one is also in my mind. :)

thanks,
liubo

> -- Steve
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

