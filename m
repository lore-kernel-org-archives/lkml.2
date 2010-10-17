Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab0JQHST (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 03:18:19 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:56149 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753521Ab0JQHSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 03:18:18 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX18uISBod64uqbyzOwg0SOBexkQiOY5dazmapM9T/Z
	VTJDyjLSoc6Vx/
From: Sven Joachim <svenjoac@gmx.de>
To: Roland Dreier <rdreier@cisco.com>
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Maarten Maathuis <madman2003@gmail.com>
Subject: Re: 2.6.36-rc8 -- drivers/built-in.o: In function `nouveau_acpi_edid': (.text+0xf7c04): undefined reference to `acpi_video_get_edid'
References: <AANLkTik8pvkueU8YyUwjODz53QnurUqKycaTYJ-McYqB@mail.gmail.com>
	<adad3r9hn1x.fsf@cisco.com>
Date: Sun, 17 Oct 2010 09:18:09 +0200
In-Reply-To: <adad3r9hn1x.fsf@cisco.com> (Roland Dreier's message of "Sat, 16
	Oct 2010 13:58:50 -0700")
Message-ID: <878w1xp9se.fsf@turtle.gmx.de>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-16 22:58 +0200, Roland Dreier wrote:

>  > drivers/built-in.o: In function `nouveau_acpi_edid':
>  > (.text+0xf7c04): undefined reference to `acpi_video_get_edid'
>  > make: *** [.tmp_vmlinux1] Error 1
>
> The problem is:
>
>  > CONFIG_ACPI=y
>  > CONFIG_ACPI_VIDEO=m
>
> but
>
>  > CONFIG_DRM_NOUVEAU=y
>
> So the built-in nouveau code tries to reference the modular acpi video
> code.

The nouveau tree has a fix for this already, in commit
4587d1cfa8b54ba3dd3095c3e6f12d02390494c6:

--8<---------------cut here---------------start------------->8---
diff --git a/drivers/gpu/drm/nouveau/Kconfig b/drivers/gpu/drm/nouveau/Kconfig
index d2d2804..72730e9 100644
--- a/drivers/gpu/drm/nouveau/Kconfig
+++ b/drivers/gpu/drm/nouveau/Kconfig
@@ -10,6 +10,7 @@ config DRM_NOUVEAU
 	select FB
 	select FRAMEBUFFER_CONSOLE if !EMBEDDED
 	select FB_BACKLIGHT if DRM_NOUVEAU_BACKLIGHT
+	select ACPI_VIDEO if ACPI
 	help
 	  Choose this option for open-source nVidia support.
 
--8<---------------cut here---------------end--------------->8---

Maybe this should be cherry-picked for 2.6.36.

Sven
