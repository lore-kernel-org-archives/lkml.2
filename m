Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab2LDQSC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 11:18:02 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61863 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2LDQSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 11:18:00 -0500
Date: Tue, 4 Dec 2012 08:17:56 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: arve@android.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, ccross@android.com, zach.pfeffer@linaro.org,
        Dave.Butcher@arm.com
Subject: Re: [PATCH 1/2] Staging: android: binder: Add support for 32bit
 binder calls in a 64bit kernel
Message-ID: <20121204161756.GB17860@kroah.com>
References: <1354617854-25296-1-git-send-email-serban.constantinescu@arm.com>
 <1354617854-25296-2-git-send-email-serban.constantinescu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354617854-25296-2-git-send-email-serban.constantinescu@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 10:44:13AM +0000, Serban Constantinescu wrote:
> Android's IPC, Binder, does not support calls from a 32-bit userspace
> in a 64 bit kernel. This patch adds support for syscalls coming from a
> 32-bit userspace in a 64-bit kernel.
> 
> Most of the changes were applied to types that change sizes between
> 32 and 64 bit world. This will also fix some of the issues around
> checking the size of an incoming transaction package in the ioctl
> switch. Since  the transaction's ioctl number are generated using
> _IOC(dir,type,nr,size), a different userspace size will generate
> a different ioctl number, thus switching by _IOC_NR is a better
> solution.
> 
> The patch has been successfully tested on ARMv8 AEM and Versatile
> Express V2P-CA9.

Has it also been properly tested on a 32bit kernel and userspace to
verify that nothing broke?

I was wondering when someone would notice that this code was not going
to work for this type of system, nice to see that you are working to fix
it up.  But, I'll reask Dan's question here, why not use the compat32
ioctl interface instead?  Shouldn't that be the easier way to do this?

Also, one meta comment, never use the uint32_t types, use the native
kernel types (u32 and the like.)  If you are crossing the user/kernel
boundry, use the other correct types for those data structures (__u32
and the like).  What you did here is mix and match things so much that I
really can't verify that it is all correct.

thanks,

greg k-h
