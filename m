Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab2HUWet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 18:34:49 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40260 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694Ab2HUWer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 18:34:47 -0400
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: LKML <linux-kernel@vger.kernel.org>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        linux-fbdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 0/2] console_lock debug improvements
Date: Wed, 22 Aug 2012 00:34:30 +0200
Message-Id: <1345588472-4055-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After Dave Airlie blew through a few days to track down a deadlock at boot-up
when handing over from the firmware fb to the kms/drm framebuffer driver (1), I've
figured that lockdep /should/ have caught this.

And indeed, by adding proper annotations to the console_lock it complains about
the potential deadlock when exercising the entire driver life-cycle of just one
fb driver (i.e. not even a handover required). While at it, I've replaced the
existing in_interrupt check with the more paranoid might_sleep.

Comments, flames and review highly welcome.

Yours, Daniel

[1]: https://lkml.org/lkml/2012/8/21/36

Daniel Vetter (2):
  console: use might_sleep in console_lock
  console: implement lockdep support for console_lock

 kernel/printk.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

-- 
1.7.10.4

