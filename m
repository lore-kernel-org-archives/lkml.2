Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab0LJI7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 03:59:44 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:52383 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab0LJI7n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 03:59:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=F/rVAaRiY7XRrX/DS4K66jSdxol9xItcqDJ8X6BXPqOlHcjfLxMZUy0u8oVGzg1LNB
         fBKlbYikyUuTQlwSYsd/3N7q+KoleQCZVb2A3tEoaSt6P3VFjs2ohqsINJ+gkI29VAM8
         ZVOk4YexxsAqUG375H3h6G5RsJfFkT2MD4nGQ=
MIME-Version: 1.0
Date: Fri, 10 Dec 2010 09:59:41 +0100
Message-ID: <AANLkTi=3ar2Sw3RUkMX3Yo4n1-ohQwFT5w_toE6WMTVf@mail.gmail.com>
Subject: vga switcheroo not working / crashing the machine on i915/nvidia
 hybrid. (ASUS U30JC)
From: Giacomo <delleceste@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

In my double-carded ASUS U30JC (nvidia + intel i915) I do the following:

stop X

This is the output of /sys/kernel/debug/vgaswitcheroo/switch

daphne linux # cat /sys/kernel/debug/vgaswitcheroo/switch
0: :Pwr:0000:01:00.0
1:+:Pwr:0000:00:02.0 (intel graphic card in use, ok)

echo "DDIS" > /sys/kernel/debug/vgaswitcheroo/switch does not change
the output above (intel remains marked as active)

echo "OFF" > /sys/kernel/debug/vgaswitcheroo/switch

seems to switch off Nvidia card, because the output above becomes:
0: :Off:0000:01:00.0
1:+:Pwr:0000:00:02.0

restarting X completely freezes the machine, black screen (need to power down
by
pressing the power button).


ASUS U30JC Nvidia (nouveau) + intel i915.

Kernel 2.6.35
x11-base/xorg-server 1.9.2.902
x11-drivers/xf86-video-nouveau 0.0.16_pre20101010

Shutting down the Nvidia graphic card via acpi_call
https://github.com/mkottman/acpi_call
produces the same freeze after trying to restart X.

Same problem with kernel 2.6.36 and acpi_call.
Did not try vga switcheroo on 2.6.36 due to problems with that kernel

https://bugzilla.kernel.org/show_bug.cgi?id=24542

echo "OFF" > /sys/kernel/debug/vgaswitcheroo/switch

produces in dmesg:

Dec  8 00:06:18 daphne kernel: VGA switcheroo: switched nouveau off
Dec  8 00:06:18 daphne kernel: [drm] nouveau 0000:01:00.0: Disabling fbcon
acceleration...
Dec  8 00:06:18 daphne kernel: [drm] nouveau 0000:01:00.0: Unpinning
framebuffer(s)...
Dec  8 00:06:18 daphne kernel: [drm] nouveau 0000:01:00.0: Evicting buffers...
Dec  8 00:06:18 daphne kernel: [drm] nouveau 0000:01:00.0: Idling channels...
Dec  8 00:06:18 daphne kernel: [drm] nouveau 0000:01:00.0: Suspending GPU
objects...
Dec  8 00:06:19 daphne kernel: [drm] nouveau 0000:01:00.0: And we're gone!
Dec  8 00:06:19 daphne kernel: nouveau 0000:01:00.0: PCI INT A disabled
Dec  8 00:06:19 daphne kernel: nouveau 0000:01:00.0: power state changed by
ACPI to D3

which seems to be correct.

The crash taking place when restarting X does not leave any trace on dmesg.

Thanks in advance.

Giacomo.
Elettra Synchrotron Radiation Facility
Trieste, IT.

-- 
Giacomo S.
http://www.giacomos.it

- - - - - - - - - - - - - - - - - - - - - -

* iqfire-wall, un progetto
  open source che implementa un
  filtro di pacchetti di rete per Linux,
  e` disponibile per il download qui:
  http://sourceforge.net/projects/ipfire-wall

* Informazioni e pagina web ufficiale:
  http://www.giacomos.it/iqfire/index.html

- - - - - - - - - - - - - - - - - - - - - -

 . ''  `.
:   :'    :
 `.  ` '
    `- Debian GNU/Linux -- The power of freedom
        http://www.debian.org
