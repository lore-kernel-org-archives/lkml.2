Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab0HXMkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 08:40:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60095 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab0HXMkI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 08:40:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type:content-transfer-encoding;
        b=E+sM0XO5AzAbduF7IJm3YViAamqltlwHJs/gJYwdWJp44an6AJSs2fWmSUaCAG/ome
         y0fLBzNQY+d23mV0EaghTqFv9ggcyQX99REv8vksgyqOnys1sceu5NZWscAGP31cLVRw
         vaumZDVslI1dEhc7ZxsJekURUuaPvUEbJhKJ4=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
Date: Tue, 24 Aug 2010 13:40:06 +0100
Message-ID: <AANLkTikZvog+uKMz4ZhRrxuDMjjW3k+Q6QK14DKJQ-Xc@mail.gmail.com>
Subject: Re: # 16881 [REGRESSION, Radeon-KMS] 2.6.36-rc1,2 - graphic issues in
 0 A.D.
From: trapDoor <trapdoor6@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: airlied@linux.ie, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>,
        trapDoor <trapdoor6@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 12:27 PM, trapDoor <trapdoor6@gmail.com> wrote:
> On Tue, Aug 24, 2010 at 6:09 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
>> On Mon, Aug 23, 2010 at 12:00 PM, trapDoor <trapdoor6@gmail.com> wrote:
>>> On Mon, Aug 23, 2010 at 6:12 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
>>>> On Sun, Aug 22, 2010 at 3:41 PM, trapDoor <trapdoor6@gmail.com> wrote:
>>>>> Hello,
>>>>> Just wanted to let you know about this before bisecting which
>>>>> hopefully I will be able to start tomorrow. Please take a look at the
>>>>> screenshots in below links to see the difference with rendering
>>>>> textures in 0 A.D. alpha1 on kernel 2.6.35.3 and 2.6.36-rc1-git3. [0
>>>>> A.D. - strategic game, OS clone of Age of Empires; home page:
>>>>> http://wildfiregames.com/0ad/]
>>>>>
>>>>> 0 A.D. on kernel 2.6.35.3 [good]:
>>>>> http://picasaweb.google.co.uk/104351852606666221362/0ad?authkey=Gv1sRgCMne0NqXpuzR_gE#5508312214769142226
>>>>>
>>>>> 0 A.D. on kernel 2.6.36-rc1-git3:
>>>>> http://picasaweb.google.co.uk/104351852606666221362/0ad?authkey=Gv1sRgCMne0NqXpuzR_gE#5508312218519295058
>>>>>
>>>>> Please note that in both cases only kernel was different. The other
>>>>> components [including hardware] were in the same versions and had the
>>>>> same options (like the game itself, xorg-ati drivers, mesa, libdrm
>>>>> [S3TC disabled], etc.). So it must be kernel then.
>>>>
>>>> What card?  Anything in your dmesg?
>>>>
>>>> Alex
>>>>
>>>
>>> Hi Alex,
>>> Sorry for lack of details in my first e-mail. I was hoping to send you
>>> the logs together with bisecting results. Unfortunately there are
>>> other issues between 2.6.35-git2 - the last 'good' kernel (which
>>> doesn't include the first drm pull for 2.6.36 window merge) - and
>>> 2.6.36-rc1. Due to those issues I can't bisect.
>>>
>>> For example:
>>> 1) First I tried to narrow the problem down to the closest affected
>>> kernel snapshot. So I marked 2.6.35-git2 as good and I was expecting
>>> that 2.6.35-git3 will be a bad one (as -git3 is the first snapshot
>>> that includes drm patches from the first drm pull). But on -git3 0
>>> A.D. even fails to start.
>>>
>>> 2) Then I was hoping to do bisecting between 2.6.35-git11 and
>>> 2.6.35-git12 (-git12 is the first snapshot that includes patches from
>>> the second drm pull). But these both snapshots won't even compile for
>>> me. It stops suddenly at the second stage of making modules without
>>> giving any errors (despite kernel debugging enabled in .config). I
>>> remember I had this problem for a while, AFAIR since around
>>> 2.6.35-git5 to -git15 - between these I couldn't compile any snapshot
>>> I had tried.
>>>
>>> It's very likely that the issue I wanted to bisect is related to one
>>> of or both drm pulls . So doing bisect between e.g. these kernels:
>>> 2.6.35-git16 (which includes both drm pulls; assuming it's the first
>>> snapshot since -git5 I could compile) and 2.6.36-rc1 would be
>>> pointless - they both will be bad.
>>>
>>>
>>> ------------
>>> Now, this is my card:
>>>
>>> Asus ATI Radeon HD3650 Silent 512MB
>>> some glxinfo details:
>>>        OpenGL vendor string: Advanced Micro Devices, Inc.
>>>        OpenGL renderer string: Mesa DRI R600 (RV635 9598) 20090101  TCL DRI2
>>>        OpenGL version string: 2.1 Mesa 7.9-devel
>>>        OpenGL shading language version string: 1.20
>>>
>>>
>>> ------------
>>> About the logs. It happens that 0 A.D. does produce really huge logs.
>>> Running the game just for about 10 SECONDS (counting after chosen map
>>> has been loaded) relulted in these:
>>>
>>> On a 'good' kernel 2.6.35.3
>>>        60K     ./Xorg.0.log
>>>        48K     ./dmesg
>>>        27M     ./kern.log
>>>        27M     ./syslog
>>>        27M     ./messages
>>>        81M     [total]
>>>
>>> on a bad kernel 2.6.36-rc1
>>>        60K     ./Xorg.0.log
>>>        52K     ./dmesg
>>>        21M     ./kern.log
>>>        21M     ./syslog
>>>        21M     ./messages
>>>        63M     [total]
>>>
>>> There's no mistake above: 3 logs had been blown up to over 20M during
>>> only the little time when the game was running.
>>> How I did it: deleted all those logs completely, re-booted from the
>>> 'good' kernel, run the game and stopped. Then archived the logs,
>>> deleted again and repeated the same on the 'bad' kernel.
>>>
>>> So it looks like 99,999% of all lines in: kern.log, messages in syslog
>>> were produced on both kernels when 0 A.D. was running. Before I first
>>> time run it, I had never seen kern.log and messages in /var/log at
>>> all, and syslog was never bigger than around 1,5M (with logs collected
>>> from several boots and during a couple of days). Running 0 A.D. for a
>>> couple of minutes results in about 1G for each of those 3 logs.
>>>
>>> After compressing, the archive files are relatively small:
>>>        2.0M    ./2.6.35.3_0ad-logs.tar.bz2
>>>        680K    ./2.6.35.3_0ad-logs.tar.lzma
>>>
>>>        1.6M    ./2.6.36-rc1-00159-g36423a5_0ad-logs.tar.bz2
>>>        748K    ./2.6.36-rc1-00159-g36423a5_0ad-logs.tar.lzma [yes, somehow this
>>> came up bigger than 2.6.35.3(...).lzma]
>>>
>>>
>>> Do you mind if I send the .lzma's to you (unless you prefer .bz2)? I
>>> won't cc LKML or anyone of course, they will be sent only to you.
>>> Please let me know.
>>
>> I don't really need the whole files, likely it's just a few messages
>> repeated.  Go ahead and send me the files and I'll take a look.
>>
>> Alex
>>
>
> Files attached.
> The problem still occurs on 2.6.36-rc2-00098-gd1b113b (which includes
> drm patches from yesterday's pull).
>
> --
> Thanks
> Tomasz
>

I have opened bugzilla entry #16881 for this. Related screenshots and
log files are attached with the ticket.

-- 
Tomasz
