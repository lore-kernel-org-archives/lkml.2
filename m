Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab1BXOSD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 09:18:03 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:34899 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754868Ab1BXOSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 09:18:00 -0500
From: Par-Gunnar HJALMDAHL <par-gunnar.p.hjalmdahl@stericsson.com>
To: Par-Gunnar HJALMDAHL <par-gunnar.p.hjalmdahl@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>, Pavan Savoy <pavan_savoy@sify.com>
Cc: Vitaly Wool <vitalywool@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Date: Thu, 24 Feb 2011 15:16:30 +0100
Subject: RE: [PATCH 00/11] mfd and bluetooth: Add CG2900 suppor
Thread-Topic: [PATCH 00/11] mfd and bluetooth: Add CG2900 suppor
Thread-Index: AcuwLuk73FpFksWgQqOy4Vh0lhB9MAGHzJtgB3eiaqA=
Message-ID: <AFCDDB4A3EA003429EEF1E7B211FDBBA334C0FB0E2@EXDCVYMBSTM005.EQ1STM.local>
References: <1292584829-28279-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
 <201101061946.04790.arnd@arndb.de>
 <AANLkTikJMx2QxYwXS_TrKK5hcnD3G0MNvEiDO+xAZrpo@mail.gmail.com>
 <201101091955.05174.arnd@arndb.de> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p1OEI92c018681

Hi,

I sent the mail below one month ago, but have still not received any answers or further comments.
Has anyone of you who made comments on the CG2900 patches earlier, any more comments or questions?

It is unclear to me where we stand with the CG2900 patches. I am myself happy with the current architecture, but I understand there are differing opinions.
I would like to know what we need to do in order to get this driver into the Linux Kernel tree.

/P-G

