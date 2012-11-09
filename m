Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab2KIFdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 00:33:17 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35565 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab2KIFdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 00:33:15 -0500
Date: Thu, 8 Nov 2012 21:33:11 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com
Subject: Re: [PATCH 1/3] input: spear-keyboard: Use devm_*() routines
Message-ID: <20121109053311.GA12105@core.coreip.homeip.net>
References: <9f07bb7dbf29978970d901bbe89add0a333cc925.1352381962.git.viresh.kumar@linaro.org>
 <20121108163835.GA8877@core.coreip.homeip.net>
 <CAKohpo=PdNoBzpZoHWcHSqh_az2OOGGGegNzCXPxjUDVOHostw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpo=PdNoBzpZoHWcHSqh_az2OOGGGegNzCXPxjUDVOHostw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 08:06:29AM +0530, Viresh Kumar wrote:
> On 8 November 2012 22:08, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > On Thu, Nov 08, 2012 at 07:10:47PM +0530, Viresh Kumar wrote:
> > It also breaks the error unwinding/removal of the driver as it frees
> > input device while IRQ handler is still active.
> 
> I have heard of this argument before, probably from you. :)
> Just need clarification again. How will we get an interrupt when the controller
> is stopped, unless we have a shared irq.

My bad, I missed that spear-keyboard driver implements open() and
close() methods and shuts off the device properly. Still, thanks for
switching everything to devm_*, I think it is much cleaner this way as
opposed to mixing managed and unmanaged resources.

Thanks.

-- 
Dmitry
