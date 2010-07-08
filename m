Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab0GHDg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 23:36:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:33330 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225Ab0GHDg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 23:36:58 -0400
Date: Wed, 7 Jul 2010 20:34:20 -0700
From: Greg KH <gregkh@suse.de>
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: dbrownell@users.sourceforge.net, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, sboyd@codeaurora.org
Subject: Re: [PATCH] usb: gadget: #include device.h in gadget.h
Message-ID: <20100708033420.GA24135@suse.de>
References: <4C35200C.2040209@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C35200C.2040209@codeaurora.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 05:47:08PM -0700, Patrick Pannuto wrote:
> gadget.h uses structures defined in device.h, it must include it. In
> most cases, gadget.h is preceded by linux/platform_device.h, but if
> you are grouping headers sanely, device.h may not be pulled in until
> *after* gadget (e.g. mach/msm_device.h), thus gadget.h should not
> rely on something else #including device.h
> 
> include/linux/usb/gadget.h:488: error: field 'dev' has incomplete type

Why not just provide an "empty" prototype for whatever is needed.
Generally, having header files include header files is frowned apon, and
a number of people have been working on slowly unwinding a lot of this
type of mess that we currently have.

> include/linux/usb/gadget.h: In function 'set_gadget_data':
> include/linux/usb/gadget.h:492:
> 	error: implicit declaration of function 'dev_set_drvdata'

Ick, but then, this gets messier.

How about just fixing up the .c file that the problem happens in, to
include device.h first?  Is this an issue in the current tree somehow?

thanks,

greg k-h
