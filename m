Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1CUKT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 06:19:29 -0400
Received: from ist.d-labs.de ([213.239.218.44]:44298 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab1CUKTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 06:19:25 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, pb@linuxtv.org,
        Florian Mickler <florian@mickler.org>
Subject: [PATCH 0/9] vp702x: get rid of on-stack dma buffers (part2 1/2)
Date: Mon, 21 Mar 2011 11:19:05 +0100
Message-Id: <1300702754-16376-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

This is a patchset modifying the vp702x to get rid of on-stack dma buffers
and additionally preallocating the used buffers on device probe. 

I can not test these patches, as I don't have the hardware.
They compile though...
I made it a bit more finegrained for easier review.

If someone could test these, that would be appreciated.

I have a few more patches to dib0700 and gp8psk to also use a 
preallocated buffer, but I'm not shure the added complexity is 
worth it. So I'm waiting on feedback to the vp702x to proceed.

I have another batch of patches to opera1, m920x, dw2102, friio,
a800 which I did not modify since my first patch submission.

Regards,
Flo

Florian Mickler (9):
  [media] vp702x: cleanup: whitespace and indentation
  [media] vp702x: rename struct vp702x_state -> vp702x_adapter_state
  [media] vp702x: preallocate memory on device probe
  [media] vp702x: remove unused variable
  [media] vp702x: get rid of on-stack dma buffers
  [media] vp702x: fix locking of usb operations
  [media] vp702x: use preallocated buffer
  [media] vp702x: use preallocated buffer in vp702x_usb_inout_cmd
  [media] vp702x: use preallocated buffer in the frontend

 drivers/media/dvb/dvb-usb/vp702x-fe.c |   80 +++++++++----
 drivers/media/dvb/dvb-usb/vp702x.c    |  213 ++++++++++++++++++++++++++-------
 drivers/media/dvb/dvb-usb/vp702x.h    |    7 +
 3 files changed, 233 insertions(+), 67 deletions(-)

-- 
1.7.4.1

