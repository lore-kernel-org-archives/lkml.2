Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab2KMLc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 06:32:57 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40382 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab2KMLc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 06:32:56 -0500
MIME-Version: 1.0
In-Reply-To: <201211131111.38721.linux@rainbow-software.org>
References: <201211092242.34697.linux@rainbow-software.org>
	<CAAfyv36UhwVmjwBV5RKDmWm3ag_yqr+t1u+NHAtamFSkmcrUhw@mail.gmail.com>
	<201211131111.38721.linux@rainbow-software.org>
Date: Tue, 13 Nov 2012 12:32:55 +0100
Message-ID: <CAAfyv35P20QSeG3JR9jJ2-UoJwyDNm4JP0a2TNs_wPXxcJOVRA@mail.gmail.com>
Subject: Re: [RFC, RFT] [PATCH] staging: ft1000: unify struct ft1000_info
 between USB and PCMCIA drivers
From: Belisko Marek <marek.belisko@gmail.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 11:11 AM, Ondrej Zary
<linux@rainbow-software.org> wrote:
> On Monday 12 November 2012, Belisko Marek wrote:
>> Hi Ondrej,
>>
>> On Fri, Nov 9, 2012 at 10:42 PM, Ondrej Zary <linux@rainbow-software.org>
> wrote:
>> > Unify struct ft1000_info between ft1000-usb and ft1000-pcmcia and move it
>> > to common ft1000.h.
>> >
>> > ft1000-pcmcia seems to work. Please test ft1000-usb.
>> >
>> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
>> > ---
>> >  drivers/staging/ft1000/ft1000-pcmcia/ft1000.h      |   33 +-----
>> >  drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |   21 ++-
>> >  drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c |   10 +-
>> >  drivers/staging/ft1000/ft1000-usb/ft1000_debug.c   |  147
>> > ++++++++++---------- .../staging/ft1000/ft1000-usb/ft1000_download.c    |
>> >   70 +++++----- drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |   99
>> > +++++++------- drivers/staging/ft1000/ft1000-usb/ft1000_proc.c    |    4
>> > +-
>> >  drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |   30 ++--
>> >  drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |   54 +------
>> >  drivers/staging/ft1000/ft1000.h                    |   35 +++++
>> >  10 files changed, 236 insertions(+), 267 deletions(-)
>> >
>> > diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
>> > b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h index adb436e..65f7ab6
>> > 100644
>> > --- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
>> > +++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
>> > @@ -31,41 +31,10 @@
>> >  #define SUCCESS        0x00
>> >  #define FAILURE        0x01
>> >
>> > -struct ft1000_info {
>> > -       struct net_device_stats stats;
>> > -       u16 DrvErrNum;
>> > -       u16 AsicID;
>> > +struct ft1000_pcmcia {
>>
>> To be consistent can you please name also usb part not ft100_device
>> but e.g. ft1000_usb or something?
>
> Yes, that's a good idea. I'd like to do that in a separate patch, this one is
> already big enough.
OK good idea.
>
>> > @@ -1179,8 +1179,6 @@ static int ft1000_open(struct net_device *dev)
>> >         struct ft1000_info *pInfo = netdev_priv(dev);
>> >         struct timeval tv;
>> >
>> > -       DEBUG("ft1000_open is called for card %d\n", pInfo->CardNumber);
>>
>> ^^^ Why removing this debug?
>
> I don't remember exactly (this is from an old patch) but probably because I
> didn't want to add code to reach CardNumber (which should be removed too).
> The debug messages are a mess, some are completely useless, some should be
> non-debug instead.
There is rule one change one patch so please keep it there and remove
in separate patch.
>
> If you have the USB hardware, please test if this patch does not break
> anything. I have only a PCMCIA card.
I'll do testing on USB (waiting for HW to come ;))
>
> --
> Ondrej Zary

Cheers,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
