Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab1GMOqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 10:46:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44177 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab1GMOqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 10:46:31 -0400
Date: Wed, 13 Jul 2011 18:46:24 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, Cyril Chemparathy <cyril@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [RFC/RFT 2/2] davinci: use generic memory mapped gpio for
 tnetv107x
Message-ID: <20110713144624.GA7875@oksana.dev.rtsoft.ru>
References: <cover.1309840042.git.nsekhar@ti.com>
 <6639b07562e3e6643dd07d5ed3907cb5158ce16b.1309840042.git.nsekhar@ti.com>
 <20110706220240.GF5371@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110706220240.GF5371@ponder.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Wed, Jul 06, 2011 at 04:02:40PM -0600, Grant Likely wrote:
[...]
> > +		{
> > +			.name	= "dat",
> > +			.start	= TNETV107X_GPIO_BASE + 0x4,
> > +			.end	= TNETV107X_GPIO_BASE + 0x4 + 0x4 - 1,
> > +		},
> > +		{
> > +			.name	= "set",
> > +			.start	= TNETV107X_GPIO_BASE + 0x10,
> > +			.end	= TNETV107X_GPIO_BASE + 0x10 + 0x4 - 1,
> > +		},
> > +		{
> > +			.name	= "dirin",
> > +			.start	= TNETV107X_GPIO_BASE + 0x1c,
> > +			.end	= TNETV107X_GPIO_BASE + 0x1c + 0x4 - 1,
> > +		},
> > +		{
> > +			.name	= "en",
> > +			.start	= TNETV107X_GPIO_BASE + 0x28,
> > +			.end	= TNETV107X_GPIO_BASE + 0x28 + 0x4 - 1,
> > +		},
> > +	},
> > +};
> 
> Wow, this ends up looking horrible. (yes, I know it is not your
> fault).  I backed off earlier on using resources for the offsets, but
> I want to change my mind again and make interface a register range +
> offsets to the control registers.

Why is this horrible? Are you proposing a single resource + platform
data for the offsets? If so, this won't look any better, but in return

- this would complicate device registration logic and driver logic
  itself (i.e. we need to allocate platform data in the arch code,
  then parse and store the structure in the driver). The platform
  data is simply unnecessary -- we have resources that describe
  memory just fine, much better then raw 'unsigned long offset';

- we lose the ability to operate on spread registers (think of
  "enable" register is down below 2MB gap, near the pinmux
  registers block);

- In the device tree, we really want to describe registers in the
  regs = <> property, because that's where memory resources should
  be. (We also want to map address position into resource name, but
  that's different story).

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
