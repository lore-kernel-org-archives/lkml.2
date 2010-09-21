Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab0IUW5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 18:57:12 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:35414 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751767Ab0IUW5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 18:57:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=EjTf1jrzbrRdLyvsxdJ+3d6eFOH6mT7EsmAHmObvl7o1lyh3J1PLICLENW0HJ2L2EsHLxxpJRUTCS2dVqY+467pEbSCKI8pIlvza/aPnNWczrdbaAOfqyH1HND3FQhE4;
Date: Tue, 21 Sep 2010 15:56:53 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Paolo Ornati <ornati@gmail.com>
Cc: Vasily Khoruzhick <anarsoul@gmail.com>,
        Simon Farnsworth <simon.farnsworth@onelan.co.uk>,
        intel-gfx@lists.freedesktop.org, Sitsofe Wheeler <sitsofe@yahoo.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] Interrupt latency on some 945GM platforms
Message-ID: <20100921155653.440afea4@jbarnes-desktop>
In-Reply-To: <20100921202607.2b46ffca@gmail.com>
References: <201009132336.17310.anarsoul@gmail.com>
	<201009171002.09187.simon.farnsworth@onelan.co.uk>
	<4b4d1e0a-b1ad-40f1-a829-6d4726d2b2d3@email.android.com>
	<201009171550.48480.anarsoul@gmail.com>
	<20100921202607.2b46ffca@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010 20:26:07 +0200
Paolo Ornati <ornati@gmail.com> wrote:

> On Fri, 17 Sep 2010 15:50:43 +0300
> Vasily Khoruzhick <anarsoul@gmail.com> wrote:
> 
> > > Vasily, can you try the qos workaround on your machine and see if it works
> > > too?
> > > 
> > > Thanks,  
> > 
> > Just give me a patch :)
> 
> Me too...
> 
> I've a laptop with 945GM (Asus x5dij) and with 2.6.32+ kernels I'm
> having random, but not frequent, screen flickering problems (for some
> reasons 2.6.31 works fine).
> 
> Problem goes away with "nohz=off".
> 
> I'll try with "processor.max_cstate=?" and see if that works too.

Can you guys try something like this?  My theory is that 945GM has some
power management behavior we're failing to configure correctly.  If
disabling it works, then it's likely related.

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_d
index 40cc5da..26e1d23 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -5786,6 +5786,10 @@ void intel_init_clock_gating(struct drm_device *dev)
                                   I915_READ(MCHBAR_RENDER_STANDBY) & ~RCX_SW_EX
                }
        }
+
+
+       /* Disable power management on 945GM */
+       I915_WRITE(0x10f10, 0);
 }
 
 /* Set up chip specific display functions */


-- 
Jesse Barnes, Intel Open Source Technology Center
