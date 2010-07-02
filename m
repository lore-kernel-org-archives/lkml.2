Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab0GBXMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 19:12:38 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:35599 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751704Ab0GBXMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 19:12:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ta4OA26RglmC5Y99nMxSQsovvV87vMBoZeUcS0FFEtmDHeia0gwuF5mWR8mf0Ocxhx9XUW9B03l6DIGOnKJze0SASV9VD3Sck6QJifUN5EOibm2Q4WxUeRdUtnI9CxuU;
Date: Fri, 2 Jul 2010 16:12:30 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bryan Freed <bfreed@chromium.org>
Cc: airlied@linux.ie, airlied@redhat.com, ben@decadent.org.uk, eric@anholt.net,
       mateusz.kaduk@gmail.com, chris@chris-wilson.co.uk,
       bgamari.foss@gmail.com, apw@canonical.com, yakui.zhao@intel.com,
       zhenyuw@linux.intel.com, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] Implement direct pineview backlight control.
Message-ID: <20100702161230.09f7c348@virtuousgeek.org>
In-Reply-To: <1277251107-24828-1-git-send-email-bfreed@chromium.org>
References: <1277251107-24828-1-git-send-email-bfreed@chromium.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jun 2010 16:58:27 -0700
Bryan Freed <bfreed@chromium.org> wrote:

> drm/i915: Add a direct interface for pineview backlight support.
> 
> This adds a Kconfig variable CONFIG_DRM_I915_DIRECT_BACKLIGHT to
> optionally include the new source file i915_backlight.c.  This file
> registers a couple backlight set/get routines with the standard
> drivers/video/backlight interface to add a directory under
> /sys/class/backlight/.
> 
> The big problem I see with this modification is that the i915 driver
> _already_ supports backlight level adjustment in i915_opregion.c.
> Unfortunately, that requires an IRQ to occur as the result of writing
> some ASLE (ACPI Source Language Event) register, and this requires
> BIOS support for the ACPI hook.  It looks like we will not have such
> support in our initial custom BIOS.
> 
> So I copy a small amount of code from i915_opregion.c to make backlight
> adjustment directly available to the backlight framework.
> 
> Another problem is that I do not cover all the cases handled by the
> i915_opregion.c code.  It would be too much untested code copying to
> do so.  I enforce the lack of support by checking for IS_PINEVIEW()
> in i915_backlight_init().
> 
> Review URL: http://codereview.chromium.org/2830015
> Signed-off-by: Bryan Freed <bfreed@chromium.org>

How does this compare to Matthew's native backlight support?  AFAIK
that patch is still outstanding due to the need for some changes to the
backlight subsystem.

Matthew?

-- 
Jesse Barnes, Intel Open Source Technology Center
