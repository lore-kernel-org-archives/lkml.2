Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab2JCIbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 04:31:40 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756023Ab2JCIbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 04:31:35 -0400
Date: Wed, 3 Oct 2012 10:30:45 +0200
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the ubi tree
Message-ID: <20121003103045.140f3a7a@spider.haslach.nod.at>
In-Reply-To: <1349248843.2017.108.camel@sauron.fi.intel.com>
References: <20121003122735.692388e2f68dd85e43052c70@canb.auug.org.au>
	<1349248843.2017.108.camel@sauron.fi.intel.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem, Stephen,

Am Wed, 03 Oct 2012 10:20:43 +0300
schrieb Artem Bityutskiy <dedekind1@gmail.com>:

> On Wed, 2012-10-03 at 12:27 +1000, Stephen Rothwell wrote:
> > Hi Artem,
> > 
> > After merging the ubi tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> > 
> > ERROR: "ubi_update_fastmap" [drivers/mtd/ubi/ubi.ko] undefined!
> > ERROR: "ubi_scan_fastmap" [drivers/mtd/ubi/ubi.ko] undefined!
> > ERROR: "ubi_calc_fm_size" [drivers/mtd/ubi/ubi.ko] undefined!
> 
> I've added Richard's fastmap work there. I'll look at these failures.

Thanks for reporting this.
I'm not sure why this happens with allmodconfig.
If I set CONFIG_MTD=m and CONFIG_MTD_UBI=m it builds fine,
that's how I did most build tests.

The following patch fixes the issue for me.
Artem, are you fine with it?

Thanks,
//richard

---
diff --git a/drivers/mtd/ubi/Makefile b/drivers/mtd/ubi/Makefile
index 7ab19ac..b46b0c97 100644
--- a/drivers/mtd/ubi/Makefile
+++ b/drivers/mtd/ubi/Makefile
@@ -2,6 +2,6 @@ obj-$(CONFIG_MTD_UBI) += ubi.o
 
 ubi-y += vtbl.o vmt.o upd.o build.o cdev.o kapi.o eba.o io.o wl.o
attach.o ubi-y += misc.o debug.o
+ubi-$(CONFIG_MTD_UBI_FASTMAP) += fastmap.o
 
 obj-$(CONFIG_MTD_UBI_GLUEBI) += gluebi.o
-obj-$(CONFIG_MTD_UBI_FASTMAP) += fastmap.o
