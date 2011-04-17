Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab1DQHA1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 03:00:27 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:53186 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab1DQHAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 03:00:24 -0400
X-ASG-Debug-ID: 1303023623-03d6a57329c63d0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DAA9001.6050203@fusionio.com>
Date: Sun, 17 Apr 2011 09:00:17 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mikael Pettersson <mikpe@it.uu.se>,
        kevin diggs <diggskevin38@gmail.com>,
        Michel Daenzer <michel@daenzer.net>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [regression] 2.6.39-rc[1-3] fail to boot on G5 PowerMac
References: <19876.35918.322649.256455@pilspetsen.it.uu.se>	<1302646173.28876.53.camel@pasglop>	<1302652502.28876.76.camel@pasglop>	<19877.23529.745123.819112@pilspetsen.it.uu.se>	<1302685102.28876.81.camel@pasglop>	<BANLkTimc84A8kddarnhvrcab3iKZc0HZAg@mail.gmail.com>	<1302736869.28876.91.camel@pasglop>	<BANLkTika8FY1dD_hOQ4wMhHzuQ2Qt8fg7A@mail.gmail.com>	<1302771756.15520.100.camel@thor.local>	<BANLkTimykvKp=bwsFyNE9fWqcE9Ffws6bA@mail.gmail.com>	<1302818089.28876.134.camel@pasglop> <BANLkTimGLmQjCNFOy5z64Zg=R2FX--LF9A@mail.gmail.com>
X-ASG-Orig-Subj: Re: [regression] 2.6.39-rc[1-3] fail to boot on G5 PowerMac
In-Reply-To: <BANLkTimGLmQjCNFOy5z64Zg=R2FX--LF9A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1303023623
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.12
X-Barracuda-Spam-Status: No, SCORE=0.12 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=CN_BODY_332
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.61096
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.12 CN_BODY_332            BODY: CN_BODY_332
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-17 05:16, Hugh Dickins wrote:
> On Thu, Apr 14, 2011 at 2:54 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
>> On Thu, 2011-04-14 at 14:25 -0700, Hugh Dickins wrote:
>>>
>>> Something worth trying: turn off CONFIG_IDE.  That's what I need to
>>> boot 2.6.39-rc[1-3] on PowerPC G5.
>>>
>>> I know Jens has been fixing problems with IDE versus his plug/unplug
>>> changes, but it's still not fixed for me in rc3.
>>>
>>> In other mail http://lkml.org/lkml/2011/4/14/614
>>> I see Linus recommending his post-rc3 commit 6631e635c65d
>>> but I've not tried that myself yet.
>>
>> Well, the disk is SATA so it's CONFIG_ATA/libata, which works fine here,
>> unless you somewhat replaced your CD-ROM with a legacy IDE disk :-) Or
>> maybe the problem is related to the CD-ROM drive. There's a libata
>> driver for it nowadays, so you can use PATA_MACIO instead of IDE_PMAC
> 
> Thanks for that, Ben: I remember you were brewing up such a driver,
> but I missed when it actually went in.  I can confirm that switching
> off CONFIG_IDE and switching on CONFIG_PATA_MACIO and
> CONFIG_BLK_DEV_SR now gives me a booting system with a working CD-ROM
> (though I've not yet tried burning).
> 
> Whereas CONFIG_IDE=y with current git still does not boot: hangs for a
> minute or three around the windfarm announcements, then an endless
> splurge of hda error messages - sorry, I'm not being helpful, other
> worries...

It's the media event notification that goes crazy. Try and comment out
this line:

	drive->dev_flags |= IDE_DFLAG_MEDIA_CHANGED;

in drivers/ide/ide-cd.c:cdrom_saw_media_change() and see if it boots.

-- 
Jens Axboe

