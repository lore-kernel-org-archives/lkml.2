Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067Ab2HWRDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:03:38 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54249 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab2HWRDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:03:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120823174613.0489837d@pyramind.ukuu.org.uk>
References: <CACVXFVNYCZqxt9B=9F_71KP0gdinGbNXd_ePQ10NKsCGd1dY4g@mail.gmail.com>
	<CACVXFVOMdWQSutkBzdcLJ-ozmecq_p-yzYJbtoLVUafz5KV=KQ@mail.gmail.com>
	<CAPXgP13LBR6GD=VomBPim3mDPy1bJ=eFBZ=oDaKZCjEo=Xp94Q@mail.gmail.com>
	<CACVXFVMFKGPv9Am0KzKSVsRamcA8EMMnD0kQO40MJ6OsjK4Eow@mail.gmail.com>
	<20120823174613.0489837d@pyramind.ukuu.org.uk>
Date: Fri, 24 Aug 2012 01:03:32 +0800
Message-ID: <CACVXFVOCXQnciE1GymwvuX2gQ4pm4wBhc2GmHN7AMDchcT8_qw@mail.gmail.com>
Subject: Re: udev 182: response timeout for request_firmware in module_probe path
From: Ming Lei <tom.leiming@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kay Sievers <kay@vrfy.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        systemd-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 12:46 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> IMO, the driver probing path is allowed to sleep, so looks request firmware
>> should be allowed inside .probe().
>
> I'm not convinced about that. It can sleep but its holding various locks
> in most cases, and it looks like that can end up in a complete heap.

Currently, only wait_for_completion() pends in the path of request_firmware
without holding other locks.

>
> By all means *request* the firmware asynchronously in the probe, but
> there needs to be a seperate method somewhere after the probe to finish
> the job once the firmware appears.

Yes, request asynchronously will work and introduce a bit complexity
(but it is not a big deal)

Looks the focus is that why request_firmware can't be used in driver
.probe().

IMO, we should consider that most of drivers call request_firmware
inside its .probe(), and maybe udev need to support the usage.


Thanks,
-- 
Ming Lei
