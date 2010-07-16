Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935797Ab0GPHhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 03:37:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52552 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935713Ab0GPHhu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 03:37:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UzwoYIhcphRLCeuUhBScvrHqmE8j0bt/eNHtLEXoXMwVVoAj8mPbd3lKgGN4uJCIaq
         +Efp0oZPjp9QaYVnNMI3P9CTuhsY+UBweDsN7fBFXXvONkvUtSx8c5hW1vnsFV9q+AEi
         ZyeEpsMHPMm4imiqhTHXDBYEX/cRRDDn1+S4U=
MIME-Version: 1.0
In-Reply-To: <AANLkTimWFTUZTh2-3Bavmwcum2joQluMEDmXx3xjyHqQ@mail.gmail.com>
References: <AANLkTinGoUml9PQ8w7flukqwF9V1ae-YafiDVQy6Q8gC@mail.gmail.com>
	<AANLkTimgn1Xa0YIwjC6xOfNDjlqJSQYy65ZvqCtlMWHD@mail.gmail.com>
	<1279100846.8592.53.camel@e102109-lin.cambridge.arm.com>
	<4C3D89AC.4040303@cs.helsinki.fi>
	<1279205891.6664.46.camel@e102109-lin.cambridge.arm.com>
	<AANLkTikJeA-bZEk652QwwT4iY21v5tr6RCzcZAZGgS8D@mail.gmail.com>
	<4C3F2F52.2050101@cs.helsinki.fi>
	<20100715162805.GA10240@brouette>
	<20100715191638.GA3694@brouette>
	<AANLkTim7SURv8DPTLC2JwOJvv1WMAR4mmyBp9XqXw_Py@mail.gmail.com>
	<20100715200012.GA4175@brouette>
	<F37ABC5E-E9F9-43BD-989E-4185135217D2@gmail.com>
	<AANLkTimWFTUZTh2-3Bavmwcum2joQluMEDmXx3xjyHqQ@mail.gmail.com>
Date: Fri, 16 Jul 2010 09:37:47 +0200
Message-ID: <AANLkTinqZs11kXx5afD4RDsVsy551S5lMnyAUwhdX2Sg@mail.gmail.com>
Subject: Re: kmemleak, cpu usage jump out of nowhere
From: Zeno Davatz <zdavatz@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Damien Wyart <damien.wyart@free.fr>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "x86@kernel.org" <x86@kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 10:50 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Thu, Jul 15, 2010 at 11:38 PM, Zeno Davatz <zdavatz@gmail.com> wrote:
>> Am 15.07.2010 um 22:00 schrieb Damien Wyart <damien.wyart@free.fr>:
>>
>>>>> For now, I can't reproduce the problem with CONFIG_NO_BOOTMEM disabled ;
>>>>> with the option and rc5 the problem was happening quite quickly after
>>>>> boot and normal use of the machine. So it seems I can confirme what Zeno
>>>>> has seen and I hope this will give a hint to debug the problem. I guess
>>>>> this has not been reported that much because many testers might not have
>>>>> enabled CONFIG_NO_BOOTMEM... Maybe the scheduler folks could test their
>>>>> benchmark with a kernel having this option enabled?
>>>
>>> * Pekka Enberg <penberg@cs.helsinki.fi> [2010-07-15 22:50]:
>>>> To be honest, the bug is bit odd. It's related to boot-time memory
>>>> allocator changes but yet it seems to manifest itself as a scheduling
>>>> problem. So if you have some spare time and want to speed up the
>>>> debugging process, please test v2.6.34 and v2.6.35-rc1 with
>>>> CONFIG_NO_BOOTMEM and if former is good and latter is bad, try to see
>>>> if you can identify the offending commit with "git bisect."
>>>
>>> Not sure I will have enough time in the coming days (doing that remotely
>>> is fishy since ssh access is almost stuck when the problem occurs); if
>>> Zeno can and would like to do it, maybe this could be done faster.
>>>
>>> As the scheduler is now very well instrumented (many debugging features
>>> are available), reproducing the bug on a test platform (it happens quite
>>> quickly for me) might also give some hints. So testers, if you have
>>> time, please test 2.6.35-rc5 with CONFIG_NO_BOOTMEM on a Core i7 and see
>>> if you can reproduce the problem!
>>
>> Will try to do so. Can you point me to the git bisect howto with the versions you want.
>
> Cool. So like I said, you first want to test 2.6.34 to find a known
> good version. Please remember to make sure you have CONFIG_NO_BOOTMEM
> enabled. You can also try to speed up the process by testing
> 2.6.35-rc1 which is likely to include the offending commit. That's not
> strictly necessary as long as you are sure that you have some
> 2.6.35-rc kernel that's bad.
>
> After that, bisecting is as simple as:
>
>  git bisect start
>  git bisect good v2.6.34
>  git bisect bad v2.6.31-rc1 # or some other kernel you know to be bad
>  <compile, boot, and try to trigger the problem>
>
> then
>
>  git bisect bad # if you were able to trigger the problem
>
> or
>
>  git bisect good # if the problem doesn't exist
>
> git will then find the next revision to test after which you do
>
>  <compile, boot, and try to trigger the problem>
>
> and repeat the "git bisect good/bad" step until git tells you it has
> found the offending commit.
>
> There's more information on the git bisect man pages:
>
> http://www.kernel.org/pub/software/scm/git/docs/git-bisect.html
>
> Let me know if you need more help with this.

The next RC again hangs on me:

http://www.flickr.com/photos/zrr/4798744700/sizes/l/

Gruss
Zeno
