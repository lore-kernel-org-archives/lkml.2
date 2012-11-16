Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440Ab2KPBSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 20:18:46 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61304 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab2KPBSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 20:18:45 -0500
Date: Thu, 15 Nov 2012 17:18:41 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jon Mason <jon.mason@intel.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH v5 1/2] PCI-Express Non-Transparent Bridge Support
Message-ID: <20121116011841.GB32285@kroah.com>
References: <1352160669-4330-1-git-send-email-jon.mason@intel.com>
 <1352160669-4330-2-git-send-email-jon.mason@intel.com>
 <20121116002904.GA20876@kroah.com>
 <20121116010621.GI24723@jonmason-lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121116010621.GI24723@jonmason-lab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 06:06:21PM -0700, Jon Mason wrote:
> > > +static inline unsigned int ntb_query_max_cbs(struct ntb_device *ndev)
> > > +{
> > > +	return ndev->max_cbs;
> > > +}
> > 
> > It is shorter, and simpler, to just write the '->variable' version out
> > for this, than to make the function call here.  Why are these needed?
> > Especially when I see the driver code not using them.  Please remove.
> 
> This is used in ntb_transport.c.  It is used to show how many
> interrupts, and there-by clients, the transport layer can have.  I can
> make it a macro and/or put it in a header file, if that suits you
> better.

No, just reference the field of the structure directly, no need for a
function or a macro.

thanks,

greg k-h
