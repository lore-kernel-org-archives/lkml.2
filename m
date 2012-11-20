Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab2KTQdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:33:15 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34864 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab2KTQdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:33:12 -0500
Date: Tue, 20 Nov 2012 08:33:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] [firmware_class] Fix compile with no builtin firmware
Message-ID: <20121120163309.GB4990@kroah.com>
References: <1353422714-18327-1-git-send-email-pizza@shaftnet.org>
 <CACVXFVM=+Gus1_6U82G6_mszoRNsqb24Y+F7UPPLPBgzQasaew@mail.gmail.com>
 <20121120161011.GD18015@shaftnet.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120161011.GD18015@shaftnet.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 11:10:11AM -0500, Solomon Peachy wrote:
> On Wed, Nov 21, 2012 at 12:01:40AM +0800, Ming Lei wrote:
> > > drivers/built-in.o: In function `release_firmware':
> > > (.text+0x192e2): undefined reference to `__end_builtin_fw'
> > > drivers/built-in.o: In function `release_firmware':
> > > (.text+0x19304): undefined reference to `__end_builtin_fw'
> > > drivers/built-in.o: In function `_request_firmware':
> > > firmware_class.c:(.text+0x1986c): undefined reference to `__end_builtin_fw'
> > > firmware_class.c:(.text+0x19886): undefined reference to `__end_builtin_fw'
> > > firmware_class.c:(.text+0x19a98): undefined reference to `__end_builtin_fw'
> > > drivers/built-in.o: In function `release_firmware':
> > > (.text+0x192dc): undefined reference to `__start_builtin_fw'
> > > drivers/built-in.o: In function `_request_firmware':
> > > firmware_class.c:(.text+0x19860): undefined reference to `__start_builtin_fw'
> > > firmware_class.c:(.text+0x19a8a): undefined reference to `__start_builtin_fw'
> > 
> > I have tried to reproduce the compile failure but not succeed, could you share
> > your .config?
> 
> The corresponding .config is attached.  Note that it is for a uClinux 
> 3.3.0-uc0 kernel.

Lots of things have changed in the firmware code since 3.3.0, can you
retest this on the 3.7-rc6 tree?

Also, when sending patches, please cc: the proper maintainers (the
scripts/get_maintainers.pl tool can help you with that.)

thanks,

greg k-h
