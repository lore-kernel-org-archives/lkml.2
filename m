Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab1HRVu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 17:50:56 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:43913 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754337Ab1HRVuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 17:50:55 -0400
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Sekhar Nori <nsekhar@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com
Cc: James Nuss <jamesnuss@nanometrics.ca>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] ARM: davinci: introduce new board heliosv1
Date: Thu, 18 Aug 2011 17:50:46 -0400
Message-Id: <cover.1313702401.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this series we introduce a new board type: the Nanometrics Helios hardware
platform v1. Like the other da850/omapl138 boards in arch/arm/mach-davinci
it shares lots of common data definitions. For example boot_params location
and uart config are common to this new board and to the existing da850/omapl138
boards in the tree.

To combat to potential platform-data ARM bloat that we would otherwise add
with the introduction of the new board type we propose the creation of a
da850-reference module shared among the boards. The general idea is that the
da850evm is a 'reference implementation' and as such many of the boards do
re-use this reference so they can/should share the data since builds are headed
towards multi-machine.

We first extract board setup data that is common to several of the omapl138/
da850 boards in 1,2,3,4. Then the new board type is introduced in 5.

Boot-tested this series on-top of branch master @
a0cb2d282a57fd33ae57af2f2092974c82111b77 in
git://gitorious.org/linux-davinci/linux-davinci.git on da850evm and heliosv1
hardware.

Ben Gardiner (5):
  ARM: davinci: da850, omapl138: introduce shared da850 reference
    components
  ARM: davinci: da850, omapl138: share boot_params
  ARM: davinci: da850, omapl138: share the preferred console
    registration
  ARM: davinci: da850, omapl138: share the davinci_uart_config
  ARM: davinci: da850, omapl138: introduce new board-omapl138-heliosv1

 arch/arm/mach-davinci/Kconfig                      |    9 ++++
 arch/arm/mach-davinci/Makefile                     |    4 +-
 arch/arm/mach-davinci/board-da850-evm.c            |   18 ++-----
 arch/arm/mach-davinci/board-mityomapl138.c         |   16 ++-----
 arch/arm/mach-davinci/board-omapl138-hawk.c        |   18 ++-----
 arch/arm/mach-davinci/board-omapl138-heliosv1.c    |   51 ++++++++++++++++++++
 arch/arm/mach-davinci/da850-reference.c            |   31 ++++++++++++
 .../mach-davinci/include/mach/da850-reference.h    |   20 ++++++++
 8 files changed, 128 insertions(+), 39 deletions(-)
 create mode 100644 arch/arm/mach-davinci/board-omapl138-heliosv1.c
 create mode 100644 arch/arm/mach-davinci/da850-reference.c
 create mode 100644 arch/arm/mach-davinci/include/mach/da850-reference.h

-- 
1.7.4.1

