Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934210Ab0J2RSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 13:18:20 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:3679 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934200Ab0J2RST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 13:18:19 -0400
Message-ID: <4CCB01D1.2050004@caviumnetworks.com>
Date: Fri, 29 Oct 2010 10:18:09 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
        rth@redhat.com, "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, dsd@laptop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] jump label: disable due to compiler bug
References: <cover.1288212485.git.jbaron@redhat.com>	 <2d1b1d5d2b3930e1acb063cefffbcb2faf049854.1288212486.git.jbaron@redhat.com>	 <ce4ff595-f9d1-4c17-b68e-82739b07ad3e@email.android.com>	 <20101028141757.GA2875@redhat.com> <4CC9C724.3020004@caviumnetworks.com>	 <20101028201112.GA4792@redhat.com> <20101029063450.GE29463@elte.hu>	 <1288354687.18238.433.camel@gandalf.stny.rr.com>	 <20101029122230.GA25663@elte.hu>	 <1288356418.18238.454.camel@gandalf.stny.rr.com>	 <20101029133524.GA23916@Krystal> <1288369108.29632.1.camel@gandalf.stny.rr.com>
In-Reply-To: <1288369108.29632.1.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Oct 2010 17:18:44.0206 (UTC) FILETIME=[56E3E0E0:01CB778D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2010 09:18 AM, Steven Rostedt wrote:
> On Fri, 2010-10-29 at 09:35 -0400, Mathieu Desnoyers wrote:
>> * Steven Rostedt (rostedt@goodmis.org) wrote:
>
>>> Then in the code have:
>>>
>>> -#if defined(CC_HAVE_ASM_GOTO)&&  defined(CONFIG_HAVE_ARCH_JUMP_LABEL)
>>> +#if defined(CC_HAVE_ASM_GOTO)&&  defined(CONFIG_HAVE_ARCH_JUMP_LABEL) \
>>
>> Technically, you could remove the dependency on
>> "defined(CONFIG_HAVE_ARCH_JUMP_LABEL)", because it is now dealt with at
>> the Kconfig level (CONFIG_JUMP_LABEL depends on it).
>
> Yeah, I noticed that just after hitting send.
>
>>
>>> +	&&  defined(JUMP_LABEL)
>>
>> this would be defined(CONFIG_JUMP_LABEL)
>
> Yep, this too, but thanks for pointing it out.
>
>
>>
>> The rest looks fine,
>
> Great, can I add your acked-by then?
>

I hate to continue beating a dead horse, but RTH just committed the GCC 
patch, and it will be part of GCC-4.5.2 and later.

Should this knowledge be builtin to the jump label enabling calculus?

David Daney

