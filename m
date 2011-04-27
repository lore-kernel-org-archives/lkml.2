Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208Ab1D0NqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:46:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756090Ab1D0NqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:46:18 -0400
Date: Wed, 27 Apr 2011 15:46:13 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Thomas Sattler <tsattler@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: iotop: khugepaged at 99.99% (2.6.38.3)
Message-ID: <20110427134613.GI32590@random.random>
References: <4DAF6C0B.3070009@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DAF6C0B.3070009@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 01:28:11AM +0200, Thomas Sattler wrote:
> Hi there ...
> 
> While running firefox (>50 open Tabs), khugepaged jumped to 99.99%
> (according to 'iotop').  I killed firefox and nearly all running
> programs but khugepaged was still at 99.99% IO while the system
> was almost idle. I waited about 10 minutes, no improvement, so
> I rebooted the machine.
> 
> I observed this since 2.6.38 (I never run 2.6.37). This time the
> system was still responsive. When I observed the same thing with
> 2.6.38.x (x<3), the system became unresponsive within minutes
> after khugepaged hit 99%, see http://lkml.org/lkml/2011/4/7/306
> 
> All this happened five times since 2.6.38 became stable. It does
> not happen at boot time, but days (or weeks) later.

With only this info, I'm unsure what it could be, maybe something gets
corrupt in the vma layout and khugepaged flips on it... If this was a
race in khugepaged it shouldn't be only you triggering it.

Could you press SYSRQ+l next time it happens?

echo l >/proc/sysrq-trigger will work too. That should tell us where
khugepaged loops and from there we can guess which part of the VM is
corrupt.

Please also verify not to have any oops in "dmesg" by the time
khugepaged start spinning. The output of sysrq+l will also end up in
dmesg so if you post all the dmesg output we'll see if something else
happened before it.

Thanks a lot and sorry for this (though at this point I'm unsure if
khugepaged is the source problem or maybe more likely the symptom of
something else),

Andrea
