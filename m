Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab1F2PJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:09:19 -0400
Received: from bar.sig21.net ([80.81.252.164]:40829 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238Ab1F2PJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:09:10 -0400
Date: Wed, 29 Jun 2011 17:09:07 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: missing compat-ioctl for CDROM_DRIVE_STATUS + FDGETPRM
Message-ID: <20110629150907.GA3412@sig21.net>
References: <20110617090424.GA19345@sig21.net>
 <201106171502.39445.arnd@arndb.de>
 <20110629113834.GA4227@sig21.net>
 <201106291430.43102.arnd@arndb.de>
 <20110629125117.GA5739@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629125117.GA5739@sig21.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -3.8 (---)
X-Spam-21-Report: No, score=-3.8 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.643,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 02:51:17PM +0200, Johannes Stezenbach wrote:
> On Wed, Jun 29, 2011 at 02:30:42PM +0200, Arnd Bergmann wrote:
> > On Wednesday 29 June 2011, Johannes Stezenbach wrote:
> > > Do I get it right that just adding two IGNORE_IOCTL() to
> > > the ioctl_pointer array in linux/fs/compat_ioctl.c is sufficient,
> > > like in commit 3f001711?
> > 
> > Yes.

Hm, it only works for CDROM_DRIVE_STATUS, but I still get
the warning for FDGETPRM (801c0204).  Could you give
me a hint how to address this?

(tested with both 2.6.39.2 and 3.0-rc5-63-g0d72c6f)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 61abb63..ae24aba 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -68,6 +68,8 @@
 
 #ifdef CONFIG_BLOCK
 #include <linux/loop.h>
+#include <linux/cdrom.h>
+#include <linux/fd.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/sg.h>
@@ -944,6 +946,9 @@ COMPATIBLE_IOCTL(FIOQSIZE)
 IGNORE_IOCTL(LOOP_CLR_FD)
 /* md calls this on random blockdevs */
 IGNORE_IOCTL(RAID_VERSION)
+/* qemu/qemu-img might calls these two on plain files for probing */
+IGNORE_IOCTL(CDROM_DRIVE_STATUS)
+IGNORE_IOCTL(FDGETPRM)
 /* SG stuff */
 COMPATIBLE_IOCTL(SG_SET_TIMEOUT)
 COMPATIBLE_IOCTL(SG_GET_TIMEOUT)


Thanks,
Johannes
