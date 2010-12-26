Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab0LZXtV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 18:49:21 -0500
Received: from dtp.xs4all.nl ([80.101.171.8]:25145 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752668Ab0LZXtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 18:49:19 -0500
Date: Mon, 27 Dec 2010 00:49:17 +0100
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>, Michael Tokarev <mjt@tls.msk.ru>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Slow disks.
Message-ID: <20101226234917.GE18227@bitwizard.nl>
References: <20101220141553.GA6088@bitwizard.nl> <20101220190630.66084e1d@neptune.home> <AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com> <20101222104306.GB30941@bitwizard.nl> <m3aajvz5na.fsf@intrepid.localdomain> <4D14BB36.1030304@msgid.tls.msk.ru> <20101225121407.GA2116@bitwizard.nl> <20101226214037.GB18227@bitwizard.nl> <AANLkTinKgW_Jpph5NtstCJxA6ZhuTgEc+Juc8YrvE7CE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinKgW_Jpph5NtstCJxA6ZhuTgEc+Juc8YrvE7CE@mail.gmail.com>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 26, 2010 at 06:17:40PM -0500, Greg Freemyer wrote:
> On Sun, Dec 26, 2010 at 4:40 PM, Rogier Wolff <R.E.Wolff@bitwizard.nl> wrote:
> > On Sat, Dec 25, 2010 at 01:14:07PM +0100, Rogier Wolff wrote:
> >> Out of four partitions on the drive, two are aligned, two are not.
> >
> > Ooops. I looked wrong. Sorry. All four partitions are mis aligned.
> >
> >        Roger.
> 
> It sounds like you have 3 or 4 separate issues that are each costing
> you a factor of 3 or so of pain.
> 
> 3 * 3 * 3 *3 = 81  ( I don't recall how bad your overall problem was).
> 
> I can remember:
> 
> Raid 5 - poor choice for 4KB random writes - a factor of 2-4
> Misaligned 4KB physical sectors - a factor of 2+
> Excessive Head Parking  (You show 100K plus head parks in your smart
> data) - (who knows.  It takes a while to un-park the heads and your
> heads are parking way too often.)

Still I think that iostat -x output shows a different story: 

On a different server, I have many many many files. I started a delete
of some of them two days ago. That server is performing just fine. It
shows that disk IOs are serviced on average after around 5-15ms. Those
are normal numbers.

The "remove many files" operation is also likely to cause a similar
small-ios-workload as the mailserver. On the other hand, there are
samsung drives there.

You might be right that we have a few issues together. that might
compound things. But the "30x" performance difference estimate came
from the service time stats from iostat. 

Raid5 might cause us an additional performance hit in real life, but
it does not affect the measured service times of the drives. 

The head parking (and unparking) can indeed influence service times if
say the drive is parking after each IO. On the other hand when the
kernel shows "100% usage" we might hope for the drive not to have time
enough to start thinking about parking the head. And the kernel showed
100% usage through periods as large as ten seconds at a time.

> I think you said it was a 8TB, I know its a pain, but I'd rebuild.  I
> don't know how reliable various large drives are currently.  in
> 2008/2009 they seemed to be horrible and the advice was to use drives
> from different vendors, etc so you would be less likely to have a
> batch of drives go bad all at once.

The Samsungs are holding out really well. I have 8*1T and 4*2T (and a
few 4*1T) running just great. Seagate goofed with some 500Gb and 1T
drive sizes IIRC. You're right you wouldn't want to have two of them
stop/crash at the same time due to the same bug. (chances were around
1% for a 4-drive setup). 

Anyway. Others say that mixing drives is bad because the performance
wouldn't match. At least the performance bottleneck for the array is
the slowest disk, so you'll almost allways end up with worse
performance than when you have all disks the same.



	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
