Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab2KUBfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 20:35:50 -0500
Received: from mail-pb0-f66.google.com ([209.85.160.66]:56672 "EHLO
	mail-pb0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab2KUBft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 20:35:49 -0500
Date: Wed, 21 Nov 2012 09:35:28 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] [firmware_class] Fix compile with no builtin firmware
Message-ID: <20121121093528.4fe11c26@tom-ThinkPad-T410>
In-Reply-To: <20121120181203.GA7922@shaftnet.org>
References: <1353422714-18327-1-git-send-email-pizza@shaftnet.org>
	<CACVXFVM=+Gus1_6U82G6_mszoRNsqb24Y+F7UPPLPBgzQasaew@mail.gmail.com>
	<20121120161011.GD18015@shaftnet.org>
	<20121120163309.GB4990@kroah.com>
	<20121120181203.GA7922@shaftnet.org>
Organization: Ming
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2012 13:12:03 -0500
Solomon Peachy <pizza@shaftnet.org> wrote:

> On Tue, Nov 20, 2012 at 08:33:09AM -0800, Greg KH wrote:
> > > The corresponding .config is attached.  Note that it is for a uClinux 
> > > 3.3.0-uc0 kernel.
> > 
> > Lots of things have changed in the firmware code since 3.3.0, can you
> > retest this on the 3.7-rc6 tree?

Solomon, I can't duplicate the build failure with your .config on 3.7-rc5-next.

> 
> Not easily; My employer is contracted to do some driver porting and 
> we're stuck with the kernel the client provided.  However, the patch is 
> still relevant for upstream, because the underlying problem still 
> exists:
>  
>  * The #ifdef wraps code that pertains solely to built-in firmware, (ie 
>    CONFIG_FIRMWARE_IN_KERNEL) and has an #else path for when it's disabled.
>  * There is no point in a CONFIG_FW_LOADER test inside firmware_class.c 
>    when the file isn't even compiled unless CONFIG_FW_LOADER is defined.

Enabling CONFIG_EXTRA_FIRMWARE still can make one firmware built in kernel
even though CONFIG_FIRMWARE_IN_KERNEL isn't defined, so your patch will break
this case.

> 
> Perhaps the compile problem is solved in newer kernels (by always 
> generating an empty builtin firmware list?) but the #ifdef is still 
> incorrect.

Looks the problem hasn't been reported before.


Thanks,
-- 
Ming Lei
