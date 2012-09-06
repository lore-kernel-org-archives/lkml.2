Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab2IFWXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 18:23:00 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:56445 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751461Ab2IFWWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 18:22:49 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+0+KRRwry0VLuA/3K5CMj7byz8J8BNH7W1HkOer1
	+0r+YueZqhaG4L
Message-ID: <50492235.40106@gmx.de>
Date: Fri, 07 Sep 2012 00:22:45 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120902 Thunderbird/15.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: does gcc gives a false warning in kernel/trace/trace_events_filter.c
 ?
References: <50432132.90307@gmx.de>  <1346864883.27919.56.camel@gandalf.local.home> <5048D0E5.20103@gmx.de> <1346952676.1680.44.camel@gandalf.local.home>
In-Reply-To: <1346952676.1680.44.camel@gandalf.local.home>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 07:31 PM, Steven Rostedt wrote:
> On Thu, 2012-09-06 at 18:35 +0200, Toralf Förster wrote:
> 
>> I filed a bug report
>>
>> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=54495
>> and got this answer : 
>>
>> --- Comment #1 from Hans-Peter Nilsson <hp at gcc dot gnu.org> 2012-09-05 22:14:00 UTC ---
>> But if the call to ftrace_function_filter_re sets re_cnt to 0, then ret indeed
>> will be used uninitialized AFAICT.  What am I missing?
>>
> 
> That I think we are looking at two different code bases ;-)
> 
> I've been looking at what's been queued for 3.7 and not what's in
> mainline. If you look at tip/master, or even linux-next, you'll find:
> 
> commit 92d8d4a8b0f "tracing/filter: Add missing initialization"
> 
> Which does:
> 
>  static int __ftrace_function_set_filter(int filter, char *buf, int len,
>                                         struct function_filter_data *data)
>  {
> -       int i, re_cnt, ret;
> +       int i, re_cnt, ret = -EINVAL;
>         int *reset;
>         char **re;
> 
> 
> Thus, you were correct. This could have been marked urgent, but as it
> isn't that big of a deal I just queued it for the next merge window.
> 
> -- Steve
> 
> 
> 
ah - thx
:-)

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
