Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab1EKUpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:45:12 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35383 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab1EKUpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:45:10 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 11 May 2011 22:44:49 +0200
X-Google-Sender-Auth: p95kQESAEmeXu_ztzeUXGk9CIfI
Message-ID: <BANLkTi=yCmxgv1fQKRJSZK3FkkRwjS2r=Q@mail.gmail.com>
Subject: [PATCH v6 0/5] Basic ARM devicetree support
To: linaro-dev@lists.linaro.org, Thomas Gleixner <tglx@linutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Here's the current state of the device tree patches for basic
infrastructure support.  It's pretty much the same as the last series
I sent to you, except I've dropped the patches that add .dts files and
board support simply because the final location for storing .dtb files
is still up in the air.

After hearing from multiple people this week at UDS, and specifically
having a long conversation about it with tglx, I'd really think it's
time to start getting some wider testing in linux-next since it has
seemed to be quite stable for a while now.  In fact, I want to put it
in right now so that there is the /option/ of getting it into 2.6.40
with a separate pull request near the end of the merge window (I'm not
asking you to commit to merging it, but it isn't even an option if it
isn't in linux-next).

Right now it merges cleanly with linux-next and the resulting tree
builds and boots at least on qemu.  Unless you really object, I'm
going to ask Stephen to add the following branch to the /end/ of the
list of trees for linux-next so it can easily be dropped it if it
causes any problems.

git://git.secretlab.ca/git/linux-2.6 devicetree/arm-next

g.

---

Grant Likely (5):
      arm/dt: Make __vet_atags also accept a dtb image
      arm/dt: Allow CONFIG_OF on ARM
      arm/dt: consolidate atags setup into setup_machine_atags
      arm/dt: probe for platforms via the device tree
      dt: add documentation of ARM dt boot interface


 Documentation/arm/Booting                       |   33 +++++
 Documentation/devicetree/booting-without-of.txt |   48 +++++++-
 arch/arm/Kconfig                                |    7 +
 arch/arm/include/asm/mach/arch.h                |    9 +
 arch/arm/include/asm/prom.h                     |   37 ++++++
 arch/arm/include/asm/setup.h                    |    4 +
 arch/arm/kernel/Makefile                        |    1-
 arch/arm/kernel/devtree.c                       |  145 +++++++++++++++++++++++
 arch/arm/kernel/head-common.S                   |   24 +++-
 arch/arm/kernel/head.S                          |    8 +
 arch/arm/kernel/setup.c                         |   90 +++++++++-----
 arch/arm/mm/init.c                              |   11 ++
 12 files changed, 367 insertions(+), 50 deletions(-)
 create mode 100644 arch/arm/include/asm/prom.h
 create mode 100644 arch/arm/kernel/devtree.c
