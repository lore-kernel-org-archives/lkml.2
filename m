Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab0KJRtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 12:49:14 -0500
Received: from kroah.org ([198.145.64.141]:44274 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114Ab0KJRtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 12:49:12 -0500
Date: Wed, 10 Nov 2010 09:49:26 -0800
From: Greg KH <greg@kroah.com>
To: Minkyu Kang <promsoft@gmail.com>
Cc: Minkyu Kang <mk7.kang@samsung.com>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        kyungmin.park@samsung.com, Ben Dooks <ben-i2c@fluff.org>
Subject: Re: [PATCH v2] misc: adds support the FSA9480 USB Switch
Message-ID: <20101110174926.GB13276@kroah.com>
References: <4C7CD95A.5040309@samsung.com> <20100917150731.f1f44f3c.akpm@linux-foundation.org> <AANLkTim2UhJAhOw1qHvZ9bbctR0tNSMvE61T=sxffHxO@mail.gmail.com> <4CB26931.5040105@samsung.com> <20101011173649.GC7116@kroah.com> <AANLkTi=vTkHJJ2dq5RZHHCwWYEBtY=Y7dPPh=Wzzx95f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=vTkHJJ2dq5RZHHCwWYEBtY=Y7dPPh=Wzzx95f@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 09:55:34AM +0900, Minkyu Kang wrote:
> Dear Greg KH,
> 
> On 12 October 2010 02:36, Greg KH <greg@kroah.com> wrote:
> > On Mon, Oct 11, 2010 at 10:32:33AM +0900, Minkyu Kang wrote:
> >> The FSA9480 is a USB port accessory detector and switch.
> >> This patch adds support the FSA9480 USB Switch.
> >>
> >> Signed-off-by: Minkyu Kang <mk7.kang@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> ---
> >> v2:
> >> ?use the threaded irq
> >> ?fix the sysfs
> >>
> >> ?drivers/misc/Kconfig ? ?| ? ?9 +
> >> ?drivers/misc/Makefile ? | ? ?1 +
> >> ?drivers/misc/fsa9480.c ?| ?544 +++++++++++++++++++++++++++++++++++++++++++++++
> >> ?include/linux/fsa9480.h | ? 40 ++++
> >
> > Why do you need a .h file here for a single driver?
> 
> Because of platform data.

Then put it in include/linux/platform_data/ instead please.

> > You are creating new sysfs files, so you are required to add a new
> > Documentation/ABI file as well, please add that to this patch.
> 
> ok.
> 
> >
> > And why are you exporting symbols from this driver, that should not be
> > needed at all.
> 
> It's for other drivers.
> For example.. When USB cable is connected, PMIC driver enable the
> power for each device. (USB, uart, audio and so on..)
> But if use the manual switch, PMIC driver can't know what device is enabled.
> So, this function was exported.

What drivers are using these functions?  Where is the code for them?
When will they be submitted for inclusion?

thanks,

greg k-h
