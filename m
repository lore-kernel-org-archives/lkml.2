Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab0C2WHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 18:07:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859Ab0C2WHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 18:07:33 -0400
Message-ID: <4BB1240F.1050300@redhat.com>
Date: Mon, 29 Mar 2010 18:05:03 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH -tip 5/7] perf probe: Query basic types from debuginfo
References: <20100329203736.2577.56018.stgit@localhost6.localdomain6> <20100329203829.2577.44718.stgit@localhost6.localdomain6> <20100329205143.GQ3625@ghostprotocols.net> <4BB119F8.7020206@redhat.com> <20100329215009.GA2851@ghostprotocols.net>
In-Reply-To: <20100329215009.GA2851@ghostprotocols.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Arnaldo Carvalho de Melo wrote:
> Em Mon, Mar 29, 2010 at 05:22:00PM -0400, Masami Hiramatsu escreveu:
>> Arnaldo Carvalho de Melo wrote:
>>> Em Mon, Mar 29, 2010 at 04:38:29PM -0400, Masami Hiramatsu escreveu:
>>> Question, should we use the equivalent to panic'ing the kernel in the
>>> userspace bits in tools/?
> 
>>> I tend to see all code there as potentially part of a library, i.e. to
>>> be callable by some unantecipated new tool or library that would rather
>>> receive a return value telling it that the operation can't be performed
>>> for some reason so that it can inform the user instead of having the
>>> whole tool exit to the command line.
>>
>> OK, so that you want to see 
>>
>> ret = library_func();
>> if (ret < 0)	/* Something wrong happened */
>> 	return ret;
>>
>> instead of 
>>
>> library_func();
>> hopefully_executed_next_func();
> 
> Exactly. That was my _suggestion_ :-)
>  
>>> It may well be that some specific operation needs lots of resources but
>>> many other don't, panic'c because the one that requires lots of
>>> resources can't be performed, bringing down a gui/tui is really nasty.
>>
>> Hmm, agreed. But I'd like to have some API for storing dying^H^H^H^H^Herror
>> message. (maybe can we use setjump/longjump approach - like try/cache - for die()?)
> 
> Can't we do just as we do in the kernel and propagate the error back to
> callers? All the way to userspace, that in this case would be the user
> instead of an app started by a user?  :-)
> 
> Wrt api for storing messages, we have pr_{warning,error,debug}, etc, in
> the TUI mode it is even redirected to the bottom line and I plan to have
> them get into something browseable if the user wants to see the last pr_
> messages.

Ah, that's very nice:)
OK, I'll try to use it and remove all 'die()'s.

Thank you!

> 
> IOW, just act like you're writing kernel code, that will make it more
> likely that people that are used to writing code like that will feel at
> ease while hacking tools/.
> 
> - Arnaldo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
