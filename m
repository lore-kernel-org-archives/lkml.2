Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab2IGVfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 17:35:09 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57797 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab2IGVfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 17:35:06 -0400
MIME-Version: 1.0
In-Reply-To: <1347031330-19657-1-git-send-email-seth.forshee@canonical.com>
References: <1347031330-19657-1-git-send-email-seth.forshee@canonical.com>
Date: Fri, 7 Sep 2012 22:35:04 +0100
Message-ID: <CAPM=9tyHodSp0BCdU4Bz=95JXhiiswYRTAre6LyQjiV023UXCw@mail.gmail.com>
Subject: Re: [PATCH 0/7] Fixes for hybrid graphics Apple machines
From: Dave Airlie <airlied@gmail.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>, Matthew Garrett <mjg@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Andreas Heider <andreas@meetr.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 4:22 PM, Seth Forshee <seth.forshee@canonical.com> wrote:
> Many hybrid graphics Apple laptops fail to set up LVDS on the secondary
> GPU due to missing or incorrect mode information for the panel at init
> time. The only way to get the LVDS mode on these machines is via the
> DDC, but this is muxed to the active GPU at boot. However, the graphics
> mux on these machines supports muxing the i2c idependently of the
> display, making it possible for the secondary graphics driver to read
> the EDID without a full display switch.
>
> In order to support this, these patches modify vga_switcheroo to allow
> muxing of the DDC idependently of the display. apple-gmux is updated to
> support this new functionality, and drm_get_edid() is modified to switch
> the DDC mux as needed.
>
> For this to work we also need to ensure that sufficient switcheroo
> suport is available before initializing the secondary GPU. This is done
> by adding any non-active GPUs that try to initialize before switcheroo
> is ready to a list and initializing these devices once switcheroo
> becomes ready. This behavior is restricted to Apple laptops to prevent
> causing problems on other machines.

I hate this idea, no delaying stuff. We either need to have some sort
of enforced ordering or make some stuff only work built-in.

But sticking things on a delayed list just in case seems wrong to me.

Dave.
