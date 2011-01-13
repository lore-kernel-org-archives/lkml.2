Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667Ab1AMUJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 15:09:07 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56161 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933472Ab1AMUJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 15:09:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=s5ogyPurhZM6DAAZmW93ariAzV5e5ftaIWz4ZOO7YxlZJbrtJtXvREo18LalHpEpJI
         N58zMWiZFwcHWxAlg/wxc5/6nP9K+UeYw/Ct3vsemGj4IVIE0tm4yp7dRSaMUFSteHgT
         QLR/4x3XcyRuSLdI0rokrDxXhkdH7iV97ZBmg=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        lkml <linux-kernel@vger.kernel.org>, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH] perf-probe: make "perf-probe -L <function>" display the absolute path and absolute line number
References: <m38vyp85qv.fsf@gmail.com> <4D2EDBE4.3060608@hitachi.com>
Date: Thu, 13 Jan 2011 20:42:26 +0100
In-Reply-To: <4D2EDBE4.3060608@hitachi.com> (Masami Hiramatsu's message of
	"Thu, 13 Jan 2011 20:03:00 +0900")
Message-ID: <m34o9c8ual.fsf@gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:

> (2011/01/13 19:20), Franck Bui-Huu wrote:
>> From: Franck Bui-Huu <fbuihuu@gmail.com>
>> 
>> It should be more usefull to get the full location of the function
>
>> (absolute line number + full path) instead of repeating the name of
>> the function and the start line number given by the command line.
>> 
>> So we had before:
>> 
>>    $ perf probe -L schedule | head -n3
>>    <schedule:0>
>>          0  asmlinkage void __sched schedule(void)
>>          1  {
>> 
>> and now we get:
>> 
>>    $ perf probe -L schedule | head -n3
>>    </usr/src/debug/kernel-2.6.35.fc14/linux-2.6.35.x86_64/kernel/sched.c:3813>
>>          0  asmlinkage void __sched schedule(void)
>>          1  {
>
> Indeed, it could be useful for users to see where the function is...
>
> However, I think that should be optional, because the output lines
> have the relative line numbers from the function, and those numbers
> are important for users who want to probe a specific line by using
> function relative line numbers. e.g. "schedule:10"
>
> And with that option, I'd suggest to show absolute line numbers on each line.
>
>   $ perf probe -L schedule:0-1 --by-source
>   </usr/src/debug/kernel-2.6.35.fc14/linux-2.6.35.x86_64/kernel/sched.c:3813>
>      3813  asmlinkage void __sched schedule(void)
>      3814  {
>
> Or, just show source file as an additional information.
>
>   $ perf probe -L schedule:0-1
>   <schedule@/usr/src/debug/kernel-2.6.35.fc14/linux-2.6.35.x86_64/kernel/sched.c:0>
>         0  asmlinkage void __sched schedule(void)
>         1  {
>
> I just would like to keep the consistency of the output/input format.

Well, for consistency, I thought that the additional information (given
inside angle brackets) should always be the same: a full path and an
absolute line number which clearly identify which source file perf-probe
is listing.

-- 
		Franck
