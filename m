Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab0KKBqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 20:46:35 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58878 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab0KKBqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 20:46:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=H+GvYdNgEMMy11iJ0U4uNaSdQm8wbCcQ/UvdE3eaIFKDoK5lcxZupG5cLTOnC81P3d
         ZoAp5n5kT2X8kS/xSTPc5kuRvG3O53ALROqjUT3x9Q0iAlIgYhg9gDLOCZzU4usWVBHn
         sUAM8J9QSjIywBjPuuh5/vUxkboW3OY5eYs9s=
Message-ID: <4CDB4B1D.7000503@lwfinger.net>
Date: Wed, 10 Nov 2010 19:47:09 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Regression in 2.6.37-rc1 for Intel 915 Graphics Adapter - bisected
 to commit e9e331a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my HP Mini 110 netbook with an Intel 945GME graphics adapter and kernel
2.6.37-rc1, screen blanking has a problem. On this machine, the screen is
blanked in two stages. The first leaves the backlight on, the second turns the
backlight off.

The details of the graphics adapter are as follows:

00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile 945GME
Express Integrated Graphics Controller [8086:27ae] (rev 03)
        Subsystem: Hewlett-Packard Company Device [103c:308f]
        Kernel driver in use: i915
00:02.1 Display controller [0380]: Intel Corporation Mobile 945GM/GMS/GME,
943/940GML Express Integrated Graphics Controller [8086:27a6] (rev 03)
        Subsystem: Hewlett-Packard Company Device [103c:308f]


Beginning with commit e9e331a8abeece1565d383510ed985945132ffe3 as determined
with bisection, the system no longer reawakens from the second stage with mouse
movements or key presses. The only way to bring it back that I have found is to
close the cover. After reopening the cover and entering the password to unlock
the system, the screen is restored.

The commit message is:

Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Mon Sep 13 01:16:10 2010 +0100

    drm/i915/lvds: Ensure panel is unlocked for Ironlake or the panel fitter

    Commit 77d07fd9d73ef28689737c0952dbd5d6a5017743 introduced a regression
    where by not waiting for the panel to be turned off, left the panel and
    PLL registers locked across the modeset. Thus the panel remaining blank.

    As pointed out by Daniel Vetter, when testing LVDS it helps to open the
    laptop and look at the actual panel you are purporting to test.

    A second issue with the patch was that in order to modify the panel
    fitter before gen5, the pipe and the panel must have be completely
    powered down. So we wait.

Larry

