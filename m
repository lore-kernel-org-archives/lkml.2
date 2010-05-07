Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab0EGTMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 15:12:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757966Ab0EGTMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 15:12:38 -0400
Message-ID: <4BE46613.9090509@redhat.com>
Date: Fri, 07 May 2010 15:12:19 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Robert Richter <robert.richter@amd.com>, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       peterz@infradead.org, efault@gmx.de, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf probe: Support DW_OP_call_frame_cfa in	debuginfo
References: <20100412171728.3790.98217.stgit@localhost6.localdomain6> <tip-a34a985499895a46a4dacff727d0fbc63cdc75e8@git.kernel.org> <20100507163321.GB15333@erda.amd.com> <4BE44AF4.3090303@redhat.com> <20100507183143.GB30926@ghostprotocols.net>
In-Reply-To: <20100507183143.GB30926@ghostprotocols.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Arnaldo Carvalho de Melo wrote:
> Em Fri, May 07, 2010 at 01:16:36PM -0400, Masami Hiramatsu escreveu:
>> Hi,
>>
>> Robert Richter wrote:
>>> On 15.04.10 07:29:18, tip-bot for Masami Hiramatsu wrote:
>>>> diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
>>>> index 2a27132..310ce89 100644
>>>> --- a/tools/perf/util/probe-finder.h
>>>> +++ b/tools/perf/util/probe-finder.h
>>>> @@ -42,6 +42,7 @@ struct probe_finder {
>>>>  	struct list_head	lcache;		/* Line cache for lazy match */
>>>>  
>>>>  	/* For variable searching */
>>>> +	Dwarf_CFI		*cfi;		/* Call Frame Information */
>>>
>>> I get the following complile error:
>>>
>>> gcc -o builtin-probe.o -c -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -Wformat-y2k -Wshadow -Winit-self -Wpacked -Wredundant-decls -Wstack-protector -Wstrict-aliasing=3 -Wswitch-default -Wswitch-enum -Wno-system-headers -Wundef -Wvolatile-register-var -Wwrite-strings -Wbad-function-cast -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wold-style-definition -Wstrict-prototypes -Wdeclaration-after-statement  -fstack-protector-all -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -Iutil/include -I/usr/include/elfutils -DDWARF_SUPPORT -DNO_NEWT_SUPPORT -DNO_LIBPERL -DSHA1_HEADER='<openssl/sha.h>'  builtin-probe.c
>>> In file included from builtin-probe.c:43:
>>> util/probe-finder.h:45: error: expected specifier-qualifier-list before ‘Dwarf_CFI’
>>> make: *** [builtin-probe.o] Error 1
>>> build script error: 2
>>>
>>> git grep only finds the following:
>>>
>>>  $ git grep Dwarf_CFI 
>>>  tools/perf/util/probe-finder.h: Dwarf_CFI               *cfi;           /* Call Frame Information */
>>>
>>> Am I missing something?
>>
>> Hmm, it seems that Dwarf_CFI is not defined in library.
>> (it is defined as a type in /usr/include/elfutils/libdw.h)
>> Could you tell me what version of elfutils you are using?
> 
> Masami-san,
> 
> 	If we are version dependant on that, we should disable this
> specific feature by doing one more compile test like we have for setting
> NO_DWARF, hopefully just a subset of DWARF support can be disabled due
> to this version dependency, right?

Agreed. I'll check that what version can support current perf probe.

Thank you,

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
