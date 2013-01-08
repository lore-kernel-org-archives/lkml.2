Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab3AHWgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 17:36:16 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:50666 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3AHWgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 17:36:15 -0500
Date: Tue, 8 Jan 2013 14:36:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Chris Wilson <chris@chris-wilson.co.uk>, daniel.vetter@ffwll.ch
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: i915_hangcheck_hung problem with 3.8-rc2+ (Linus's latest tree)
Message-ID: <20130108223611.GA19672@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've hit this 3 times today on Linus's latest 3.8-rc2+ tree:

[11868.414648] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
[11868.414655] [drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
[11870.408342] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
[11870.408412] [drm:i915_reset] *ERROR* GPU hanging too fast, declaring wedged!
[11870.408414] [drm:i915_reset] *ERROR* Failed to reset chip.
[11883.083225] gnome-shell[19396]: segfault at 218 ip 00007feef5f32333 sp 00007ffffc1dc930 error 4 in i965_dri.so[7feef5ecb000+d0000]

When it happens, gnome-shell dies a horrible death and it requires a
reboot in order to get xorg working properly again (probably because
gnome-shell is hosed.)

The machine does still work to do other things from a text console (I'm
writing this on the machine after the last time this happened.)

It seems to happen when doing a "stressful" thing on the machine (i.e.
multiple kernel builds at the same time).

I also seem to be able to hit this on 3.7.1, but not as regularly, and
not at all on 3.6.y.

Any hints or ideas of what to try out?

thanks,

greg k-h
