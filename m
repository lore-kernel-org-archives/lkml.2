Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab0LPIAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 03:00:41 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35456 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab0LPIAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 03:00:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=QEsQ5rKaZ+pmu2naffGpzio6B2+MSlZjt5gquIdk8/JR6F2jFvoacbYCCXoRotPe4K
         hCdaTGLierMtGzlZv8/esTKMRE2HTkhj3JST060kUxH1vKutJ0Y2JsW0mezqfLPnVdxD
         eBTSkq0exWxRL9ctIxipiSS6t7YoWQj45GgWg=
Date: Wed, 15 Dec 2010 23:52:49 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.37-rc5
Message-ID: <20101216075249.GC26567@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

The main change it that we define new versions of EVIOC{G|S}KEYCODE_V2
ioctls instead of reusing the old names. This is to avoid surprising
people recompiling programs using old interface on newer kernels (while
we kept ABI intact so existing binaries should continue working fine
recompiled programs would start failing since they'd be using old ioctl
data with new ioctl numbers).

Changelog:
---------

Dmitry Torokhov (1):
      Input: define separate EVIOCGKEYCODE_V2/EVIOCSKEYCODE_V2

Kevin Granade (1):
      Input: wacom - add another Bamboo Pen ID (0xd4)


Diffstat:
--------

 drivers/input/evdev.c            |  113 +++++++++++++++++++------------------
 drivers/input/tablet/wacom_wac.c |    3 +
 include/linux/input.h            |    6 +-
 3 files changed, 65 insertions(+), 57 deletions(-)

-- 
Dmitry

