Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab0GHPPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 11:15:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37045 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755930Ab0GHPPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 11:15:07 -0400
Date: Thu, 8 Jul 2010 08:13:45 -0700
From: Greg KH <gregkh@suse.de>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Patrick Pannuto <ppannuto@codeaurora.org>, dbrownell@users.sourceforge.net,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       sboyd@codeaurora.org
Subject: Re: [PATCH] usb: gadget: #include device.h in gadget.h
Message-ID: <20100708151345.GB12452@suse.de>
References: <4C35200C.2040209@codeaurora.org>
 <20100708033420.GA24135@suse.de>
 <4C35945F.9050502@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C35945F.9050502@ru.mvista.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 01:03:27PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> Greg KH wrote:
> 
> >>gadget.h uses structures defined in device.h, it must include it. In
> >>most cases, gadget.h is preceded by linux/platform_device.h, but if
> >>you are grouping headers sanely, device.h may not be pulled in until
> >>*after* gadget (e.g. mach/msm_device.h), thus gadget.h should not
> >>rely on something else #including device.h
> 
>    As well as a number of other headers. I have postaed a patch
> addressing the missing #include's already.

Yes I know, and my same statment stands.

> >>include/linux/usb/gadget.h:488: error: field 'dev' has incomplete type
> 
> >Why not just provide an "empty" prototype for whatever is needed.
> 
>    Empty prototype of what, 'struct device'? Have you looked at the code at all?

Nope, I try not to :)

> 	struct device			dev;

Ok, that wouldn't work.

> >How about just fixing up the .c file that the problem happens in, to
> >include device.h first?  Is this an issue in the current tree somehow?
> 
>    In my opinion, this is just insane approach.

Sorry, but that seems to go against what the rest of the kernel is
doing.

thanks,

greg k-h
