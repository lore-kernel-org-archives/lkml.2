Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670Ab0GOU5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 16:57:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46546 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab0GOU5T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 16:57:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:in-reply-to:mime-version:content-transfer-encoding
         :content-type:message-id:cc:x-mailer:from:subject:date:to;
        b=r1esq+opKO/Fwo1XMwU7W0OMpY4mo+KKOW+NEreVeAXRGqh97/sQH21ptYCECA3yPm
         fzxEiO5unYpIHOlbe1ZI/CmheMasrXqpaOeBIr4wxFzcPPntqyv4zE0QOaXTKYymgXv+
         44qoJm4twnicn4IKh09bMddQaCrXuhpU0dOE4=
References: <AANLkTinGoUml9PQ8w7flukqwF9V1ae-YafiDVQy6Q8gC@mail.gmail.com> <AANLkTimgn1Xa0YIwjC6xOfNDjlqJSQYy65ZvqCtlMWHD@mail.gmail.com> <1279100846.8592.53.camel@e102109-lin.cambridge.arm.com> <4C3D89AC.4040303@cs.helsinki.fi> <1279205891.6664.46.camel@e102109-lin.cambridge.arm.com> <AANLkTikJeA-bZEk652QwwT4iY21v5tr6RCzcZAZGgS8D@mail.gmail.com> <4C3F2F52.2050101@cs.helsinki.fi> <20100715162805.GA10240@brouette> <20100715191638.GA3694@brouette> <AANLkTim7SURv8DPTLC2JwOJvv1WMAR4mmyBp9XqXw_Py@mail.gmail.com> <20100715200012.GA4175@brouette> <F37ABC5E-E9F9-43BD-989E-4185135217D2@gmail.com> <AANLkTimWFTUZTh2-3Bavmwcum2joQluMEDmXx3xjyHqQ@mail.gmail.com>
In-Reply-To: <AANLkTimWFTUZTh2-3Bavmwcum2joQluMEDmXx3xjyHqQ@mail.gmail.com>
Mime-Version: 1.0 (iPhone Mail 8A293)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <7D54B468-8E2F-4381-A33A-BBF52C1E5087@gmail.com>
Cc: Damien Wyart <damien.wyart@free.fr>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "x86@kernel.org" <x86@kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
X-Mailer: iPhone Mail (8A293)
From: Zeno Davatz <zdavatz@gmail.com>
Subject: Re: kmemleak, cpu usage jump out of nowhere
Date: Thu, 15 Jul 2010 22:57:21 +0200
To: Pekka Enberg <penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.07.2010 um 22:50 schrieb Pekka Enberg <penberg@cs.helsinki.fi>:

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
>  git bisect start
>  git bisect good v2.6.34
>  git bisect bad v2.6.31-rc1 # or some other kernel you know to be bad
>  <compile, boot, and try to trigger the problem>
> 
> then
> 
>  git bisect bad # if you were able to trigger the problem
> 
> or
> 
>  git bisect good # if the problem doesn't exist
> 
> git will then find the next revision to test after which you do
> 
>  <compile, boot, and try to trigger the problem>
> 
> and repeat the "git bisect good/bad" step until git tells you it has
> found the offending commit.
> 
> There's more information on the git bisect man pages:
> 
> http://www.kernel.org/pub/software/scm/git/docs/git-bisect.html
> 
> Let me know if you need more help with this.

Ok, thanks for the guidance, will start some time tomorrow. Hope to make it in the morning.

Best
Zeno