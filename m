Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab2JKIU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 04:20:59 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:39092 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab2JKIUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 04:20:55 -0400
Date: Thu, 11 Oct 2012 01:20:51 -0700
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
Message-ID: <20121011082051.GB32175@core.coreip.homeip.net>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
 <1349496603-20775-2-git-send-email-cheiny@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349496603-20775-2-git-send-email-cheiny@synaptics.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 09:09:58PM -0700, Christopher Heiny wrote:
> +
> +	int (*write_block)(struct rmi_phys_device *phys, u16 addr, u8 *buf,
> +			   int len);
> +	int (*read_block)(struct rmi_phys_device *phys, u16 addr, u8 *buf,
> +			  int len);
> +

If you declare your buffer as [const] void * instead of u8 * I think you
will be able to get rid of most of your unions.

> +
> +/**
> + * Helper fn to convert a byte array representing a 16 bit value in the RMI
> + * endian-ness to a 16-bit value in the native processor's specific endianness.
> + * We don't use ntohs/htons here because, well, we're not dealing with
> + * a pair of 16 bit values. Casting dest to u16* wouldn't work, because
> + * that would imply knowing the byte order of u16 in the first place.  The
> + * same applies for using shifts and masks.
> + */
> +static inline u16 batohs(u8 *src)
> +{
> +	return src[1] * 0x100 + src[0];
> +}
> +
> +/**
> + * Helper function to convert a 16 bit value (in host processor endianess) to
> + * a byte array in the RMI endianess for u16s.  See above comment for
> + * why we dont us htons or something like that.
> + */
> +static inline void hstoba(u8 *dest, u16 src)
> +{
> +	dest[0] = src % 0x100;
> +	dest[1] = src / 0x100;
> +}

These are not used anymore, right?

-- 
Dmitry
