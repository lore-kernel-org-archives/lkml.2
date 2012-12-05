Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab2LEQ4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:56:51 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52565 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab2LEQ4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:56:50 -0500
Date: Wed, 5 Dec 2012 08:56:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Serban Constantinescu <Serban.Constantinescu@arm.com>
Cc: "arve@android.com" <arve@android.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "ccross@android.com" <ccross@android.com>,
        "zach.pfeffer@linaro.org" <zach.pfeffer@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: Fwd: Re: [PATCH 1/2] Staging: android: binder: Add support for
 32bit binder calls in a 64bit kernel
Message-ID: <20121205165645.GA28014@kroah.com>
References: <50BF5AA6.5080103@arm.com>
 <50BF78D5.4060003@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50BF78D5.4060003@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 04:39:49PM +0000, Serban Constantinescu wrote:
> >I was wondering when someone would notice that this code was not going
> >to work for this type of system, nice to see that you are working to fix
> >it up.  But, I'll reask Dan's question here, why not use the compat32
> >ioctl interface instead?  Shouldn't that be the easier way to do this?
> 
> Binder uses a 2 layer ioctl structure i.e. you can't know from the top
> of the ioctl handler the size of the incoming package.

How is this different from all other ioctl handlers in drivers?

> Therefore adding a wrapper for a 64bit kernel is not an option.

Really?  Have you tried?  And the wrapper isn't for the 64bit kernel,
it's the other way around, see the compat32 ioctl code for details.

> Should a 64bit Android ever appear we would probably want to support
> 32bit legacy applications.

I agree, this should be fixed, but please do so in the way that we fixed
the rest of the kernel for this problem, don't do it in a custom way
please.

> For this we will need the same binder/ashmem driver to service both a
> 32bit application as well as a 64bit application in a 64bit kernel.
> Therefore I guess the way forward will be to support 32bit file systems
> in a 64bit kernel without any change to the existing user space
> (implemented in this patch) and at some point extend the ioctl range
> with the needed functionality for 64bit user space.

Filesystems shouldn't have anything to do with the problems, it's the
mode that the kernel is running in here, right?

> >Also, one meta comment, never use the uint32_t types, use the native
> >kernel types (u32 and the like.)  If you are crossing the user/kernel
> >boundry, use the other correct types for those data structures (__u32
> >and the like).  What you did here is mix and match things so much that I
> >really can't verify that it is all correct.
> 
> I have tried to in-line my changes with the types already used in the
> driver but I will update to using the suggested types.

Feel free to send a patch first, to fix up the types in the drivers, and
then build on it, if you wish to make it easier for you.  I imagine this
will be a patch series anyway, if you wish to make it easy for us to
review (hint, you do...)

thanks,

greg k-h
