Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab0E3IKz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 04:10:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab0E3IKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 04:10:53 -0400
Message-ID: <4C021D7E.1060705@redhat.com>
Date: Sun, 30 May 2010 11:10:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Stefan Hajnoczi <stefanha@gmail.com>, linux-perf-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: Re: Perf trace event parse errors for KVM events
References: <20100526123443.GB8905@stefan-thinkpad.transitives.com>	 <AANLkTil8BiuzrmacV7Lpx1wES0EvLSiVmcfwtSY6Zis2@mail.gmail.com>	 <1275083157.22648.593.camel@gandalf.stny.rr.com>	 <4C00FF9B.9000107@redhat.com> <1275139177.22648.610.camel@gandalf.stny.rr.com>
In-Reply-To: <1275139177.22648.610.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2010 04:19 PM, Steven Rostedt wrote:
> On Sat, 2010-05-29 at 14:50 +0300, Avi Kivity wrote:
>    
>> On 05/29/2010 12:45 AM, Steven Rostedt wrote:
>>      
>>> On Fri, 2010-05-28 at 17:42 +0100, Stefan Hajnoczi wrote:
>>>
>>>        
>>>> I get parse errors when using Steven Rostedt's trace-cmd tool, too.
>>>>
>>>> Any ideas what is going on here?  I can provide more info (e.g. trace
>>>> files) if necessary.
>>>>
>>>>          
>>> Does trace-cmd fail on the same tracepoints? Have you checkout the
>>> latest code?.
>>>
>>> I do know it fails on some of the KVM tracerpoints since the formatting
>>> they use is obnoxious.
>>>
>>>
>>>        
>> Isn't there a binary trace for this?
>>
>>      
> The pretty printing from the kernel handles this fine. But there's
> pressure to pass the format to userspace in binary and have the tool
> parse it. Currently it uses the print fmt to figure out how to parse.
>
> Using one of the examples that Stefan showed:
>
> kvmmmu/kvm_mmu_get_page: print fmt: "%s %s", ({ const char *ret =
> p->buffer + p->len; static const char *access_str[] = { "---", "--x",
> "w--", "w-x", "-u-", "-ux", "wu-", "wux" }; union kvm_mmu_page_role
> role; role.word = REC->role; trace_seq_printf(p, "sp gfn %llx %u%s q%u%s
> %s%s" " %snxe root %u %s%c", REC->gfn, role.level, role.cr4_pae ? "
> pae" : "", role.quadrant, role.direct ? " direct" : "",
> access_str[role.access], role.invalid ? " invalid" : "", role.nxe ? "" :
> "!", REC->root_count, REC->unsync ? "unsync" : "sync", 0); ret; }),
> REC->created ? "new" : "existing"
>
>
> You need a full C parser/interpreter to understand the above.
>    

Right.  The tools can fall back to %x/%s based on the structure 
descriptor if they can't parse the format string.

-- 
error compiling committee.c: too many arguments to function

