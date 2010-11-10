Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab0KJSsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:48:24 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58015 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab0KJSsX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:48:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=w/xmG+YYVaXsbI4bYT920K20oavS9AHd1xs/jnDVsSSEs7fwnnD+tskSwm4E5n1Sg9
         7gxR4VeE4dYDhb1We79wqozzsNkgjL3UycbQ0UnDdqPaet0DsQGFuGeqcAZ6ECFWSMAk
         INJmco58bjyjaqDAjXPeqPkoHNhgCc3OzmkEU=
MIME-Version: 1.0
In-Reply-To: <AANLkTik107mFOqvxsBtBrc14RHwhkkZTOGgctxKPPNfW@mail.gmail.com>
References: <AANLkTikA6hZDV0A30fku7VT7Z1P8OqxcsF-EK95pBdD=@mail.gmail.com>
 <4CD966D8.4000602@ladisch.de> <20101109153805.GB3146@kryptos.osrc.amd.com>
 <AANLkTi=cUGGpkgWcbX=KMxzu+E=Toy_O+LeLoAFFUAsh@mail.gmail.com>
 <20101109180123.GB31121@aftab> <AANLkTik107mFOqvxsBtBrc14RHwhkkZTOGgctxKPPNfW@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 10 Nov 2010 13:48:00 -0500
X-Google-Sender-Auth: kwJ-CZJw40z_lAn3BZW7uSBefvU
Message-ID: <AANLkTik1JdQRh_Gkz_240csVGp4sS0W8nzR5d9Pv1G-X@mail.gmail.com>
Subject: [FALSE ALARM] Re: HPET (?) related hangs and breakage in 2.6.35,36
To: Borislav Petkov <bp@amd64.org>
Cc: Clemens Ladisch <clemens@ladisch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 4:29 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Tue, Nov 9, 2010 at 1:01 PM, Borislav Petkov <bp@amd64.org> wrote:
>> On Tue, Nov 09, 2010 at 12:44:48PM -0500, Andrew Lutomirski wrote:
>>> I may have just reproduced after a couple of days of uptime it in
>>> 2.6.36 with hpet=disable (in any case, the system hung and netconsole
>>> didn't work).
>>>
>>> I'm currently testing the hpet_min_tick stuff, backported to 2.6.36,
>>> with hpet on.  Haven't had a problem yet, but I'll see what happens
>>> after a few hours.  So far, it said:
>>>
>>> ACPI: HPET id: 0x8086a301 base: 0xfed00000 min tick: 128
>>
>> This doesn't say what your BIOS has set it to originally. For that, do
>>
>> hexdump -C /sys/firmware/acpi/tables/HPET
>>
>> and check what does the u16 little endian value at offset 0x35 say.
>
> 0x37ee, which people have seen before.  In any case, even with the
> patch applied my system hung, and I still got this off netconsole
> sometime around when the hang happened:
>
> Clocksource: tsc unstable (delta = -34355296774 ns)
> Switching: to clocksource hpet

Please disregard -- this is a bug in nouveau (or drm) not hpet.  I'll
send a bug report to the maintainers.

--Andy

>
> Another odd symptom: none of the SysRq hotkeys I could think of did
> anything *except for SysRq-b*.  I have no idea what could cause that.
>
> My system appears to pass ingo's time-warp-test (when compiled with
> -O0 -- it segfaults with -O2), so I think my TSC is okay.
>
> --Andy
>
