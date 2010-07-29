Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab0G2Jsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 05:48:38 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49906 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab0G2Jsf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 05:48:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=NEeSO4uhb4mC53FXKwfnXH1Ivp4xiN4kLN3iUcwkBOIMEDmMd8frRAmwXq5koor45O
         vmn7XUF9AwR0jYz24HFA6zdy1sqANgy1jdG8NkMxaF6SMAIoZdjHep4ujF4zitjAN3Gp
         g4+0Ac3FdHx7jRtNnNHVgdWvF0qtPjihzi7O4=
MIME-Version: 1.0
In-Reply-To: <AANLkTikq=v_7dbW1Z+LUbTKmnezKT0cd8ZTErwP1X0C+@mail.gmail.com>
References: <20100727200804.2F40.A69D9226@jp.fujitsu.com> <AANLkTin47_htYK8eV-6C4QkRK_U__qYeWX16Ly=YK-0w@mail.gmail.com> 
	<20100728135850.7A92.A69D9226@jp.fujitsu.com> <AANLkTi=fk8B-TnC6m3AoLT7k_G239rMaQA1COwHLxwRM@mail.gmail.com> 
	<AANLkTikq=v_7dbW1Z+LUbTKmnezKT0cd8ZTErwP1X0C+@mail.gmail.com>
From: dave b <db.pub.mail@gmail.com>
Date: Thu, 29 Jul 2010 19:48:14 +1000
Message-ID: <AANLkTikN7XN3hymsmqH05nynAHH9st0W2pkDhoCLUTo9@mail.gmail.com>
Subject: Re: PROBLEM: oom killer and swap weirdness on 2.6.3* kernels
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 July 2010 19:47, dave b <db.pub.mail@gmail.com> wrote:
> On 28 July 2010 17:14, dave b <db.pub.mail@gmail.com> wrote:
>> On 28 July 2010 15:06, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>>>> On 27 July 2010 21:14, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>>>> >> On 27 July 2010 18:09, dave b <db.pub.mail@gmail.com> wrote:
>>>> >> > On 27 July 2010 16:09, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>>>> >> >>> > Do you mean the issue will be gone if disabling intel graphics?
>>>> >> >>> It may be a general issue or it could just be specific :)
>>>> >> >
>>>> >> > I will try with the latest ubuntu and report how that goes (that will
>>>> >> > be using fairly new xorg etc.) it is likely to be hidden issue just
>>>> >> > with the intel graphics driver. However, my concern is that it isn't -
>>>> >> > and it is about how shared graphics memory is handled :)
>>>> >>
>>>> >>
>>>> >> Ok my desktop still stalled and no oom killer was invoked when I added
>>>> >> swap to a live-cd of 10.04 amd64.
>>>> >>
>>>> >> *Without* *swap* *on* - the oom killer was invoked - here is a copy of it.
>>>> >
>>>> > This stack seems similar following bug. can you please try to disable intel graphics
>>>> > driver?
>>>> >
>>>> > https://bugzilla.kernel.org/show_bug.cgi?id=14933
>>>>
>>>> Ok I am not sure how to do that :)
>>>> I could revert the patch and see if it 'fixes' this :)
>>>
>>> Oops, no, revert is not good action. the patch is correct.
>>> probably my explanation was not clear. sorry.
>>>
>>> I did hope to disable 'driver' (i.e. using vga), not disable the patch.
>>
>> Oh you mean in xorg, I will also blacklist the module. Sure that patch
>> might not it but in 2.6.26 the problem isn't there :)
>
> Ok I re-tested with 2.6.26 and 2.6.34.1
> So I will describe what happens below:
>
> 2.6.26 - with xorg running
> "Given I have a test file called a.out
>  And I can see Xorg
>  And I am using 2.6.26
>  And I have swap on
>  When I run it I run a.out
>  Then I see the system freeze up slightly
>  And the hard drive churns( and the cpu is doing something as the
> large fan kicks)
>  And after a while the system unfreezes"
>
> 2.6.26 - from single mode - before xorg starts and i915 is *not* loaded.
> "Given I have a test file called a.out
>  And I cannot see Xorg
>  And I am using 2.6.26
>  And I have swap on
>  When I run it I run a.out
>  Then I see the system freeze up
>  And the system fan doesn't spin any faster
>  And the system just sits idle"
>
> 2.6.34.1
> With and without xorg - WITH spam on the same behaviour as in the
> 2.6.26 kernel appears (when xorg is not loaded).
>
> OOM attached from the 2.6.26 kernel when I used magic keys to invoke
> the oom killer :) (this was on the 2.6.26 kernel - before i915 had
> loaded and in single mode).

s/spam/same/
