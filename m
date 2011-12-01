Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab1LAEvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 23:51:09 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64585 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab1LAEvG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 23:51:06 -0500
MIME-Version: 1.0
In-Reply-To: <20111130232529.GB3220@core.coreip.homeip.net>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
	<201111251402.28016.arnd@arndb.de>
	<CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com>
	<201111281753.45287.arnd@arndb.de>
	<CAJ0PZbT8FcCq=6GzLxOhhpRvCbCaJJEhE9_2GXXT4P0XZp6H-w@mail.gmail.com>
	<20111130135847.68a6e4c6@notabene.brown>
	<CAJ0PZbRpoz+uK4QUAO4RG5bhsSpNvm5U-ROtbduXhnFTLMZ1VQ@mail.gmail.com>
	<20111201095633.700e2923@notabene.brown>
	<20111130231740.GA25340@opensource.wolfsonmicro.com>
	<20111130232529.GB3220@core.coreip.homeip.net>
Date: Thu, 1 Dec 2011 13:51:05 +0900
Message-ID: <CAJ0PZbSNm-cQw_bKToiNRcZ=1rk7cu=W8Jq6_WUHUqp_hrak6Q@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 1, 2011 at 8:25 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Wed, Nov 30, 2011 at 11:17:41PM +0000, Mark Brown wrote:
>> On Thu, Dec 01, 2011 at 09:56:33AM +1100, NeilBrown wrote:
>> > On Wed, 30 Nov 2011 15:40:48 +0900 MyungJoo Ham <myungjoo.ham@gmail.com>
>> > wrote:
>>
>> > > I'm focusing on an external connector or port that each physical port
>> > > may inhabit multiple cables at a time although it should support a
>> > > port that may inhabit a single cable only at a time. However, the
>> > > class could be used for other general "multistate mux" that connects
>> > > different device drivers.
>>
>> >  maybe I'm just slow, but I'm having a lot of trouble imagining a single port
>> >  that could have multiple cables plugged in at the same time.  And this
>> >  blockage is stopping me from reflecting usefully on your other points.
>>
>> >  Are you able to show me a picture or a diagram or something so I can
>> >  visualise what you are talking about?
>> >  To me: once you plug one cable into a port, it is full and there is no room
>> >  for any more cables.
>>
>> One obvious example is the sort of big multi-way docking connector that
>> many mobile devices have (iPod and friends being one of the most
>> common).  These are essentially the same as docking station connections
>> on a laptop in terms of what they bring out - a variety of audio, video
>> and communication connections - which may go to a docking station or
>> some kind of breakout or adaptor cable and may have sub-ports hanging
>> off them (eg, it's common for tablets to have docking stations with HDMI
>> and audio sockets on them).
>>
>> There are also lower pin count equivalents like the multiplexed "USB"
>> sockets on some phones which can also carry other functions with
>> adaptors, and even something like a headset is really a microphone and
>> headphones on a single jack.
>
> Physical jack does not have to map 1:1 on logical jack. So 1 physical
> docking connector can be represented by 1 logical video connector, line
> in, line out, microphone and maybe else.
>

Yes, we can implement that way.

However, the "mux" device (e.g., MAX8997 MUIC / MAX77693 / FSA9480 /
... / and some multipurpose earphone jacks maybe? ) still needs to
have one device driver to represent the physical jack; it has one IRQ,
one set of power controls, and one set of registers for all of these
connectors.


Cheers!
MyungJoo

> --
> Dmitry



-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
