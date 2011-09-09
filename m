Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439Ab1IISrD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 14:47:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933104Ab1IISrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 14:47:00 -0400
Date: Fri, 9 Sep 2011 11:45:47 -0700
From: Greg KH <gregkh@suse.de>
To: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
Cc: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: add new usb gadget for ACM and mass storage
Message-ID: <20110909184547.GB30278@suse.de>
References: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de>
 <20110908191146.GA8552@suse.de>
 <4E69D032.4050807@sensortherm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E69D032.4050807@sensortherm.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 10:37:06AM +0200, Klaus Schwarzkopf wrote:
> Am 08.09.2011 21:11, schrieb Greg KH:
> >On Thu, Sep 08, 2011 at 08:24:47PM +0200, Klaus Schwarzkopf wrote:
> >>This driver provides two functions in one configuration:
> >>a mass storage, and a CDC ACM (serial port) link.
> >>Heavily based on multi.c and cdc2.c
> >
> >I thought the "composite" framework make it so that drivers like this
> >were no longer needed.  Or am I mistaken somehow?
> >
> 
> 
> The "composite" framework enabled drivers with two or more
> functions. For example the cdc2.c driver have support for ECM and
> ACM.
> 
> 
> >>+ * This program is free software; you can redistribute it and/or modify
> >>+ * it under the terms of the GNU General Public License as published by
> >>+ * the Free Software Foundation; either version 2 of the License, or
> >>+ * (at your option) any later version.
> >
> >Do you really mean "any later version"?
> 
> 
> The acm_ms.c file is heavly based on the cdc2.c file with this
> paragraph. Can i change this without breaking the license?

No, just wanted to make sure that you, and your company (if any) was
positive that this is what you want to do here.

> >>+ * This program is distributed in the hope that it will be useful,
> >>+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >>+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >>+ * GNU General Public License for more details.
> >>+ *
> >>+ * You should have received a copy of the GNU General Public License
> >>+ * along with this program; if not, write to the Free Software
> >>+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> >
> >These two paragraphs are not needed, and the address is a very bad idea
> >to include in any file as it changes over time and I don't think you
> >want to keep up with the address location of the FSF for the next 40+
> >years.
> >
> >As an example of this, I am starting to get patches from the FSF to fix
> >up old addresses, 10 years after moving their office...
> >
> 
> OK, i remove this lines.
> 
> Can i remove this lines in all files of the directory drivers/usb/gadget?

I see you just did, thanks so much :)

> +#define CDC_VENDOR_NUM	0x1d6b	/* Linux Foundation */
> +#define CDC_PRODUCT_NUM	0x0106	/* CDC Composite: ACM + MS*/
> 
> I used the next free device ID from
> http://www.linux-usb.org/usb.ids, is this ok?

No it isn't, you need to ask me to assign you an id.  I'll do that when
I accept the patch for merging into the kernel, and not before.

I'd like to get some of the gadget driver developers to sign off on this
patch before accepting it...

thanks,

greg k-h
