Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727Ab2JQTDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 15:03:04 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53232 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757696Ab2JQTDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 15:03:02 -0400
X-Sasl-enc: nnpyiDh30Mg5QipYAkt4DTjLwmst4S2hoB0Jm5d1Xrpk 1350500581
Date: Wed, 17 Oct 2012 12:03:00 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Tony Luck <tony.luck@intel.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/5] drivers/base: Add a DEVICE_BOOL_ATTR macro
Message-ID: <20121017190300.GB25996@kroah.com>
References: <1350472435-29307-1-git-send-email-bp@amd64.org>
 <1350472435-29307-2-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350472435-29307-2-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 01:13:51PM +0200, Borislav Petkov wrote:
> +ssize_t device_store_bool(struct device *dev, struct device_attribute *attr,
> +			  const char *buf, size_t size)
> +{
> +	struct dev_ext_attribute *ea = to_ext_attr(attr);
> +	u8 bval;
> +
> +	if (kstrtou8(buf, 10, &bval) < 0)
> +		return -EINVAL;
> +
> +	*(bool *)ea->var = !!bval;
> +
> +	return size;
> +}
> +EXPORT_SYMBOL_GPL(device_store_bool);

Wouldn't it be nice to be able to accept 'y' 'Y' 'n' 'N' '0' and '1'
like the module bool parameter code does?  That would make things a bit
more consistent, and possibly allow you to use this function for the
module sysfs file handling as well.

greg k-h
