Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab1DCRY1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 13:24:27 -0400
Received: from ist.d-labs.de ([213.239.218.44]:54612 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab1DCRY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 13:24:26 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: oliver@neukum.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, patrick.boettcher@dibcom.fr
Subject: [media] dib0700: get rid of on-stack dma buffers
Date: Sun,  3 Apr 2011 19:23:41 +0200
Message-Id: <1301851423-21969-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

since I got no reaction[1] on the vp702x driver, I proceed with the 
dib0700. 

There are multiple drivers in drivers/media/dvb/dvb-usb/ which use
usb_control_msg to perform dma to stack-allocated buffers. This is a bad idea
because of cache-coherency issues and on some platforms the stack is mapped
virtually and also lib/dma-debug.c warn's about it at runtime.

Patches to ec168, ce6230, au6610 and lmedm04 were already tested and reviewed
and submitted for inclusion [2]. Patches to a800, vp7045, friio, dw2102, m920x
and opera1 are still waiting for for review and testing [3].

This patch to dib0700 is a fix for a warning seen and reported by Zdenek
Kabalec in Bug #15977 [4].

Florian Mickler (2):
      [media] dib0700: get rid of on-stack dma buffers
      [media] dib0700: remove unused variable

Regards,
Flo

References:
[1]: http://www.spinics.net/lists/linux-media/msg30448.html
[2]: http://comments.gmane.org/gmane.linux.kernel/1115404
[3]: http://groups.google.com/group/fa.linux.kernel/browse_frm/thread/e169edc121b91181/f1498cd026a59fe2
[4]: https://bugzilla.kernel.org/show_bug.cgi?id=15977

