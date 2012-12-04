Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab2LDDje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 22:39:34 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45017 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab2LDDjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 22:39:33 -0500
Date: Mon, 3 Dec 2012 19:41:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 2/2] New driver: Xillybus generic interface for FPGA
 (programmable logic)
Message-ID: <20121204034128.GC911@kroah.com>
References: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com>
 <1354117293-13632-2-git-send-email-eli.billauer@gmail.com>
 <20121128165719.GB31314@kroah.com>
 <50B8C7BF.4000004@gmail.com>
 <20121130163254.GB4478@kroah.com>
 <50BB8F43.4010208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50BB8F43.4010208@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 02, 2012 at 07:26:27PM +0200, Eli Billauer wrote:
> On 11/30/2012 06:32 PM, Greg KH wrote:
> >>>>>  >>+static struct class *xillybus_class;
> >>>>  >Why not just use the misc interface instead of your own class?
> >>>  When Xillybus is used, the whole system's mission is usually around
> >>>  it (e.g. it's a computer doing data acquisition through the Xillybus
> >>>  pipes). So giving it a high profile makes sense, I believe. Besides,
> >>>  a dozen of device files are not rare.
> >It is no problem to create dozens of misc devices.  It makes your driver
> >smaller, contain less code that I have to audit and you have to ensure
> >you got right, and it removes another user of 'struct class' which we
> >are trying to get rid of anyway.  So please, move to use a misc device.
> >
> 
> It has just occurred to me that DYNAMIC_MINORS is 64
> (drivers/char/misc.c), so I guess that limits the number of misc
> devices that can be generated, at least with dynamically allocated
> minors. I previously mentioned "a dozen" as the number of devices,
> but I've already run tests with 100+ devices, and I can also think
> of a sane application for that.
> 
> 
> So if I understood the situation correctly, it looks like using misc
> devices will create a limitation which will be reached sooner or
> later.
> 
> Any suggestion what to do?

Given that I don't really understand how you can have that many device
nodes, because I don't know what they all seem to be needed for, I can't
answer this question.

Again, any hints on the user/kernel api you use/need here?  Does it
really have to be device nodes?  What's wrong with the simple firmware
interface the kernel provides?

thanks,

greg k-h
