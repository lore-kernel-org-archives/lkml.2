Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964776Ab2JWWrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 18:47:35 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63098 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933543Ab2JWWrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 18:47:33 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chen <alexandra.chen@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: Re: [RFC PATCH 01/06] input/rmi4: Public header and documentation
Date: Tue, 23 Oct 2012 15:47:28 -0700
Message-ID: <17777387.ePXtLzIJab@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.9.2 (Linux/3.6.0+; KDE/4.9.2; x86_64; ; )
In-Reply-To: <50871C84.9090803@synaptics.com>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com> <20121011082051.GB32175@core.coreip.homeip.net> <50871C84.9090803@synaptics.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 23, 2012 03:39:00 PM Christopher Heiny wrote:
> On 10/11/2012 01:20 AM, Dmitry Torokhov wrote:
> > On Fri, Oct 05, 2012 at 09:09:58PM -0700, Christopher Heiny wrote:
> >> +
> >> +	int (*write_block)(struct rmi_phys_device *phys, u16 addr, u8 *buf,
> >> +			   int len);
> >> +	int (*read_block)(struct rmi_phys_device *phys, u16 addr, u8 *buf,
> >> +			  int len);
> >> +
> > 
> > If you declare your buffer as [const] void * instead of u8 * I think you
> > will be able to get rid of most of your unions.
> 
> Good point.  We'll explore that.  If you see it in the next patch,
> you'll know it worked out.
> 
> >> + * Helper fn to convert a byte array representing a 16 bit value in the
> >> RMI + * endian-ness to a 16-bit value in the native processor's specific
> >> endianness. + * We don't use ntohs/htons here because, well, we're not
> >> dealing with + * a pair of 16 bit values. Casting dest to u16* wouldn't
> >> work, because + * that would imply knowing the byte order of u16 in the
> >> first place.  The + * same applies for using shifts and masks.
> >> + */
> >> +static inline u16 batohs(u8 *src)
> >> +{
> >> +	return src[1] * 0x100 + src[0];
> >> +}
> >> +
> >> +/**
> >> + * Helper function to convert a 16 bit value (in host processor
> >> endianess) to + * a byte array in the RMI endianess for u16s.  See above
> >> comment for + * why we dont us htons or something like that.
> >> + */
> >> +static inline void hstoba(u8 *dest, u16 src)
> >> +{
> >> +	dest[0] = src % 0x100;
> >> +	dest[1] = src / 0x100;
> >> +}
> > 
> > These are not used anymore, right?
> 
> There are function drivers that we chose not to include that depend on
> these.  We'll drop these from rmi.h until we're ready to submit those
> other function drivers.

OK, in this case, like last time we discussed, your function drivers
should use cpu_to_le16() and le16_to_cpu() instead.

Thanks.

-- 
Dmitry
