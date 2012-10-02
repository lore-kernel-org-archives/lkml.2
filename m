Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab2JBCmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 22:42:52 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63675 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab2JBCmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 22:42:51 -0400
Date: Mon, 1 Oct 2012 19:43:06 -0700
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, tony@atomide.com
Subject: Re: [GIT PULL 0/12] ARM: soc: updates for 3.7, first batch
Message-ID: <20121002024306.GA1327@quad.lixom.net>
References: <1349135827-24790-1-git-send-email-olof@lixom.net>
 <CA+55aFwoDOdKv9wcqEPkE76+w2TCz+419qp94T3_70jK9dR3-A@mail.gmail.com>
 <CA+55aFzmm=y85k81kAfgiuBb=oaFxi0f83hFb32Y2tTHu1wozw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzmm=y85k81kAfgiuBb=oaFxi0f83hFb32Y2tTHu1wozw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 07:26:26PM -0700, Linus Torvalds wrote:
> On Mon, Oct 1, 2012 at 7:22 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Ok, I've merged them all. As usual, my end result is slightly
> > different from yours, although the differences are pretty small.
> 
> Oh, one more thing: I suspect the OMAP_OCP2SCP config option should
> depend on CONFIG_ARM or something. Just based on the name, I assume it
> doesn't actually work on x86-64, but I see the question..

Ah, yes. It should build fine and not cause breakage, but it's largely
pointless to offer the option. Patch below.


-Olof


>From 5ae0b658cc10af29d7a0a66f2a412a754011ca0e Mon Sep 17 00:00:00 2001
From: Olof Johansson <olof@lixom.net>
Date: Mon, 1 Oct 2012 19:39:33 -0700
Subject: [PATCH] drivers/bus: make ocp2scp depend on OMAP2+

No use in enabling the driver on platforms where it won't be useful.

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Tony Lindgren <tony@atomide.com>
---
 drivers/bus/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
index bbec35d..0f51ed6 100644
--- a/drivers/bus/Kconfig
+++ b/drivers/bus/Kconfig
@@ -6,6 +6,7 @@ menu "Bus devices"
 
 config OMAP_OCP2SCP
 	tristate "OMAP OCP2SCP DRIVER"
+	depends on ARCH_OMAP2PLUS
 	help
 	  Driver to enable ocp2scp module which transforms ocp interface
 	  protocol to scp protocol. In OMAP4, USB PHY is connected via
-- 
1.7.10.1.488.g05fbf7a

