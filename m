Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab1BQT2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 14:28:01 -0500
Received: from kroah.org ([198.145.64.141]:34983 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab1BQT16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 14:27:58 -0500
Date: Thu, 17 Feb 2011 11:20:06 -0800
From: Greg KH <greg@kroah.com>
To: james_p_freyensee@linux.intel.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com
Subject: Re: [PATCH 06/12] PTI header file.
Message-ID: <20110217192006.GA29448@kroah.com>
References: <james_p_freyensee@linux.intel.com>
 <1297193697-5417-1-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-2-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-3-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-4-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-5-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-6-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-7-git-send-email-james_p_freyensee@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297193697-5417-7-git-send-email-james_p_freyensee@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 11:34:51AM -0800, james_p_freyensee@linux.intel.com wrote:
> From: J Freyensee <james_p_freyensee@linux.intel.com>
> 
> This adds PTI header information for the PTI project.
> 
> Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> ---
>  include/linux/pti.h |   38 ++++++++++++++++++++++++++++++++++++++

Why does this have to be in include/linux/?  What other files use it?

>  1 files changed, 38 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/pti.h
> 
> diff --git a/include/linux/pti.h b/include/linux/pti.h
> new file mode 100644
> index 0000000..4b1c9f6
> --- /dev/null
> +++ b/include/linux/pti.h
> @@ -0,0 +1,38 @@
> +/*
> + *  Copyright (C) Intel 2010
> + *  Ken Mills <ken.k.mills@intel.com>

That's nice, where is Ken's signed-off-by?  We need that please.

> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
> + * USA

This paragraph is not needed, please remove it unless you are willing to
keep up with the FSF's office moves for the next 40+ years.

Same goes for this paragraph on other files in this patchset, please
remove it.

> + *
> + */
> +
> +#ifndef PTI_H_
> +#define PTI_H_
> +
> +/* basic structure used as a write address to the PTI HW */
> +struct masterchannel {

Pretty generic structure name, please prefix it with "pti_"

> +	u8 master;
> +	u8 channel;
> +};
> +
> +/* the following functions are defined in misc/pti.c */
> +void mipi_pti_writedata(struct masterchannel *mc, u8 *cp, int count);

"cp"?

> +struct masterchannel *mipi_request_masterchannel(u8 kerneluser);

kerneluser?

> +void mipi_release_masterchannel(struct masterchannel *mc);

"Mipi"?  What's that?

> +
> +#define APERTURE_14 0x3800000
> +#define APERTURE_LEN 0x400000

What are these for?

> +
> +#endif /*PTI_H_*/
> -- 
> 1.6.6.1
