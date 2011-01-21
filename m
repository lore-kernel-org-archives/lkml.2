Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab1AUBDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 20:03:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121Ab1AUBDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 20:03:52 -0500
Date: Thu, 20 Jan 2011 17:03:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ali Gholami Rudi <aliqrudi@gmail.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-acpi@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: [Intel-gfx] [PATCH 2/5] i915: Add native backlight control
Message-Id: <20110120170337.94d83333.akpm@linux-foundation.org>
In-Reply-To: <20110121004359.GA6422@srcf.ucam.org>
References: <1295033065-13450-1-git-send-email-mjg@redhat.com>
	<1295033065-13450-2-git-send-email-mjg@redhat.com>
	<20112101000015@lilem.mirepesht>
	<20112101004346@lilem.mirepesht>
	<20110120151349.49cf3ebb.akpm@linux-foundation.org>
	<20110121004359.GA6422@srcf.ucam.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011 00:43:59 +0000
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, Jan 20, 2011 at 03:13:49PM -0800, Andrew Morton wrote:
> > On Fri, 21 Jan 2011 00:43:46 +0330
> > Ali Gholami Rudi <aliqrudi@gmail.com> wrote:
> > 
> > > Ali Gholami Rudi <aliqrudi@gmail.com> wrote:
> > > > I tried to apply this patch but I get:
> > > > 
> > > > 	drivers/gpu/drm/i915/intel_panel.c: In function 'intel_panel_setup_backlight':
> > > > 	drivers/gpu/drm/i915/intel_panel.c:319: error: 'struct backlight_properties' has no member named 'type'
> > > > 	drivers/gpu/drm/i915/intel_panel.c:319: error: 'BACKLIGHT_RAW' undeclared (first use in this function)
> > > > 	drivers/gpu/drm/i915/intel_panel.c:319: error: (Each undeclared identifier is reported only once
> > > > 	drivers/gpu/drm/i915/intel_panel.c:319: error: for each function it appears in.)
> > > 
> > > After applying patch 1/5, the patch applied cleanly.
> > > Now I can change the brightness using
> > > /sys/class/backlight/intel_backlight/brightness.
> > > So it does fix my issue.
> > > 
> > 
> > So we have a patch ordering issue and the
> > radeon-expose-backlight-class-device-for-legacy-lvds-encoder.patch
> > build error.
> 
> He applied 2/5, it didn't build, he applied 1/5 and it built? I don't 
> think that's a patch ordering issue :)

What, you expect reading skills?

> I think Michel's patch should fix the Radeon one. If not, can you drop 
> that and keep the rest of the set? I'm travelling at the moment and 
> won't have proper build access until the weekend.

OK, I resurrected everything.

I updated the new drivers/video/backlight/adp5520_bl.c, but there's a
decent chance that unconverted drivers will sneak in.  I trust they
will still work OK?

