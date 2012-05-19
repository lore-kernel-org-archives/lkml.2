Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637Ab2ESVXF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 17:23:05 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33806 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab2ESVXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 17:23:02 -0400
Message-ID: <4FB80F32.5090309@gmail.com>
Date: Sat, 19 May 2012 16:22:58 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] DT clk binding support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

Please pull devicetree clock binding support for 3.5. It's a bit late I
know, but this shouldn't affect anyone except for highbank which uses
it. It will be good to get it in so other platforms can start using it.

If you prefer, perhaps Arnd/Olof can pull this directly if you don't
have any other pulls planned for 3.5-rc1.

Rob

The following changes since commit f0948f59dbc8e725a96ba16da666e8f5cdd43ba8:

  clk: add a fixed factor clock (2012-05-08 14:13:25 -0700)

are available in the git repository at:

  git://sources.calxeda.com/kernel/linux.git clk-for-3.5

for you to fetch changes up to 9dca208955ffba16adc99d982fd7432b37f76faa:

  clk: add highbank clock support (2012-05-15 19:14:10 -0500)

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
 drivers/clk/Makefile                               |    4 +-
 drivers/clk/clk-fixed-rate.c                       |   23 ++
 drivers/clk/clk-highbank.c                         |  345
++++++++++++++++++++
 drivers/clk/clk.c                                  |  140 ++++++++
 drivers/clk/clkdev.c                               |   77 +++++
 include/linux/clk-provider.h                       |   16 +
 include/linux/clk.h                                |   19 ++
 16 files changed, 883 insertions(+), 65 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/calxeda.txt
 create mode 100644
Documentation/devicetree/bindings/clock/clock-bindings.txt
 create mode 100644 Documentation/devicetree/bindings/clock/fixed-clock.txt
 delete mode 100644 arch/arm/mach-highbank/clock.c
 create mode 100644 drivers/clk/clk-highbank.c
