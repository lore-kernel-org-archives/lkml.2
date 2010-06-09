Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab0FISgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 14:36:04 -0400
Received: from THUNK.ORG ([69.25.196.29]:41267 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758067Ab0FISgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:36:03 -0400
Date: Wed, 09 Jun 2010 14:36:00 -0400
Message-Id: <E1OMQ88-0002a1-Gb@closure.thunk.org>
To: Dave Airlie <airlied@redhat.com>, David Howells <dhowells@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Why is kslowd accumulating so much CPU time?
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


My laptop is running 2.6.35-rc2 (plus a few patches) and after not quite
four hours of beeing booted (3:45 to be precise), top shows that kslowd
has accumulated as surprising amount of CPU time.  From top display:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 6173 root      15  -5     0    0    0 S    6  0.0  10:42.91 kslowd001
 1219 root      15  -5     0    0    0 S    5  0.0  11:00.68 kslowd000
 1765 root      15  -5     0    0    0 S    5  0.0  10:59.20 kslowd002
 6784 root      15  -5     0    0    0 S    4  0.0  10:34.37 kslowd003
 4946 root      20   0  144m  34m  17m S    3  0.9   2:24.62 Xorg

This came up because I was trying to figure out why mouse response was
being so jerky.  There aren't that many users of slow-work, and given
that I'm not using cifs, fscache, gfs2, my suspicions are falling on
drivers/gpu/drm/drm_crtc_helper.c (Would this be something that would be
in use on a Lenovo T400 laptop?)

Is there any way to easily see what is scheduling themselves to use the
slow workqueue?

Thanks,

						- Ted
