Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab0K2TCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:02:52 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:57582 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab0K2TCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:02:51 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 24.130.172.179
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+oXPspPk9WqMfWUn/y1KvJ
Date: Mon, 29 Nov 2010 11:02:44 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [GIT PULL] omap serial console with PM fixes
Message-ID: <20101129190244.GD17222@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull two patches to fix omap serial console with PM enabled:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Both fix issues are related to conversion from 8250 to omap-serial done
in commit 6f251e9db1093c187addc309b5f2f7fe3efd2995 ("OMAP: UART: omap_device
conversions, remove implicit 8520 assumptions").

With the commit above, we are now idling devices using omap generic
code instead of tinkering with the uart registers directly. However,
we may now have pr_debug and pr_warning in the idle path that we
did not have earlier.

Without the second patch in this series the system may hang when PM
is enabled. The first patch in the series fixes a related issue if only
some of the uarts are enabled.

Apologies for the rather intrusive fix this late. The long term fix
is to let omap-serial.c manage it's own idle state but that's not ready
yet and can't be done as a fix.

An alternative fix for the -rc series would be to remove the pr_debug
and pr_warning from the idle path, but that really only fixes the
symptoms, not the cause.

Regards,

Tony


The following changes since commit 0b9466ccea3c4ec363737288dd9467bf978c9c2d:

  Merge master.kernel.org:/home/rmk/linux-2.6-arm (2010-11-25 07:41:10 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Kevin Hilman (1):
      OMAP: UART: don't resume UARTs that are not enabled.

Paul Walmsley (1):
      OMAP2+: PM/serial: hold console semaphore while OMAP UARTs are disabled

 arch/arm/mach-omap2/pm24xx.c |    7 +++++++
 arch/arm/mach-omap2/pm34xx.c |   10 ++++++++++
 arch/arm/mach-omap2/serial.c |    7 ++++++-
 3 files changed, 23 insertions(+), 1 deletions(-)
