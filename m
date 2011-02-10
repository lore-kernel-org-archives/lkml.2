Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab1BJSGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:06:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51461 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756679Ab1BJSGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:06:30 -0500
Date: Thu, 10 Feb 2011 10:06:06 -0800
From: Greg KH <gregkh@suse.de>
To: Oren Weil <oren.jer.weil@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, david@woodhou.se,
        david.woodhouse@intel.com
Subject: Re: [RFC PATCH 13/13] Intel(R) MEI Driver
Message-ID: <20110210180606.GG13795@suse.de>
References: <0d30dc$l1diuf@orsmga001.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d30dc$l1diuf@orsmga001.jf.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 01:55:33AM -0800, Oren Weil wrote:
> diff --git a/include/linux/mei.h b/include/linux/mei.h
> new file mode 100644
> index 0000000..57c2d93
> --- /dev/null
> +++ b/include/linux/mei.h
> @@ -0,0 +1,118 @@
> +/* 
> +
> +  Intel(R) Management Engine Interface (Intel(R) MEI) Linux driver
> +  Intel(R) MEI Interface Header
> +
> +  This file is provided under a dual BSD/GPLv2 license.  When using or 
> +  redistributing this file, you may do so under either license.
> +
> +  GPL LICENSE SUMMARY
> +
> +  Copyright(c) 2003-2011 Intel Corporation. All rights reserved.
> +
> +  This program is free software; you can redistribute it and/or modify 
> +  it under the terms of version 2 of the GNU General Public License as
> +  published by the Free Software Foundation.
> +
> +  This program is distributed in the hope that it will be useful, but 
> +  WITHOUT ANY WARRANTY; without even the implied warranty of 
> +  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
> +  General Public License for more details.
> +
> +  You should have received a copy of the GNU General Public License 
> +  along with this program; if not, write to the Free Software 
> +  Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> +  The full GNU General Public License is included in this distribution 
> +  in the file called LICENSE.GPL.
> +
> +  Contact Information:
> +	  Intel Corporation.
> +	  

That's not a valid contact.  You forgot to put your name and email
address in here.

> +
> +  BSD LICENSE 
> +
> +  Copyright(c) 2003-2011 Intel Corporation. All rights reserved.
> +  All rights reserved.
> +
> +  Redistribution and use in source and binary forms, with or without 
> +  modification, are permitted provided that the following conditions 
> +  are met:
> +
> +    * Redistributions of source code must retain the above copyright 
> +      notice, this list of conditions and the following disclaimer.
> +    * Redistributions in binary form must reproduce the above copyright 
> +      notice, this list of conditions and the following disclaimer in 
> +      the documentation and/or other materials provided with the 
> +      distribution.
> +    * Neither the name of Intel Corporation nor the names of its 
> +      contributors may be used to endorse or promote products derived 
> +      from this software without specific prior written permission.
> +
> +  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
> +  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
> +  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
> +  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
> +  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
> +  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
> +  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
> +  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
> +  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
> +  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
> +  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> +
> +*/
> +
> +
> +#ifndef _LINUX_MEI_H
> +#define _LINUX_MEI_H
> +
> +/* IOCTL commands */
> +#define IOCTL_MEI_GET_VERSION \
> +	_IOWR('H' , 0x0, struct mei_message_data)

Why would a version ever be an ioctl?  There are zillions of other saner
ways to get this information from a driver.  Heck, there's even ways
that are standardized, why are you ignoring them?

> +#define IOCTL_MEI_CONNECT_CLIENT \
> +	_IOWR('H' , 0x01, struct mei_message_data)
> +#define IOCTL_MEI_WD \
> +	_IOWR('H' , 0x02, struct mei_message_data)
> +#define IOCTL_MEI_BYPASS_WD \
> +	_IOWR('H' , 0x10, struct mei_message_data)

No new ioctls unless you document them VERY well.

> +
> +/*
> + * Intel(R) MEI IOCTL user data struct

Please, the (R) stuff is annoying, drop it.

> + */
> +struct mei_message_data {
> +	u32 size;
> +	char *data;
> +} __packed;

Wrong types for ioctls, please use correct ones.  And you are handling
the 32/64 bit issues correctly, right?



> +
> +/*
> + * Intel(R) MEI driver/protocol version struct
> + */
> +struct mei_driver_version {
> +	u8 major;
> +	u8 minor;
> +	u8 hotfix;
> +	u16 build;
> +} __packed;
> +
> +
> +/*
> + * Intel(R) MEI client information struct
> + */
> +struct mei_client {
> +	u32 max_msg_length;
> +	u8 protocol_version;
> +} __packed;
> +
> +/*
> + * GUID (Globally Unique ID)
> + * For identifying Intel(R) ME Clients
> + * */
> +
> +struct guid {
> +	u32 data1;
> +	u16 data2;
> +	u16 data3;
> +	u8 data4[8];
> +};
> +
> +#endif
> 
> 
> ---------------------------------------------------------------------
> Intel Israel (74) Limited
> 
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.
