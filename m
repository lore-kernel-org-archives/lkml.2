Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1EYJMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:12:37 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:35484 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751689Ab1EYJMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:12:34 -0400
X-Authenticated: #15668376
X-Provags-ID: V01U2FsdGVkX19/XrQiKtN//uI/wL9mw9/50mpQEq5KacerDKLal+
	WOHiCuPOHiPyib
From: Emil Langrock <emil.langrock@gmx.de>
To: Jan Engelhardt <jengelh@medozas.de>, "Ted Ts'o" <tytso@mit.edu>
Subject: Re: (Short?) merge window reminder
Date: Wed, 25 May 2011 11:12:24 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39-1-686-pae; KDE/4.6.2; i686; ; )
Cc: eschvoca <eschvoca@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jacek Luczak <difrost.kernel@gmail.com>, linux-arch@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        "linux-fsdevel" <linux-fsdevel@vger.kernel.org>
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com> <BANLkTi=Rky8zGrJ7TSF0MumzQWjpsD7Lcw@mail.gmail.com> <alpine.LNX.2.01.1105242207150.2318@frira.zrqbmnf.qr>
In-Reply-To: <alpine.LNX.2.01.1105242207150.2318@frira.zrqbmnf.qr>
MIME-Version: 1.0
Message-Id: <201105251112.27833.emil.langrock@gmx.de>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 May 2011 23:05:30 Jan Engelhardt wrote:
> On Tuesday 2011-05-24 20:48, eschvoca wrote:
> >On Tue, May 24, 2011 at 1:41 PM, Linus Torvalds wrote:
> >> It's not about features. It hasn't been about features for forever.
> >
> >Using the date also clearly communicates it is not about features.
> 
> On the contrary: Whenever a 2.6.x release was set out the door, there
> was at least one new feature in the cycle. Given the endless manpower
> that seems to trail Linux, that seems unlikely to change in the near
> term.
> 
> On "It is not about features" - it is not /just/ about features - it
> is also about fixes, which are equally important, and they also
> warrant a version bump of some sort on their own. Pointing out the
> obvious, the stable serieses.

You are mixing up features based versioning and identifier for versions. Linux 
has no feature based concept for most parts of their version number (only the 
patch part clearly states: fixes, fixes, fixes). We only need something that 
is easily readable and maybe has no extreme weird meaning that leads to false 
conclusions. And yes, that is what eschvoca meant and not something like 
"linux is stagnating".

> "Fleeing" to date-based version numbering seems like an excuse
> for making way for releases without any change whatsoever.
> (IOW, if there were features/fixes, a non-date based scheme of
> incremental numbers could indicate them already.)

Yes, that is usally the case... release the same source tarball again and 
again. I always had that feeling when looking at those wine, ubuntu, gentoo, 
ms, texlive, iasl, hugin, u-boot, ... developers. They are doing nothing the 
whole day and the marketing department does everything.

> >Me, a nobody end user, would prefer a version number that corresponded
> >to the date.  Something like:
> >
> >%y.%m.<stable patch>
> >%Y.%m.<stable patch>
> 
> Except that LINUX_KERNEL_VERSION has only 8 bits for each,
> so 2011 is out of range, which would need to kept in mind.
> And a 2-digit spec.. nah that does not feel very 100-year
> proof. (Just look at struct tm.tm_year for the mess 2-digits
> made technically.)

What is LINUX_KERNEL_VERSION? I only know LINUX_VERSION_CODE and 
KERNEL_VERSION

And the calculation behind it is following:

(((a) << 16) + ((b) << 8) + (c))

So for KERNEL_VERSION(2,6,40) we would get 0x20628 and for 
KERNEL_VERSION(2011,2,0) we would get 0x07DB0200. Of course our 
grandgrandgrand...grand children would die in agony in the year 65536.

And maybe (probably the module version check guys will kill me) could use a 
compressed version of that without hurding the comparison function in out of 
kernel modules. KERNEL_VERSION_Y(a,b) would be defined as

#define KERNEL_VERSION_Y(a,b) ({typeof (a) _a = a; \
				typeof (b) _b = b; \
				KERNEL_VERSION(_a >> 8, _a & 0xff, _b); })

This would bring us to the year 16777216 before everybody gets punched in his 
private parts by the versioning scheme. It is also possible to get more out of 
32 bits when we can assume that Linus or his grandgrand...grand children will 
never do more than 128 releases a year.

But yes, I aggree not to use 2 digit numbers for years.... unless we want to 
start the y2k+100 problem here.

> >Then users would know the significance of the number and when a vendor
> >says they support Linux 11.09 the user will immediately know if they
> >are up to date.
> 
> An added issue with that would be that numbers would not increase in
> same-sized steps anymore and leave gaps. (There would probably be no
> 11.06 between 11.05 aka 2.6.39 and 11.07-or-so aka 2.6.40)

Ok, this is really a good example why we should not use the month for 
releases, but an ever increasing number until the first number is also 
increased which resets the second number to 0.

Kind regards,
	Emil
