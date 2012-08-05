Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab2HEQ6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 12:58:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57930 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab2HEQ6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 12:58:31 -0400
Date: Sun, 5 Aug 2012 09:58:26 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: BUG: unable to handle kernel paging request in usb_match_id()
Message-ID: <20120805165826.GB13913@kroah.com>
References: <20120805025938.GA8954@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120805025938.GA8954@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2012 at 10:59:38AM +0800, Fengguang Wu wrote:
> Hi all,
> 
> This line triggers an oops in kvm boot test:
> 
> usb_match_id():
> ==>      748         for (; id->idVendor || id->idProduct || id->bDeviceClass ||
>          749                id->bInterfaceClass || id->driver_info; id++) {
>          750                 if (usb_match_one_id(interface, id))
>          751                         return id;
>          752         }
> 
> It's an old bug and happens also in linux 3.0. It's very reproducible
> for the attached config. I can send the initrd (yocto-minimal-i386.cgz)
> on your request in private email.

Odds are a driver without a terminating NULL for the device id list is
causing this to fail.

What devices are in the system and what drivers are trying to be bound?

greg k-h
