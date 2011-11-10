Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935697Ab1KJQ3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 11:29:08 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48477 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932822Ab1KJQ3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 11:29:05 -0500
Date: Thu, 10 Nov 2011 20:28:59 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jgarzik@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH] ata: Don't use NO_IRQ in pata_of_platform driver
Message-ID: <20111110162859.GA7088@oksana.dev.rtsoft.ru>
References: <20111110151852.GA7465@oksana.dev.rtsoft.ru>
 <20111110152606.GB3207@oksana.dev.rtsoft.ru>
 <20111110153816.239af1d7@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111110153816.239af1d7@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers should not use NO_IRQ; moreover, some architectures don't
have it nowadays. '0' is the 'no irq' case.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
Acked-by: Alan Cox <alan@linux.intel.com>
---

On Thu, Nov 10, 2011 at 03:38:16PM +0000, Alan Cox wrote:
> On Thu, 10 Nov 2011 19:26:06 +0400
> Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> 
> > Drivers should not use NO_IRQ; moreover, some architectures don't
> > have it nowadays. '0' is the 'no irq' case.
> > 
> > Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
> 
> Acked-by: Alan Cox <alan@linux.intel.com>

In case if we don't want a "band-aid fix" for 3.2, here is the patch
that just does the proper fix (w/ a risk to break minor architectures).

 drivers/ata/pata_of_platform.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/pata_of_platform.c b/drivers/ata/pata_of_platform.c
index a72ab0d..2a472c5 100644
--- a/drivers/ata/pata_of_platform.c
+++ b/drivers/ata/pata_of_platform.c
@@ -52,7 +52,7 @@ static int __devinit pata_of_platform_probe(struct platform_device *ofdev)
 	}
 
 	ret = of_irq_to_resource(dn, 0, &irq_res);
-	if (ret == NO_IRQ)
+	if (!ret)
 		irq_res.start = irq_res.end = 0;
 	else
 		irq_res.flags = 0;
-- 
1.7.5.3

