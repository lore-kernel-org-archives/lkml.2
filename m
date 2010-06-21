Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab0FUCX4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 22:23:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44741 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757796Ab0FUCXw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 22:23:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JnBVAW9NRj47QfNU3bwz+UEBMIUIueKDgsRr32cIpkO5Ay4wkp7uYFhCR/Pt+UYOur
         NdghfCwENdUhnvwIthK9vkzK3Ce9SMwYQwa7AEWQSNRPknSQk+rkpMDRQ2VFVixQWVGg
         zB1izigGEE8L2Ni4E92IalYJz5KXiVNpL+EZg=
MIME-Version: 1.0
In-Reply-To: <AANLkTikPAdDuUb37-GPDzFugBYEWNpoSLabcl2Fyt5VY@mail.gmail.com>
References: <AANLkTikeDoxm6OzWldU5PAr06wvW89asIIPNrpVKoc8I@mail.gmail.com>
	<AANLkTikPAdDuUb37-GPDzFugBYEWNpoSLabcl2Fyt5VY@mail.gmail.com>
Date: Sun, 20 Jun 2010 22:23:50 -0400
Message-ID: <AANLkTilP5yyJjMqZPhvgv2d22Lrt8ZKB0AoITSEsukgt@mail.gmail.com>
Subject: Re: Kernel does strange things when compilations push memory usage 
	above physical memory and the compilations are being done in a tmpfs, despite 
	having ample swap
From: Richard Yao <shiningarcanine@gmail.com>
To: Andrew Hendry <andrew.hendry@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My system is still responsive if it has not locked-up, even after the
oom-killer appears to have killed stuff.

Does the kernel need to be compiled with any special options to have
it report to dmesg that the oom-killer activated? I cited the
oom-killer as being activated because several things would
inexplicit-ably crash when the system is under memory pressure, but
looking in my dmesg log at a crash that occurred earlier today when I
forgot to unmount my tmpfs, I do not see any references to the oom
killer, just the process that crashed:

[ 5873.816211] chrome[18404]: segfault at 8 ip 0000000001063b9b sp
00007fffb0a7f540 error 4 in chrome[400000+28be000]

Could it be that a bug is causing the kernel to map the same region of
physical memory to multiple programs?

On Sun, Jun 20, 2010 at 10:03 PM, Andrew Hendry <andrew.hendry@gmail.com> wrote:
> After the oom killer has killed things, is your system still really
> sluggish if it doesn't lockup?
>
> I have what might be a similar issue, after a lot of compiling on a ramdisk.
> http://marc.info/?l=linux-kernel&m=127569877714937&w=2
>
> Oom killer keeps killing processes until almost nothing is left.
> Free memory is very high, and system is still very sluggish.
>
> On Mon, Jun 21, 2010 at 10:21 AM, Richard Yao <shiningarcanine@gmail.com> wrote:
>> Dear Everyone,
>>
>> My desktop has 4GB of RAM and it is running an unpatched Linux 2.6.34
>> kernel. I recently migrated it from Windows 7 to Gentoo Linux and I am
>> encountering a highly peculiar problem when I build/rebuild system
>> packages in a manner that stresses memory.
>>
>> When system memory usage exceeds 4GB because I have several
>> compilations running simultaneously, all of which have had -j5 passed
>> to make, with the build scripts sharing an 8GB tmpfs directory, the
>> system typically responds by activating the kernel oom-killer, which
>> will usually kill some of the processes involved in the compilations,
>> among other things. This is with an 8GB swap partition and barely any
>> of it is touched when this happens according to KDE's system monitor.
>> Rarer, but alternative responses that the system has made to such
>> circumstances involve the system package manager failing
>> mid-compilation with "Segmentation fault" printed to the console or
>> open office failing with an obscure error message. Usually just
>> compiling open office alone is enough to have things fail, although I
>> usually see it fail with an obscure 5 digit error message that has no
>> meaning which I can derive from doing searches with Google. Unmounting
>> my tmpfs directory and doing things as I normally would do them makes
>> these issues disappear.
>>
>> I have run memtest and it has not detected any hardware issues. I
>> tried asking for help on the Gentoo Linux forums, but I received no
>> responses and this looks like a kernel issue, so I thought it would be
>> a good idea to ask for assistance on the kernel mailing list. Here is
>> a link to a copy of my kernel's .config file:
>>
>> http://paste.pocoo.org/show/227799/
>>
>> As I was typing this, I had openoffice 3.2.1 and something else
>> compiling in the background and the system completely froze. This is
>> the first I have seen my system do this and it was about 10 minutes
>> after the oom-killer had already taken out kwin and several tabs in
>> chromium. I had SSH running in the background, but even that has been
>> rendered inaccessible by the freeze. I cannot get a response from the
>> system via arping and nmap is telling me that the system is down.
>>
>> Earlier today, I tried to reproduce this issue under simpler
>> cirumstances by doing dd bs=4096 count=2097152 if=/dev/zero
>> of=/var/tmp/portage/zero.bak. As a consequence of all of the swapping
>> that occurred, the system's X server become unresponsive, so I walked
>> away and came back a few minutes later to find that the KDE System
>> Monitor had crashed, but everything else seemed fine.
>>
>> Any help with this issue would be appreciated. I am willing to
>> recompile my system in whatever manner necessary to diagnose the cause
>> of this issue. Please CC me any responses made either directly or
>> indirectly in response to this message.
>>
>> Yours truly,
>> Richard Yao
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
