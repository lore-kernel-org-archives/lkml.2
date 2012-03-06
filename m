Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030524Ab2CFMUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 07:20:08 -0500
Received: from gate.crashing.org ([63.228.1.57]:34626 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030474Ab2CFMUF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 07:20:05 -0500
Subject: Re: [PATCH V2 1/2] powerpc: Move GE GPIO and PIC drivers
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1330424541-5299-2-git-send-email-martyn.welch@ge.com>
Date: Tue, 6 Mar 2012 06:19:37 -0600
Cc: "linuxppc-dev@lists.ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linus.walleij@stericsson.com, Grant Likely <grant.likely@secretlab.ca>
Content-Transfer-Encoding: 8BIT
Message-Id: <C5C3845E-9732-4A9D-B1DC-84688E7D807F@kernel.crashing.org>
References: <1330424541-5299-1-git-send-email-martyn.welch@ge.com> <1330424541-5299-2-git-send-email-martyn.welch@ge.com>
To: Martyn Welch <martyn.welch@ge.com>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 28, 2012, at 4:22 AM, Martyn Welch wrote:

> Move the GE GPIO and PIC drivers to allow these to be used by non-86xx
> boards.
> 
> Signed-off-by: Martyn Welch <martyn.welch@ge.com>
> ---
> 
> v2: Move GPIO and PIC drivers to sysdev/ge/ rather than platforms/.
> 
> arch/powerpc/platforms/86xx/Kconfig                |    3 +++
> arch/powerpc/platforms/86xx/Makefile               |    7 +++----
> arch/powerpc/platforms/86xx/gef_ppc9a.c            |    2 +-
> arch/powerpc/platforms/86xx/gef_sbc310.c           |    2 +-
> arch/powerpc/platforms/86xx/gef_sbc610.c           |    2 +-
> arch/powerpc/sysdev/Kconfig                        |    7 +++++++
> arch/powerpc/sysdev/Makefile                       |    2 ++
> arch/powerpc/sysdev/ge/Makefile                    |    2 ++
> .../86xx/gef_gpio.c => sysdev/ge/ge_gpio.c}        |    2 +-
> .../86xx/gef_pic.c => sysdev/ge/ge_pic.c}          |    2 +-
> .../86xx/gef_pic.h => sysdev/ge/ge_pic.h}          |    0
> drivers/watchdog/Kconfig                           |    2 +-
> 12 files changed, 23 insertions(+), 10 deletions(-)
> create mode 100644 arch/powerpc/sysdev/ge/Makefile
> rename arch/powerpc/{platforms/86xx/gef_gpio.c => sysdev/ge/ge_gpio.c} (98%)
> rename arch/powerpc/{platforms/86xx/gef_pic.c => sysdev/ge/ge_pic.c} (99%)
> rename arch/powerpc/{platforms/86xx/gef_pic.h => sysdev/ge/ge_pic.h} (100%)

gpio driver should be in drivers/gpio.  Please split that move out as a separate patch for Grant & Linus to review as part of the GPIO subsystem

- k