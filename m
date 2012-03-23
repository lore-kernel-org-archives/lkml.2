Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab2CWJBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 05:01:41 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33147 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757835Ab2CWJBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 05:01:36 -0400
Message-ID: <1332493291.2801.14.camel@dabdike.int.hansenpartnership.com>
Subject: Re: linux-next: build failure after merge of the scsi tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Jeff Garzik <jgarzik@pobox.com>
Date: Fri, 23 Mar 2012 09:01:31 +0000
In-Reply-To: <1332492832.2882.4.camel@pasglop>
References: <20120323130031.c097ca3755de5ff5879504e1@canb.auug.org.au>
	 <1332478202.2882.2.camel@pasglop>
	 <1332490486.2801.1.camel@dabdike.int.hansenpartnership.com>
	 <1332492832.2882.4.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-23 at 19:53 +1100, Benjamin Herrenschmidt wrote:
> On Fri, 2012-03-23 at 08:14 +0000, James Bottomley wrote:
> > > Additionally, I am the author and maintainer of that driver and I
> > don't
> > > remember ever being CCed on that patch ... or did I miss it ?
> > 
> > You missed it ... I added you and Jeff for automatic cc's when the
> > commit hit the scsi tree.
> > 
> > This is the mail log:
> > 
> > Mar 22 07:53:17 bedivere postfix/smtp[14322]: C3A1F8EE136:
> > to=<benh@kernel.crashing.org>,
> > relay=gate.crashing.org[63.228.1.57]:25, delay=2.7,
> > delays=0.13/0.12/1.3/1.2, dsn=2.0.0, status=sent (250 2.0.0
> > q2MErGNT019145 Message accepted for delivery)
> 
> Allright, Mar 22, that's yesterday (.au time)... that's a short time
> between notifying the maintainer and going into -next :-) No biggie,
> I'll have a look next week, it's just annoying to get build failure
> reports from Stephen about drivers I own for patches I never heard
> about ...

Yes, sorry ... it's one of those large all or nothing type series that
touches about 33 different drivers (about 75% of which are
unmaintained).

I would have checked the ppc compile if I still had a working ppc
machine.  Having looked through the code, I think this is the fix ...
could someone check?

James

---

diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index 05838bf..0bbd0cb 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -42,6 +42,7 @@
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
+#include <linux/proc_fs.h>
 #include <linux/interrupt.h>
 #include <linux/device.h>
 #include <scsi/scsi_host.h>



