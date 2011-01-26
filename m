Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab1AZE5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 23:57:15 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46550 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab1AZE5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 23:57:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P04beJHRlpAc/D0WVM5Apa5bGvP75RcT2FzxJzQR+qhYbBJ/pT4g21/j9RkeZBYmNP
         2mG55JlUN8AN/8x3ZfMaBPfZBPEFc63b1BDhSCyxNFUyvHQ0eIM9NNl248iZhPEWrAY1
         GEtYdw1i1ZXtjIs4oX4JZ7sUg0BVYg5O3CINI=
Date: Tue, 25 Jan 2011 20:57:06 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.38-rc2
Message-ID: <20110126045706.GB23085@core.coreip.homeip.net>
References: <20110107065448.GC29038@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107065448.GC29038@core.coreip.homeip.net>
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

Mostly small fixups to the drivers, but also a new keyboard driver.
Since it is for previously unsupported hardware; arch-specific and we
are pretty early in the release cycle I hope it is still OK to get it
in.

Thanks!

Changelog:
---------

Andy Whitcroft (1):
      Input: sysrq - ensure sysrq_enabled and __sysrq_enabled are consistent

David Engraf (1):
      Input: serio - allow registered drivers to get status flag

Davidlohr Bueso (1):
      Input: ct82710c - return proper error code for ct82c710_open

Dmitry Torokhov (1):
      Input: sparse-keymap - fix KEY_VSW handling in sparse_keymap_setup

Jamie Iles (2):
      Input: tnetv107x-keypad - don't treat NULL clk as an error
      Input: tnetv107x-ts - don't treat NULL clk as an error

Naveen Kumar Gaddipati (2):
      Input: bu21013_ts - remove duplicate resolution parameters
      Input: bu21013_ts - added regulator support

Philippe Langlais (1):
      Input: gpio_keys - switch to using request_any_context_irq

Ping Cheng (2):
      Input: wacom - add 2 Bamboo Pen and touch models
      Input: wacom - pass touch resolution to clients through input_absinfo

Rakesh Iyer (1):
      Input: tegra-kbc - add tegra keyboard driver


Diffstat:
--------

 arch/arm/mach-tegra/include/mach/kbc.h    |   61 +++
 drivers/input/keyboard/Kconfig            |   10 +
 drivers/input/keyboard/Makefile           |    1 +
 drivers/input/keyboard/gpio_keys.c        |    6 +-
 drivers/input/keyboard/tegra-kbc.c        |  727 +++++++++++++++++++++++++++++
 drivers/input/keyboard/tnetv107x-keypad.c |    5 +-
 drivers/input/serio/ct82c710.c            |    8 +-
 drivers/input/serio/serport.c             |   24 +-
 drivers/input/sparse-keymap.c             |    1 +
 drivers/input/tablet/wacom_wac.c          |   27 +-
 drivers/input/touchscreen/bu21013_ts.c    |   39 ++-
 drivers/input/touchscreen/tnetv107x-ts.c  |    5 +-
 drivers/tty/sysrq.c                       |    2 +-
 include/linux/input/bu21013.h             |    4 -
 include/linux/sysrq.h                     |    3 +
 kernel/sysctl.c                           |    3 +-
 16 files changed, 901 insertions(+), 25 deletions(-)
 create mode 100644 arch/arm/mach-tegra/include/mach/kbc.h
 create mode 100644 drivers/input/keyboard/tegra-kbc.c

-- 
Dmitry
