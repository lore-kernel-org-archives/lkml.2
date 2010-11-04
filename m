Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab0KDUd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 16:33:57 -0400
Received: from imr3.ericy.com ([198.24.6.13]:53337 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305Ab0KDUdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 16:33:55 -0400
Subject: Re: [RFC/PATCH] i2c/busses: Add support for Diolan U2C-12 USB/I2C
 adapter
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Jean Delvare <khali@linux-fr.org>
CC: Ben Dooks <ben-linux@fluff.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20101104211807.07a55104@endymion.delvare>
References: <1288830389-13873-1-git-send-email-guenter.roeck@ericsson.com>
	 <20101104134314.7928cd85@endymion.delvare>
	 <1288888902.22931.165.camel@groeck-laptop>
	 <20101104211807.07a55104@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Thu, 4 Nov 2010 13:32:45 -0700
Message-ID: <1288902765.22931.193.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Thu, 2010-11-04 at 16:18 -0400, Jean Delvare wrote:
> Hi Guenter,
> 
> On Thu, 4 Nov 2010 09:41:42 -0700, Guenter Roeck wrote:
> > On Thu, 2010-11-04 at 08:43 -0400, Jean Delvare wrote:
> > > I'm also unsure what is the point of having such a large buffer when
> > > the largest block you ever transfer in practice is 5 bytes?
> >
> > I took that from the Diolan code. They always use a 257 byte temp
> > buffer, since that is the maximum data size sent by the adapter. 
> > You are right, I should not really need that since I don't send any long
> > commands. Ultimate reason is to account for possible adapter errors, if
> > it replies (or tries to reply) with more bytes than expected. Pretty
> > much just playing safe.
> 
> Which commands are they using, which require such a large buffer? In
> your driver, bytes are all processed one by one, which is certainly not
> good performance-wise. If there is a way to read or write mode than one
> byte at a time, this would be worth a try.
> 
There are read/write block commands. Unfortunately, I never got it
working reliably :-(.

> > > (...)
> > > BTW, I'm not sure why you don't use the original buffer directly?
> > > memcpy is bad performance-wise.
> >
> > To account for the possibility that the adapter returns more bytes than
> > I am expecting. Sure, that would be a bug, but I wanted to play safe.
> 
> Hmm, OK, that makes sense.
> 
> > > (...)
> > > Should be -EPROTO according to Documentation/i2c/fault-codes.
> >
> > Ok. Note that I got that from i2c-algo-bit.c.
> 
> I would welcome a patch fixing this.
> 
Ok, I'll put that on my list. Note that there are several other i2c
drivers returning -EREMOTEIO.

> > > > (...)
> > > > +static u32 usb_func(struct i2c_adapter *a)
> > > > +{
> > > > +     return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL |
> > > > +         I2C_FUNC_SMBUS_READ_BLOCK_DATA;
> > > 
> > > Odd indentation/alignment.
> >
> > Seems to be exactly what other drivers do, so I am a bit at loss here.
> 
> Really? Using 4 spaces for indentation is wrong. Either use a tab, or
> align using 7 spaces.
> 
Ok.

> > > (...)
> > > You are abusing algo_data here. You are supposed to use
> > > i2c_get/set_adapdata() instead. algo_data is only there for providing
> > > platform specific implementation details to generic i2c algorithms such
> > > as i2c-algo-bit.
> >
> > Copied from i2c-tiny-usb.c. I didn't really think about it. Fixed.
> 
> I take patches ;)
> 
Ok. Another one to look at if I need a break ;).

Guenter


