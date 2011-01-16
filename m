Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab1APXUD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 18:20:03 -0500
Received: from ozlabs.org ([203.10.76.45]:40615 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510Ab1APXTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 18:19:53 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Module parameters and __initdata
Date: Mon, 17 Jan 2011 09:49:44 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; i686; ; )
Cc: Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1101051708520.1657-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1101051708520.1657-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101170949.45192.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jan 2011 08:46:59 am Alan Stern wrote:
> Is the proper use of "__initdata" with module parameters documented 
> anywhere?
> 
> I'm running into problems with drivers/usb/gadget/printer.c, which 
> includes code such as this:
> 
> 
> static ushort __initdata bcdDevice;
> module_param(bcdDevice, ushort, S_IRUGO);
> MODULE_PARM_DESC(bcdDevice, "USB Device version (BCD)");

You need to make perm 0.  You can't read it if it's freed after init!

Rusty.
