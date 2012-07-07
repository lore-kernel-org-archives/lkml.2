Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab2GGRDZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 13:03:25 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40983 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab2GGRDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 13:03:24 -0400
Message-ID: <4FF86BD9.3050805@gmail.com>
Date: Sat, 07 Jul 2012 12:03:21 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Grant Likely <grant.likely@secretlab.ca>
Subject: [GIT PULL] DT clk binding support for 3.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

Please pull DT clk binding and highbank clk support for 3.6. The only
real change from 3.5 pull request is returning error values rather than
NULL to align with the rest of the clk framework. There's been a little
discussion but otherwise has been quiet.

Rob

The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:

  Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)

are available in the git repository at:

  git://sources.calxeda.com/kernel/linux.git clk-for-3.6

for you to fetch changes up to 39a8e38a03823c3acaec02c6d7c551e268cb2139:

  clk: add highbank clock support (2012-07-01 17:04:45 -0500)

----------------------------------------------------------------
Grant Likely (2):
      clk: add DT clock binding support
      clk: add DT fixed-clock binding support

Rob Herring (2):
      dt: add clock binding doc to primecell bindings
      clk: add highbank clock support

 .../devicetree/bindings/arm/primecell.txt          |    6 +
 .../devicetree/bindings/clock/calxeda.txt          |   17 +
 .../devicetree/bindings/clock/clock-bindings.txt   |  117 +++++++
 .../devicetree/bindings/clock/fixed-clock.txt      |   21 ++
 arch/arm/Kconfig                                   |    1 +
 arch/arm/boot/dts/highbank.dts                     |   91 +++++-
 arch/arm/mach-highbank/Makefile                    |    2 +-
 arch/arm/mach-highbank/clock.c                     |   62 ----
 arch/arm/mach-highbank/highbank.c                  |    7 +
 drivers/clk/Makefile                               |    1 +
 drivers/clk/clk-fixed-rate.c                       |   23 ++
 drivers/clk/clk-highbank.c                         |  345
++++++++++++++++++++
 drivers/clk/clk.c                                  |  140 ++++++++
 drivers/clk/clkdev.c                               |   77 +++++
 include/linux/clk-provider.h                       |   16 +
 include/linux/clk.h                                |   19 ++
 16 files changed, 881 insertions(+), 64 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/calxeda.txt
 create mode 100644
Documentation/devicetree/bindings/clock/clock-bindings.txt
 create mode 100644 Documentation/devicetree/bindings/clock/fixed-clock.txt
 delete mode 100644 arch/arm/mach-highbank/clock.c
 create mode 100644 drivers/clk/clk-highbank.c
