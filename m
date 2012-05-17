Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760376Ab2EQVO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 17:14:26 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34235 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759614Ab2EQVOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 17:14:24 -0400
Message-ID: <1337289262.8872.4.camel@joe2Laptop>
Subject: Re: [PATCH v6 3/3] gpio: TS-5500 GPIO support
From: Joe Perches <joe@perches.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>, x86@kernel.org,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Date: Thu, 17 May 2012 14:14:22 -0700
In-Reply-To: <20120517210633.400633E0621@localhost>
References: <1334276935-11258-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	 <1334276935-11258-4-git-send-email-vivien.didelot@savoirfairelinux.com>
	 <20120517210633.400633E0621@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 15:06 -0600, Grant Likely wrote:
> On Thu, 12 Apr 2012 20:28:55 -0400, Vivien Didelot <vivien.didelot@savoirfairelinux.com> wrote:
> > From: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
[]
> > +/* "DIO" line to IO port mapping table for line's value */
> > +static const unsigned long line_to_port_map[] = {
> > +	0x7B, 0x7B, 0x7B, 0x7B, 0x7B, 0x7B, 0x7B, 0x7B,	/* DIO1_[0-7] */
> > +	0x7C, 0x7C, 0x7C, 0x7C, 0x7C, 0x7C,		/* DIO1_[8-13] */
> > +	0x7E, 0x7E, 0x7E, 0x7E, 0x7E, 0x7E, 0x7E, 0x7E,	/* DIO2_[0-7] */
> > +	0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F,		/* DIO2_[8-13] */
> > +	0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72,	/* LCD_[0-7] */
> > +	0x73, 0x73, 0x73				/* LCD_{EN,RS,WR} */
> > +};

There doesn't seem to be a reason to make this a ulong.
uchar would suffice.

> > +
> > +/* "DIO" line to IO port's bit map for line's value */
> > +static const int line_to_bit_map[] = {
> > +	0, 1, 2, 3, 4, 5, 6, 7,	/* DIO1_[0-7] */
> > +	0, 1, 2, 3, 4, 5,	/* DIO1_[8-13] */
> > +	0, 1, 2, 3, 4, 5, 6, 7,	/* DIO2_[0-7] */
> > +	0, 1, 2, 3, 4, 5,	/* DIO2_[8-13] */
> > +	0, 1, 2, 3, 4, 5, 6, 7,	/* LCD_[0-7] */
> > +	0, 7, 6			/* LCD_{EN,RS,WR} */

Nor this an int, s8 maybe.

> > +/* "DIO" line's direction control mapping table */
> > +static const unsigned long line_to_dir_map[] = {
> > +	0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A,	/* DIO1_[0-7] */
> > +	0x7A, 0x7A, 0x7A, 0x7A, 0, 0,			/* DIO1_[8-13] */
> > +	0x7D, 0x7D, 0x7D, 0x7D, 0x7D, 0x7D, 0x7D, 0x7D,	/* DIO2_[0-7] */
> > +	0x7D, 0x7D, 0x7D, 0x7D, 0, 0,			/* DIO2_[8-13] */
> > +	0x7D, 0x7D, 0x7D, 0x7D, 0x7D, 0x7D, 0x7D, 0x7D,	/* LCD_[0-7] */
> > +	0, 0, 0						/* LCD_{EN,RS,WR} */

uchar

> > +/* "DIO" line's direction control bit-mapping table */
> > +static const int line_to_dir_bit_map[] = {
> > +	0, 0, 0, 0, 1, 1, 1, 1,	/* DIO1_[0-7] */
> > +	5, 5, 5, 5, -1, -1,	/* DIO1_[8-13] */
> > +	0, 0, 0, 0, 1, 1, 1, 1,	/* DIO2_[0-7] */
> > +	5, 5, 5, 5, -1, -1,	/* DIO2_[8-13] */
> > +	2, 2, 2, 2, 3, 3, 3, 3,	/* LCD_[0-7] */
> > +	-1, -1, -1		/* LCD_{EN,RS,WR} */
> > +};

s8?

> Splitting up this data into 4 arrays seems odd.  I think it would be
> better to define a single table with a tuple for each line.

yup.


