Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab2I0PSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 11:18:46 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49386 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab2I0PSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 11:18:45 -0400
Date: Thu, 27 Sep 2012 08:18:41 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dave Airlie <airlied@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ben Skeggs <bskeggs@redhat.com>
Subject: Re: debugfs file creation from a user process ioctl
Message-ID: <20120927151841.GB23895@kroah.com>
References: <CAPM=9twE-xoeFgKGyRuF1mwn17XUhxvoLTgJU1UC3CaHnrwFNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9twE-xoeFgKGyRuF1mwn17XUhxvoLTgJU1UC3CaHnrwFNQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 02:17:05PM +1000, Dave Airlie wrote:
> Hi guys,
> 
> we've been seeing an error with nouveau and I'm not sure if its new or
> we just never spent time looking into it.
> 
> The basics are when a new drm client opens the device it gets a
> channel assigned, we allocate the channel and a side effect of channel
> allocation is we get a file in debugfs with some info on the channel.
> However this fails as the process context we are in is non-root, and
> the directory is 755.

But the kernel is the thing that is creating the file, so shouldn't it
be created no matter the permission setting?  I guess I never thought of
something other than the "root" process ever creating debugfs files,
odd.

> I don't think I want to be modifiying fsuid, but is there another
> practical way to do this, its not majorly urgent, Ben has indicated
> he's probably ripping the channel debugfs code out but I was just
> wondering for future reference.

I don't think anything other than modifying fsuid would work here,
sorry.  Put it in the "create the debugfs file" function and you should
be fine.

thanks,

greg k-h
