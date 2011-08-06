Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab1HFWYp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 18:24:45 -0400
Received: from saarni.dnainternet.net ([83.102.40.136]:52591 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab1HFWYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 18:24:42 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Aug 2011 18:24:42 EDT
X-Spam-Flag: NO
X-Spam-Score: -1
From: Anssi Hannula <anssi.hannula@iki.fi>
To: dmitry.torokhov@gmail.com
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] ati_remote: move to rc-core and other updates
Date: Sun,  7 Aug 2011 01:18:06 +0300
Message-Id: <1312669093-23771-1-git-send-email-anssi.hannula@iki.fi>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <4E3DB2C2.7040104@iki.fi>
References: <4E3DB2C2.7040104@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anssi Hannula wrote:
> On 25.05.2011 19:32, Dmitry Torokhov wrote:
>> I believe Anssi Hannula (CCed) mentioned that he has a version of
>> ati_remove ported to rc-core infrastructure that supports such
>> remapping. Anssi, could you tell me what is the status of that driver?
>> Is it usable with rc-core?
> 
> Sorry, it seems for some reason I didn't receive your message via CC and
> only now saw it while looking at linux-input@ messages.
> 
> Indeed I have a patchset that makes it work with rc-core which I didn't
> get around to posting yet (sorry about that).
> 
> I'll try to look over it now and do some more testing, and then post the
> set.
> 
> Some notes about the patchset:
> - The mouse handling is left as-is, and it now appears as a separate
>   input device (that part of the keymap is the same for all remotes
>   with mouse). The mouse device is created regardless of receiver,
>   in case another type of remote is used with the receiver.
> - The driver sends rc_keyup immediately after every rc_keydown, as that
>   is what the driver has always done for input events as well. Doing
>   otherwise would cause a regression as ghost repeats would appear
>   with this driver while they didn't before.


Here goes the patchset, comments welcome.


Anssi Hannula (7):
      [media] move ati_remote driver from input/misc to media/rc
      [media] ati_remote: migrate to the rc subsystem
      [media] ati_remote: parent input devices to usb interface
      [media] ati_remote: fix check for a weird byte
      [media] ati_remote: add keymap for Medion X10 RF remote
      [media] ati_remote: add support for SnapStream Firefly remote
      [media] ati_remote: update Kconfig description

---
 drivers/input/misc/Kconfig                       |   16 -
 drivers/input/misc/Makefile                      |    1 -
 drivers/input/misc/ati_remote.c                  |  867 --------------------
 drivers/media/rc/Kconfig                         |   23 +-
 drivers/media/rc/Makefile                        |    1 +
 drivers/media/rc/ati_remote.c                    |  946 ++++++++++++++++++++++
 drivers/media/rc/keymaps/Makefile                |    3 +
 drivers/media/rc/keymaps/rc-ati-x10.c            |  103 +++
 drivers/media/rc/keymaps/rc-medion-x10.c         |  116 +++
 drivers/media/rc/keymaps/rc-snapstream-firefly.c |  106 +++
 include/media/rc-map.h                           |    3 +
 11 files changed, 1299 insertions(+), 886 deletions(-)

-- 
Anssi Hannula

