Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab1ATVA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 16:00:26 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45703 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab1ATVAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 16:00:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :user-agent;
        b=x9zR/fqg4s506W4dIDV1s5RBKzq3ehLyd9F0lgaHU163Vn7ErZYJf0jYOpow49Hix9
         QEzaU5HVbxLTolJG9IJS7KNCa6BhDLOOyG8OUI8vOSONE+97GUgDHKLmTRcp4sX3ywyH
         9Xv3bK1g7HhC3daJiMUSZ78+CsaeqvLukjcoE=
Date: Fri, 21 Jan 2011 00:00:15 +0330
From: Ali Gholami Rudi <aliqrudi@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: akpm@linux-foundation.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-acpi@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: [Intel-gfx] [PATCH 2/5] i915: Add native backlight control
Message-ID: <20112101000015@lilem.mirepesht>
In-Reply-To: <1295033065-13450-2-git-send-email-mjg@redhat.com>
References: <1295033065-13450-1-git-send-email-mjg@redhat.com>
	<1295033065-13450-2-git-send-email-mjg@redhat.com>
User-Agent: git://repo.or.cz/mailx.git
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Matthew Garrett <mjg@redhat.com> wrote:
> Not all systems expose a firmware or platform mechanism for changing the
> backlight intensity on i915, so add native driver support.

After switching to 2.6.38-rc1 from 2.6.37
/sys/devices/virtual/backlight/acpi_video0/brightness
disappeared and I cannot control the backlight.
I tried using acpi_backlight=video but that didn't help
(this is an HP laptop BTW and I don't think there is a
native backlight control for it).

I tried to apply this patch but I get:

	drivers/gpu/drm/i915/intel_panel.c: In function 'intel_panel_setup_backlight':
	drivers/gpu/drm/i915/intel_panel.c:319: error: 'struct backlight_properties' has no member named 'type'
	drivers/gpu/drm/i915/intel_panel.c:319: error: 'BACKLIGHT_RAW' undeclared (first use in this function)
	drivers/gpu/drm/i915/intel_panel.c:319: error: (Each undeclared identifier is reported only once
	drivers/gpu/drm/i915/intel_panel.c:319: error: for each function it appears in.)
	make[4]: *** [drivers/gpu/drm/i915/intel_panel.o] Error 1
	make[3]: *** [drivers/gpu/drm/i915] Error 2
	make[2]: *** [drivers/gpu/drm] Error 2
	make[1]: *** [drivers/gpu] Error 2
	make: *** [drivers] Error 2

$ lspci | grep VGA
00:02.0 VGA compatible controller: Intel Corporation Mobile GME965/GLE960 Integrated Graphics Controller (rev 0c)
$ find /sys/ -name "*backlight*"
/sys/class/backlight
/sys/module/video/parameters/use_bios_initial_backlight

Thanks,
Ali

