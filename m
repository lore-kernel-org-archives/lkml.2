Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927Ab0I0IUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 04:20:04 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39793 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab0I0IUB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 04:20:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EN1LxEtVXf+sRJrRTQjqB9PJuPsUWCVi5sJPYXeKmv167k8sL6g7ac63oKjs5pr2Jg
         EEXTX79HiXMngPCvBjEhK0Vob5Dft+hi31f91Fp4183Wkarfvz7y/jdSOz8d6sO8H3TM
         QDHBs1uYL78Xu4rrqsdfcNwon+i0LMOLGiY0E=
MIME-Version: 1.0
In-Reply-To: <4C9FE2C4.8070302@fluff.org>
References: <20100923190212.18863.25678.stgit@darius-desktop>
	<4C9BE577.4050504@fluff.org>
	<AANLkTi=S8v19iT1DC=6Nh9BEgRvKzyzKTKoJmS0Bw1Fb@mail.gmail.com>
	<4C9CD3E0.6060000@gmail.com>
	<4C9FE2C4.8070302@fluff.org>
Date: Mon, 27 Sep 2010 11:20:00 +0300
Message-ID: <AANLkTimy=eJKeANFi7VspoB6GrRzW1=36vjbfuNqPRRJ@mail.gmail.com>
Subject: Re: [RESEND PATCH] serial: samsung: fix device name
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Darius Augulis <augulis.darius@gmail.com>, kgene.kim@samsung.com,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 3:18 AM, Ben Dooks <ben-linux@fluff.org> wrote:
> On 24/09/10 17:37, Paulius Zaleckas wrote:
>> On 09/24/2010 09:57 AM, Darius Augulis wrote:
>>> Hi,
>>>
>>> On Fri, Sep 24, 2010 at 2:40 AM, Ben Dooks<ben-linux@fluff.org>  wrote:
>>>> On 23/09/10 20:15, Darius Augulis wrote:
>>>>> Swap device and driver names in serial/samsung.c
>>>>
>>>> This is far too short, please see the notes below on trying
>>>> to make this more informative.
>>>>
>>>>> Signed-off-by: Darius Augulis<augulis.darius@gmail.com>
>>>>> ---
>>>>>
>>>>> This patch was submitted about 3 months ago, but still not merged.
>>>>> There was another similar patch from Joonyoung Shim
>>>>> <jy0922.shim@samsung.com>  and was discussed here:
>>>>> http://marc.info/?l=linux-serial&m=127416101222281&w=2.
>>>>> Joonyoung Shim acked my patch and other people on ARM mailing list
>>>>> acked it. The maintainer, Ben Dooks, still not responding for
>>>>> a long time. Another maintainer, Kukjin Kim, refused to merge
>>>>> it without Ben's review.
>>>>> I would like to ask somebody pick up this bugfix.
>>>>
>>>> I belive last time this was brought up I asked about the affect
>>>> this has on the userspace. The following issues would be helpful
>>>> or essential to have noted in the header about the effect of this.
>>>>
>>>> - Does it change the /dev name of the device? if so I would thinl
>>>>   carefully about applying it, as it would be a change in the way
>>>>   that userspace sees the kernel.
>>>
>>> It does - now devices are named /dev/s3c2410_serial, and patch changes
>>> its name to /dev/ttySAC
>>>
>>>>
>>>> - Does it change the kernel output itself? A note on what diffeences
>>>>   can be seen in things like dmesg would be helpful.
>>>
>>> It does. Serial driver reports device names when probing, so there
>>> will appear ttySACx instead of
>>> s3c2410_serialx.
>>>
>>>>
>>>> - Are there any other side effects
>>>>
>>>> - Why is this a bug? Maybe the previous points will explain what is
>>>>   going on, but if not, then a reasonably concise description of
>>>>   what is going on here.
>>>
>>> This is bug, because of several points:
>>>
>>> 1. Because it contradicts kernel documentation. Please read
>>> Documentation/arm/Samsung-S3C24XX/Overview.txt line 196.
>>> This should be enough to apply this patch.
>>>
>>> 2. Because s3c2410_serial isn't correct name for serial device node.
>>> It's name of Samsung serial driver.
>>>
>>> 3. Because now almost all userspace systems workaround it by creating
>>> symlink
>>> /dev/ttySACx>  /dev/s3c2410_serialx and only then put some getty on
>>> created symlink, not on original device.
>>> Systems which don't create this symlink, fail to boot at all, because
>>> of wrong console name. Good example is Buildroot.
>>
>> I had similar issue with buildroot too, because in /etc/securetty it is
>> defained as ttySAC0
>>
>> 4. For console in kernel boot command line you must enter console=ttySACx.
>> Why it sould be different in userspace?
>>
>> For me it seems taht this bug was not noticed earlier, because most
>> embedded
>> systems were using static device nodes and ttySACx was used in these cases.
>
> As long as these are explained, then I'm reasonably happy for this to be
> applied, as long as there are no other complaints.
>
> However, this is a big change, and I think it should await the next
> merge window.

I also agree that it should be applied to next release.
