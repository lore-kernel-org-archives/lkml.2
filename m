Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760757Ab2C3MZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:25:04 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:28048 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760699Ab2C3MZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:25:01 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared
To: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Slaby <jirislaby@gmail.com>, Keith Packard <keithp@keithp.com>,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        daniel@ffwll.ch
In-Reply-To: <4F75A303.3030409@suse.cz>
References: <4F717CE3.4040206@suse.cz> <4F717D80.9040207@suse.cz> <4F758400.3080907@suse.cz> <1333104359_155028@CP5-2952> <4F75A303.3030409@suse.cz>
Date: Fri, 30 Mar 2012 13:24:38 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1333110296_156038@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012 14:11:47 +0200, Jiri Slaby <jslaby@suse.cz> wrote:
> On 03/30/2012 12:45 PM, Chris Wilson wrote:
> > On Fri, 30 Mar 2012 11:59:28 +0200, Jiri Slaby <jslaby@suse.cz> wrote:
> >> I don't know what to dump more, because iir is obviously zero too. What
> >> other sources of interrupts are on the (G33) chip?
> > 
> > IIR is the master interrupt, with chained secondary interrupt statuses.
> > If IIR is 0, the interrupt wasn't raised by the GPU.
> 
> This does not make sense, the handler does something different. Even if
> IIR is 0, it still takes a look at pipe stats.

That was introduced in 05eff845a28499762075d3a72e238a31f4d2407c to close
a race where the pipestat triggered an interrupt after we processed the
secondary registers and before reseting the primary.

But the basic premise that we should only enter the interrupt handler
with IIR!=0 holds (presuming non-shared interrupt lines such as MSI).
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
