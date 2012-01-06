Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893Ab2AFGfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 01:35:55 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:50391 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751447Ab2AFGfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 01:35:53 -0500
Date: Thu, 5 Jan 2012 22:35:46 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: Re: [RFC PATCH 1/11] input: RMI4 public header file and
 documentation.
Message-ID: <20120106063546.GA10447@core.coreip.homeip.net>
References: <1324519802-23894-1-git-send-email-cheiny@synaptics.com>
 <1324519802-23894-2-git-send-email-cheiny@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324519802-23894-2-git-send-email-cheiny@synaptics.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 06:09:52PM -0800, Christopher Heiny wrote:
> +
> +/* Helper fn to convert a byte array representing a short in the RMI
> + * endian-ness to a short in the native processor's specific endianness.
> + * We don't use ntohs/htons here because, well, we're not dealing with
> + * a pair of shorts. And casting dest to short* wouldn't work, because
> + * that would imply knowing the byte order of short in the first place.
> + */
> +static inline void batohs(unsigned short *dest, unsigned char *src)
> +{
> +	*dest = src[1] * 0x100 + src[0];
> +}
> +
> +/* Helper function to convert a short (in host processor endianess) to
> + * a byte array in the RMI endianess for shorts.  See above comment for
> + * why we dont us htons or something like that.
> + */
> +static inline void hstoba(unsigned char *dest, unsigned short src)
> +{
> +	dest[0] = src % 0x100;
> +	dest[1] = src / 0x100;
> +}

We have nice set of be/le16_to_cpu and cpu_to_be/le16 helpers that do
just that and in much more efficient way.

> +
> +/* Utility routine to handle writes to read-only attributes.  Hopefully
> + * this will never happen, but if the user does something stupid, we don't
> + * want to accept it quietly (which is what can happen if you just put NULL
> + * for the attribute's store function).
> + */
> +static inline ssize_t rmi_store_error(struct device *dev,
> +			struct device_attribute *attr,
> +			const char *buf, size_t count)
> +{
> +	dev_warn(dev,
> +		 "RMI4 WARNING: Attempt to write %d characters to read-only "
> +		 "attribute %s.", count, attr->attr.name);
> +	return -EPERM;
> +}
> +
> +/* Utility routine to handle reads of write-only attributes.  Hopefully
> + * this will never happen, but if the user does something stupid, we don't
> + * want to accept it quietly (which is what can happen if you just put NULL
> + * for the attribute's show function).
> + */
> +static inline ssize_t rmi_show_error(struct device *dev,
> +		       struct device_attribute *attr,
> +		       char *buf)
> +{
> +	dev_warn(dev,
> +		 "RMI4 WARNING: Attempt to read from write-only attribute %s.",
> +		 attr->attr.name);
> +	return -EPERM;
> +}

Although these methods are not needed, a general comment nonetheless: do
not put in header files and mark inline functions which address is taken
and used elsewhere.

Thanks.

-- 
Dmitry