> -----Original Message-----
> From: Par-Gunnar HJALMDAHL
> Sent: den 17 januari 2011 16:33
> To: 'Arnd Bergmann'; Pavan Savoy
> Cc: Vitaly Wool; Linus Walleij; Alan Cox; Samuel Ortiz; Marcel
> Holtmann; linux-kernel@vger.kernel.org; linux-
> bluetooth@vger.kernel.org; Lukasz Rymanowski; Par-Gunnar Hjalmdahl
> Subject: RE: [PATCH 00/11] mfd and bluetooth: Add CG2900 suppor
> 
> Hi,
> 
> Sorry for not answering earlier. I've been overloaded with things to do
> now after New Year. See below.
> 
> > -----Original Message-----
> > From: Arnd Bergmann [mailto:arnd@arndb.de]
> > Sent: den 9 januari 2011 19:55
> > To: Pavan Savoy
> > Cc: Par-Gunnar HJALMDAHL; Vitaly Wool; Linus Walleij; Alan Cox;
> Samuel
> > Ortiz; Marcel Holtmann; linux-kernel@vger.kernel.org; linux-
> > bluetooth@vger.kernel.org; Lukasz Rymanowski; Par-Gunnar Hjalmdahl
> > Subject: Re: [PATCH 00/11] mfd and bluetooth: Add CG2900 suppor
> >
> > On Sunday 09 January 2011, Pavan Savoy wrote:
> > > On Fri, Jan 7, 2011 at 12:16 AM, Arnd Bergmann <arnd@arndb.de>
> wrote:
> > > > On Wednesday 05 January 2011, Par-Gunnar HJALMDAHL wrote:
> > > >
> > > >> Sorry for not answering sooner. I've been on Christmas and New
> > Year vacation.
> > > >
> > > > I'm also still catching up with email that has accumulated over
> my
> > > > vacation, including your previous response.
> > > >
> > > > This sounds wrong for both TI and ST-E: AFAICT they are actually
> > built
> > > > around an HCI interface. It's unfortunate that the TI code
> actually
> > got
> > > > merged into the kernel like this.
> > >
> > > I am not sure what does built around HCI Interface mean? Also yes,
> in
> > TI- code
> > > we do refer to Bluetooth headers.
> > > However the fact that I wanted to point out to Par-Gunnar was, that
> > we
> > > don't want to use
> > > hciattach and enable HCI-UART + HCI-H4 for enabling our driver or
> our
> > > driver should not
> > > depend on those modules as such...
> >
> > Good point about hciattach, you certainly shouldn't need to use that
> if
> > the kernel already knows that a tty is connected to an HCI and what
> the
> > parameters are. Even more so if the HCI is not actually on a rs232
> line
> > but something like i2c or spi. Automatically binding to the right
> line
> > discipline should be easily doable in the drivers though.
> >
> 
> When having UART as transport you need something to open the UART and
> set the line discipline. If this is hciattach or something else is up
> to each developer to suit what they are doing. I don't see a problem
> with using hciattach even if you don't use the Bluetooth part (if the
> exe is part of the system anyway), but if a company/developer want to
> use something else they can do that. It's a usage of standard
> interfaces using open() and ioctl().
> I still don't think that you should have a line discipline for other
> transports than UART. If I would look at how I would implement an SPI
> driver for CG2900, there would almost be no code that could be used in
> common between cg2900_uart and cg2900_spi. SPI doesn't change baud
> rate, SPI uses commands for sleep/wake instead of Break, SPI packets
> doesn't need extra packetizing, etc.
> 
> > I don't understand the problem with relying on the hci-uart or hci-h4
> > modules. If the hardware uses the H4 protocol, we certainly should
> use
> > the kernel module that knows how to deal with H4, and we don't want
> > to have two modules implementing the same protocol.
> >
> 
> I must say I don't understand this problem either. Unless the protocol
> driver is activated through ioctl SET_PROTOCOL, the code will not be
> executed, and the amount of ROM needed is negligible.
> If you look at our submission, the hci-h4 could possibly be reused to
> some extent. Basically the packetizing to the Bluetooth H4 channels 1-4
> could be re-used. In order to allow for vendor specific channels to be
> handled some new registration system on top of hci-h4 plus a callback
> system for data reception would have to be added (in order to
> facilitate systems that do not want all data to be sent directly to the
> Bluetooth stack such as the CG2900 driver). I'm afraid that we would
> have a significantly more complex system and larger amount of code if
> we would try to generalize the hci-h4 module. I definitely prefer the
> current model where a vendor specific driver replaces the hci-h4
> protocol driver.
> 
> > > >> > instead of common-hci-module, why not create a algo-driver
> layer
> > 'ala
> > > >> > i2c ? where individual drivers can register their receive
> > handlers for
> > > >> > data interpretation ?
> > > >
> > > > That would be what I suggested ;-)
> > >
> > > But even here too, the algos layer if you imagine which can be the
> > > sort of the first
> > > receiver of data from the transport would refer to BT headers to
> > > interpret the data (not just BT, but FM/GPS)
> > > and pass it onto other protocol/client drivers,
> >
> > Right, that is the entire idea, and I don't see a problem here.
> > If you do this, you use the headers of the two subsystems you
> > interface with. What you should /not/ instead is use header
> > files of a subsystem you don't interface with and reinterprete
> > the definitions in creative ways, which is what I understood
> > was being discussed earlier.
> >
> > > >> In some way you then run into the same problem has I had in
> > previous patch
> > > >> sets. The functionalities supported is really determined by each
> > chip.
> > > >> You might or might not have for example GPS in a certain chip.
> So
> > you do not
> > > >> want a central module to expose all possible channels to the
> > stacks on top.
> > > >>
> > > >> You only want the actually supported features to be exposed to
> > upper layers.
> > > >> Then the MFD system is pretty nice. It's easy and modularized to
> > expose the
> > > >> different channels as MFD cells.
> > > >
> > > > But as soon as you have the concept of channels with a clearly
> > defined
> > > > interface, you have almost abstracted it enough to go all the
> way.
> > >
> > > Something like this is what the recent RFC posted to
> > > lkml/linux-bluetooth
> > > http://www.spinics.net/lists/linux-bluetooth/msg09990.html,
> > > it kinda looks clumsy
> > > but what I feel is we shouldn't shy away from not referencing
> > > Bluetooth, (or may be tomorrow GPS
> > > with NMEA headers)....
> >
> > The one important goal here should be to avoid code duplication.
> > Using the header to get the data structures from separate code
> > means you need to have similar parsing functions in each of the
> modules
> > using it. Not sharing the header wouldn't help, because then you end
> > up duplicating even more. The real solution, speaking very broadly,
> > must be to have a general module that deals with whatever the more
> > specific modules have in common, and have a header file that defines
> > the interface to it.
> >
> 
> In general I agree with you, but there are some problems here.
> The most used BT HCI events are Command Status and Command Complete.
> Command Status could be parsed completely in a good way (retrieving op
> code, nbr of commands allowed, and status of command sent).
> Command Complete is however quite complex since the returned data will
> differ depending on command sent. Op code and nbr of commands allowed
> can be retrieved but everything else have to be extracted differently
> depending on command. This means that there is not much that will be
> saved here. But maybe we could extract some parsing into common
> functions, but I don't think you would gain that much.
> Moreover, this would lead to a major reimplementation of the hci_core.c
> and related files, since they do not use any exported common functions
> as it is today. I do not know if they (BlueZ community) would want this
> and I do not think that that should be part of the CG2900 driver to do.
> It should in that case be done separately.
> 
> > > >> Also note that the common-hci-module is only really used until
> the
> > connected
> > > >> chip has been detected. The chip handler will then set the
> > callback functions
> > > >> so actual data transmissions never pass the common-hci-module.
> > They go directly
> > > >> from transport to chip handler. That is not really shown in the
> > picture above.
> > > >> Just imagine that common-hci-module is removed after a chip has
> > been connected
> > > >> and a chip handler has been determined.
> > > >>
> > > >> I hope I haven't misunderstood your question. I do not know much
> > about the I2C
> > > >> system, but I tried to understand your question as best as I
> > could.
> > > >
> > > > I think there is a disconnect when talking about hierarchies, as
> it
> > can be applied
> > > > to different areas:
> > > >
> > > > * module dependencies
> > > > * device detection
> > > > * sysfs object hierarchy
> > > > * data flow
> > >
> > > module dependecy-wise I agree,
> > > I would want FM-V4L2 without BT or I might want GPS simplistic char
> > > driver without BT or FM V4L2.
> >
> > But you'd still need to have an HCI module. I believe right now, the
> > hci module depends on the bluetooth module, and you are right that
> this
> > is an undesirable dependency to have for a GPS module. However, the
> > solution
> > to this should not be to make GPS independent of HCI, but to make
> parts
> > of HCI independent of bluetooth.
> >
> 
> For the CG2900 that is not possible. Even if you are running just GPS
> you still must download patches and settings and that is done through
> HCI commands over the Bluetooth command interface. We also use
> Bluetooth commands to identify the controller.
> 
> > > device detection wise, It is a problem, there is not "_probe"
> > > mechanism for UART based transport as it is
> > > understandable, and pretty much the driver would end up being
> > platform
> > > device driver ...
> >
> > The platform device is just the lowest level in the device hierarchy.
> >
> > If each HCI channel is a device, you can stack bt, gps, audio, ...
> > devices all on top of the HCI device, which is either stacked on top
> > of a serial port or in some other way connected to the underying
> > transport.
> >
> > In this case, the channels themselves are not platform devices, but
> > would get a new bus for them. That bus is populated by a driver that
> > owns the HCI and that knows (e.g. from its platform data, hardware
> > registers, user config or device tree) what channels are present.
> >
> > > data flow is where I guess the abstraction has to lie in, for
> > > different vendors...
> >
> > I don't know what you mean with that. My point was that we need to
> > consider all the hierarchies, and that they might be different.
> >
> > 	Arnd
> 
> /P-G

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
