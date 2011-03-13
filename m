Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab1CMXaj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 19:30:39 -0400
Received: from kroah.org ([198.145.64.141]:54340 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859Ab1CMXah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 19:30:37 -0400
Date: Sun, 13 Mar 2011 16:26:12 -0700
From: Greg KH <greg@kroah.com>
To: andy.green@linaro.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [RFC PATCH 3/4] PLATFORM: Introduce async platform_data attach
 api
Message-ID: <20110313232612.GA13784@kroah.com>
References: <20110312222633.27020.19543.stgit@otae.warmcat.com>
 <201103131141.07380.rjw@sisk.pl>
 <4D7CB15A.6030203@linaro.org>
 <201103131353.54612.rjw@sisk.pl>
 <4D7CC4D0.90305@linaro.org>
 <20110313161528.GB10718@kroah.com>
 <4D7CFB3B.8060008@linaro.org>
 <20110313174811.GA11504@kroah.com>
 <4D7D0933.9010502@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7D0933.9010502@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 13, 2011 at 06:13:07PM +0000, Andy Green wrote:
> On 03/13/2011 05:48 PM, Somebody in the thread at some point said:
> >On Sun, Mar 13, 2011 at 05:13:31PM +0000, Andy Green wrote:
> >>So when there's a bit more of Device Tree in evidence, are you going
> >>to accept Device-tree based patches in usbnet etc along these lines,
> >>or does that trigger the "do it in userspace" response, in which
> >>case we are both wasting each others' time continuing to discuss
> >>this at all?
> >
> >As mentioned numerous times before, network naming stuff happens in
> >userspace, not in the kernel, so no matter what infrastructure is added,
> 
> The naming of that network interface happens in smsc95xx, in kernel:
> it uses a dodgy heuristic to choose between usb%d eth%d and others
> and gets it wrong in this case due to stuff outside its view.
> There's nothing golden and wonderful about that which needs
> protecting from outside hints.

Then why not always do this in userspace correctly?  It's the _exact_
same problem that the server companies have in naming their network
devices in a proper manner (i.e. the port with the 0 label on it wants
to always be eth0).  We have the tools today to solve this issue, in a
consistant and proper manner, please use them.

> >insisting on naming the network device 'eth0' is not going to happen
> >within the kernel.  Please use the tools we have today to do this with
> >no kernel changes.
> >
> >As for other changes, it all depends on what you need to accomplish,
> >right?  Those will be gladly reviewed on a case-by-case basis.
> 
> The immediate thing I would have liked to accomplish is to help
> smsc95xx make the right decision about naming and to use the MAC
> address in platform_data.  It seemed this was a general issue
> though, so I generalized how it was done.  But I don't have examples
> on my desk of boards with soldered-on USB other than smsc95xx
> Ethernet bridge.
> 
> At least, I am grateful we get down to brass tacks now and you
> clearly reject allowing the driver to take guidance to act more
> appropriately for its environment in the first place.  Therefore,
> this won't get fixed by Device Tree either.

I beg to differ.  I'm stating that USB drivers can not use their
numbering to do anything with them as that is never going to be
deterministic.

That's all.  You seem to disagree with this.

> So, we don't need to discuss this any further: thanks again for your
> time.

Ok, so does this mean that you are convinced that I am correct here, or
are just giving up and going to keep your patches outside of the kernel,
or something else?

confused,

greg k-h
