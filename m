Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759909Ab2CTMtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 08:49:09 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49234 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab2CTMtG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 08:49:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120319220224.ABF5A3E0A04@localhost>
References: <1331628428-24017-1-git-send-email-b29396@freescale.com>
	<1331628428-24017-2-git-send-email-b29396@freescale.com>
	<20120313172351.97C5E3E053B@localhost>
	<20120314124512.GG1180@shlinux2.ap.freescale.net>
	<20120314141643.GP3852@pengutronix.de>
	<20120315030206.GB13022@shlinux2.ap.freescale.net>
	<20321.37353.63115.664975@ipc1.ka-ro>
	<20120315105927.GE13022@shlinux2.ap.freescale.net>
	<20321.53468.310199.875966@ipc1.ka-ro>
	<20120316030134.GA5161@shlinux2.ap.freescale.net>
	<20120318184749.BB15D3E07BF@localhost>
	<20326.55337.249575.289067@ipc1.ka-ro>
	<20120319150601.B783A3E05A5@localhost>
	<20327.25470.723875.916422@ipc1.ka-ro>
	<20120319220224.ABF5A3E0A04@localhost>
Date: Tue, 20 Mar 2012 05:49:06 -0700
Message-ID: <CAA+hA=R8hLZMyRASRim28MNzX4jyE3nsaJ3DPzgxDtUmqtH62w@mail.gmail.com>
Subject: Re: [PATCH v1 1/5] ARM: imx28: add basic dt support
From: Dong Aisheng <dongas86@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: =?ISO-8859-1?Q?Lothar_Wa=DFmann?= <LW@karo-electronics.de>,
        Dong Aisheng <aisheng.dong@freescale.com>,
        "vinod.koul@linux.intel.com" <vinod.koul@linux.intel.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 3:02 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Mon, 19 Mar 2012 17:49:02 +0100, Lothar Waﬂmann <LW@KARO-electronics.de> wrote:
>> Hi,
>>
>> Grant Likely writes:
>> > On Mon, 19 Mar 2012 07:54:33 +0100, Lothar Waﬂmann <LW@KARO-electronics.de> wrote:
>> > > Grant Likely writes:
>> > > > On Fri, 16 Mar 2012 11:01:35 +0800, Dong Aisheng <aisheng.dong@freescale.com> wrote:
>> > > > > On Thu, Mar 15, 2012 at 07:22:04PM +0800, Lothar Waﬂmann wrote:
>> > > > > > Dong Aisheng writes:
>> > > > > > > On Thu, Mar 15, 2012 at 02:53:29PM +0800, Lothar Waﬂmann wrote:
>> > > > > > Anyway there is no definite spec how the MAC address(es) are stored
>> > > > > > in the fuse map. Thus reading the MAC from there is more or less
>> > > > > > platform specific.
>> > > > > >
>> > > > > It's just provide one more option since there are customers storing the MAC
>> > > > > in the fuse map.
>> > > >
>> > > > That should be straight forward to support; have a property that
>> > > > specifies the method used for fetching/calculating the MAC.
>> > > >
>> > > Executable code stored inside a DT blob? ;)
>> >
>> > I know you're joking here, but I'm going to answer seriously
>> > anyway... Absolutely not. †What I'm suggesting is a property that
>> > specifies the method used to determine the mac address. †Something
>> > like (off the top of my head):
>> >
>> > † † local-mac-address = [01 02 03 00 00 00];
>> > † † local-mac-mask = [0xff 0xff 0xff 0 0 0];
>> > † † mac-encoding = "append-serial-number";
>> >
>> That still does not specify where the remaining part of the MAC is
>> stored and how it should be retrieved.
>
> I'm suggesting that you define a string that means something specific;
> that hopefully can be shared by multiple platforms. †For example,
> "append-serial-number" might mean start with the values selected by
> AND of local-mac-address and local-mac-mask, and OR in the board's
> serial number. †You would need to define something that worked if this
> was the solution you used.
>
I'm intend to Grant's this suggestion.
This can be shared by all other imx platforms which stores mac address in
fuse map and this is commonly used by customer.
Then we do not need keep writing repeat code for different platforms
via platform
data.

For Lothar's question, we can add a property fuse_mac_offset to indicate
read mac from fuse map and where to read it.
For how many bytes to read, we can calculate it from the local-mac-mask.
For example, local-mac-mask = [0xff 0xff 0xff 0 0 0], we can get the size
as 3 bypes.

Then we have three properties:
local-mac-address = [01 02 03 00 00 00];
local-mac-mask = [0xff 0xff 0xff 0 0 0];
fuse_mac_offset = <1>;

In fec driver, the final mac address can be got by:
local-mac-address & local-mac-mask | (read_fuse(1) & 0xffffff)

Lathar,
Do you think if this is ok?

>> > Okay, if so then it would be wise to have a reliable function for the
>> > MAC driver to call to lookup it's address as determined by platform
>> > code. †Alternately, the platform code can write the correct mac
>> > address into the device tree node at init time (see
>> > prom_update_property() and prom_add_property()).
>> >
>> That sounds good. Didn't know about those functions. That could be
>> used to mimic the current behaviour of supplying the MAC via
>> platform_data.
>
> I'm okay with doing this; but make sure you remove the bogus
> local-mac-address from the .dts file.
>
This is a backup solution to me if the above solution you suggested can not
work.

Regards
Dong Aisheng
