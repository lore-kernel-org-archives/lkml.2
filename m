Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364Ab1IMBzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 21:55:43 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:35699 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab1IMBzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 21:55:42 -0400
Date: Tue, 13 Sep 2011 11:55:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Brown <davidb@codeaurora.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20110913115533.403d4fe6d961ccc8ba9b58b7@canb.auug.org.au>
In-Reply-To: <4E6D6C0D.60100@codeaurora.org>
References: <20110912120501.764336af05069fa23a371b5e@canb.auug.org.au>
	<4E6D6C0D.60100@codeaurora.org>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Sun, 11 Sep 2011 19:18:53 -0700 Stephen Boyd <sboyd@codeaurora.org> wrote:
>
> The device tree machine description also needs to have the .fixup and
> .reserve callbacks added to it so that the device tree machines boot
> properly. Perhaps the soc tree needs to pull in Russell's tree at some
> point to resolve this subtle logical conflict or when the trees are
> merged together someone will need to do an evil merge and add the
> callbacks in the merge commit.

Ah, right.  I have added this merge fixup for today and can carry it as
necessary.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 13 Sep 2011 11:51:48 +1000
Subject: [PATCH] arm-soc: merge fixup for fixup/reserve being added to
 MACHINE descriptions

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/arm/mach-msm/board-msm8x60.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index 328df27..4ad2afb 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -153,6 +153,8 @@ MACHINE_END
 #ifdef CONFIG_OF
 /* TODO: General device tree support for all MSM. */
 DT_MACHINE_START(MSM_DT, "Qualcomm MSM (Flattened Device Tree)")
+	.fixup = msm8x60_fixup,
+	.reserve = msm8x60_reserve,
 	.map_io = msm8x60_map_io,
 	.init_irq = msm8x60_init_irq,
 	.init_machine = msm8x60_dt_init,
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
