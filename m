Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab1LAHG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 02:06:29 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:38443
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751201Ab1LAHG1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 02:06:27 -0500
X-SpamScore: -17
X-BigFish: VS-17(zz936eK542M1432N98dKzz1202hzzz2dh2a8h668h839h8e2h8e3h945h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Tang Yuantian-B29983 <B29983@freescale.com>
To: Jean Delvare <khali@linux-fr.org>
CC: "guenter.roeck@ericsson.com" <guenter.roeck@ericsson.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Huang Changming-R66093 <r66093@freescale.com>
Subject: RE: [PATCH] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA
Thread-Topic: [PATCH] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA
Thread-Index: AQHMpIUnsb9+I0lR9k+0uRq1j4EoUpWwJ/0AgAAFb4CAAAQAAIAAAwAAgAAOBACAAAE+gIAAAP2AgBZhFkA=
Date: Thu, 1 Dec 2011 07:06:20 +0000
Message-ID: <3C06C26914DACA4BB3A368F78CA0B3A712FE70@039-SN1MPN1-004.039d.mgd.msft.net>
References: <1321338462-6138-1-git-send-email-guenter.roeck@ericsson.com>
	<CAOZdJXUPO5PyMkAw-2EPvy_qSUuqsgUA7Gr8mKUX7HyShoXk3g@mail.gmail.com>
	<E6AF40B3BFC8A9428EACB47497F0F4B62DC687@039-SN1MPN1-002.039d.mgd.msft.net>
	<ECEE0D23-8F53-402C-A97F-4DB0F0E9C79B@freescale.com>
	<1321464509.7847.41.camel@oslab-l1>
	<1321464968.2309.384.camel@groeck-laptop>
	<1321466135.7847.55.camel@oslab-l1>
	<20111116190954.67c846fc@endymion.delvare>
	<1321467638.7847.73.camel@oslab-l1>
	<20111116201048.4b7877dd@endymion.delvare>
	<1321470915.7847.122.camel@oslab-l1>
 <20111116201847.6b11dc7f@endymion.delvare>
In-Reply-To: <20111116201847.6b11dc7f@endymion.delvare>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.75]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Has the patch been accepted?

Regards,
Yuantian

> -----Original Message-----
> From: Jean Delvare [mailto:khali@linux-fr.org]
> Sent: 2011年11月17日 3:19
> To: sun york-R58495
> Cc: guenter.roeck@ericsson.com; Tabi Timur-B04825; linux-
> i2c@vger.kernel.org; linux-kernel@vger.kernel.org; Tang Yuantian-B29983
> Subject: Re: [PATCH] i2c/busses: (mpc) Add support for
> SMBUS_READ_BLOCK_DATA
> 
> On Wed, 16 Nov 2011 11:15:15 -0800, York Sun wrote:
> > On Wed, 2011-11-16 at 20:10 +0100, Jean Delvare wrote:
> > > On Wed, 16 Nov 2011 10:20:38 -0800, York Sun wrote:
> > > > On Wed, 2011-11-16 at 19:09 +0100, Jean Delvare wrote:
> > > > > Your thinking is too focused on I2C block reads (or even block
> > > > > read of data over the network or on disk). SMBus block read is
> > > > > something completely different. It's not about reading 200 bytes
> > > > > of data and receiving it in 16-byte chunks (I2C block read works
> > > > > that way, on EEPROMs in particular.) There is no "data length"
> > > > > and "block size" to compare to each other. It's about reading
> > > > > the value of _one_ register and this value happens to be
> > > > > multi-byte. There is typically _no_ register pointer increment
> > > > > (automatic or not) involved as can happen with EEPROMs. If an
> > > > > SMBus block read from register N returns 10 bytes, you're not
> > > > > going to read the next 10 bytes from register N+10. There are no
> > > > > "next 10 bytes" to read, and register N+10 is something
> completely unrelated.
> > > > >
> > > > > And for this reason, it is not possible to mix SMBus block reads
> > > > > with byte reads, as can be done with I2C block reads.
> > > > >
> > > > > Also note that there is a limit of 32 bytes for SMBus block
> > > > > transfers, per SMBus specification. All slaves and masters must
> comply with it.
> > > > >
> > > > > I hope I managed to clarify the case this time...
> > > >
> > > > You have made it much clear. If block size is fixed and block read
> > > > cannot mix with byte read, shall we do this
> > > >
> > > > if length < block_size
> > > >    read block_size
> > > > else {
> > > >    while (length) {
> > > >        read block_size
> > > >        length -= block_size
> > > >    }
> > >
> > > Which part of
> > >
> > >   There is no "data length" and "block size" to compare to each other.
> > >
> > > did you not understand?
> >
> > For example, if the length is 40 and the block size is 32, are you
> > going to read 32, 72 byte or 64 byte?
> 
> The length is not 40. Which part of
> 
>   Also note that there is a limit of 32 bytes for SMBus block transfers,
>   per SMBus specification. All slaves and masters must comply with it.
> 
> did you now understand?
> 
> Really, please. I understand you're only trying to help and understand
> the patch, but at some point, if you have zero knowledge about the topic,
> you're not the right person to review the patch, period. You are still
> welcome to test the patch if you can and want, that's a completely
> different task.
> 
> --
> Jean Delvare


