Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660Ab0KSXFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 18:05:45 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48845 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161Ab0KSXFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 18:05:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dOqIV/H+qFNKiLlakTw1vI+0z8JxW0OCax7RmsbcaMS2T1pOIqoMJlGyLdVRcWTX3s
         cBBTToKTznmwkGJ0lG61lAnnqnnq6ofb/d8hBC5swa7kaO9oC1bp/ZpDYZFP34+uRTDd
         rw71DOHajNRmUZD0jHarsIkcgjklVKGIAdzlM=
MIME-Version: 1.0
In-Reply-To: <1290204313.9884.1.camel@t60prh>
References: <AANLkTi=emVB3kqR322Man01sDd0DFecxzDENVCS6B1jj@mail.gmail.com>
	<AANLkTik4Bj2_D_oz8jWxzKSKz16S=Yv6884iHA072bJe@mail.gmail.com>
	<20101119130329.675ebf0b@jbarnes-desktop>
	<AANLkTimQQ62MKEs1WkuCMHqMQejC40rLBFc2KGF=SDHF@mail.gmail.com>
	<1290204313.9884.1.camel@t60prh>
Date: Sat, 20 Nov 2010 00:05:42 +0100
Message-ID: <AANLkTikZNAxsm8p=Nq2mqgcoxs+epqOPOeykAY34bT5q@mail.gmail.com>
Subject: Re: Regressions in resume on intel graphics
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Dave Airlie <airlied@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/19 Dave Airlie <airlied@redhat.com>:
> On Fri, 2010-11-19 at 22:35 +0100, Zdenek Kabelac wrote:
>> 2010/11/19 Jesse Barnes <jbarnes@virtuousgeek.org>:
>> > On Fri, 12 Nov 2010 10:17:07 +0100
>> > Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:
>> >
>> >> 2010/11/12 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
>> >> > Hi
>> >> >
>> >> > I've noticed that after resume  with 2.6.36 kernel I need to switch
>> >> > between console and back to Xorg to get usable Xsession again.
>> >> > (my hw - T61, gma965, 4GB)
>> >> >
>> >> > I've played bisect game -  and this is the first broken kernel:
>> >> >
>> >> > ---
>> >> > commit 8fd4bd22350784d5b2fe9274f6790ba353976415
>> >> > Author: Jesse Barnes <jbarnes@virtuousgeek.org>
>> >> > Date:   Wed Jun 23 12:56:12 2010 -0700
>> >> >
>> >> >    vt/console: try harder to print output when panicing
>> >> > ---
>> >>
>> >> I've been able to boot and test with 2.6.37-rc1-00170-gf6614b7
>> >> - and this problem seems to be fixed in this version (vt.c file seems
>> >> to be gone?).
>> >
>> > This is really weird; there was one issue Dave tracked down related to
>> > lockdep and the new oops code, but I think it's been fixed.  And it
>> > should manifest as something other than a GPU hang...
>> >
>>
>> Well - unsure - how this worked ok - for 2.6.37-rc1-00170-gf6614b7 (I
>> could try few more times - though this kernel seems to be crashing for
>> various other reasons - so I've had quite few testruns before I've
>> been able to test this in some very limited X environment - so maybe
>> it was just some lucky case - but I still keep it on my disk)
>>
>> Anyway - as an update - I'm now regularly using 2.6.37-rc2 - and it
>> has exactly same problems - as in my original report -  so the problem
>> has not magically disappeared and it is still there.  Is there
>> anything I should try ?
>>
>> Basically every time after resume from suspend I have to switch from X
>> to console and back to get usable screen back. Without this I seen
>> only black screen with mouse over it - is there some way for reverting
>> of this patch - or maybe just disabling some part of it ?
>>
>>
>> To have reliable resume I still have to keep drm_kms_help thread
>> disable - otherwise I observe GPU errors.
>> Switch between consoles is 'relatively' easy to overcome.
>>
>> And another thing which might help -  during suspend/resume  I could
>> usually see weird switch to console with some special text on the
>> whole console screen -
>>
>> [ ###.... ]
>> [ ###.... ]
>>
>> where  '###' is some changing number - and it seems to be different
>> between resumes.
>> Also I should add I'm using  'no-console-suspend'  kernel boot option.
>
> Can you see if e0fdace10e75dac67d906213b780ff1b1a4cc360 reverts cleanly?
> and fixes it?
>
> The problem is I think you are getting a lockdep splat or rcu issue
> before suspending, which sets oops_in_progress and never unsets it,
> which means on resume the fb resume path kicks in to show you the oops
> that is happening when there isn't actually anything to show. I've
> gotten acks to have this reverted I just need to send the patch.
>


Ok - tested  currentl 6656b3fc8aba2eb7ca00c06c7fe4917938b0b652 vanilla kernel
with reverted commit e0fdace10e75da - and it seems Xorg screen after
resume is again properly working.
So this was quick - now the remaining problem -
https://bugzilla.kernel.org/show_bug.cgi?id=19052

Zdenek
