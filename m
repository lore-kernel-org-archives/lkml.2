Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab1CUSeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 14:34:00 -0400
Received: from ist.d-labs.de ([213.239.218.44]:43605 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab1CUSd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 14:33:58 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, js@linuxtv.org,
        tskd2@yahoo.co.jp, liplianin@me.by, g.marco@freenet.de,
        aet@rasterburn.org, pb@linuxtv.org, mkrufky@linuxtv.org,
        nick@nick-andrew.net, max@veneto.com, janne-dvb@grunau.be,
        Florian Mickler <florian@mickler.org>
Subject: [PATCH 0/6] get rid of on-stack dma buffers
Date: Mon, 21 Mar 2011 19:33:40 +0100
Message-Id: <1300732426-18958-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

These patches get rid of on-stack dma buffers for some of the dvb-usb drivers. 
I do not own the hardware, so these are only compile tested. I would 
appreciate testing and review.
They were previously sent to the list, but some error on my side
prevented (some of?) them from beeing delivered to all parties (the lists).

These changes are motivated by 
https://bugzilla.kernel.org/show_bug.cgi?id=15977 .

The patches which got tested already were submitted to Mauro (and
lkml/linux-media) yesterday seperately. Those fix this same issue for ec168,
ce6230, au6610 and lmedm04. 

A fix for vp702x has been submitted seperately for review on the list. I have
similiar fixes like the vp702x-fix for dib0700 (overlooked some on-stack
buffers in there in my original submission as well) and gp8psk, but I am
holding them back 'till I got time to recheck those and getting some feedback
on vp702x.

Please review and test.

Regards,
Flo

Florian Mickler (6):
  [media] a800: get rid of on-stack dma buffers
  [media v2] vp7045: get rid of on-stack dma buffers
  [media] friio: get rid of on-stack dma buffers
  [media] dw2102: get rid of on-stack dma buffer
  [media] m920x: get rid of on-stack dma buffers
  [media] opera1: get rid of on-stack dma buffer

 drivers/media/dvb/dvb-usb/a800.c   |   17 ++++++++++---
 drivers/media/dvb/dvb-usb/dw2102.c |   10 ++++++-
 drivers/media/dvb/dvb-usb/friio.c  |   23 ++++++++++++++---
 drivers/media/dvb/dvb-usb/m920x.c  |   33 ++++++++++++++++--------
 drivers/media/dvb/dvb-usb/opera1.c |   31 +++++++++++++++--------
 drivers/media/dvb/dvb-usb/vp7045.c |   47 ++++++++++++++++++++++++++----------
 6 files changed, 116 insertions(+), 45 deletions(-)

-- 
1.7.4.1

