Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab1ITWkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 18:40:43 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37348 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab1ITWkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 18:40:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=bCL6uEDcmrDWox84+Rb0lv8zo5B7bNb/l6PbXPWZhhyimX88N0Q5Dcwnz46Gzya+3
	0QjNCF6YTx6o3IofzwiWQ==
Date: Tue, 20 Sep 2011 15:40:23 -0700
From: Andrew Morton <akpm@google.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH -next] bcma: needs export.h
Message-Id: <20110920154023.c90396d8.akpm@google.com>
In-Reply-To: <CACna6rxGrd-ORWZrc0xsAOKptU_Xj3eGh9qSfX9vJYCPTZrCRg@mail.gmail.com>
References: <20110920173102.d38155c7defbbc29beaae7c0@canb.auug.org.au>
	<4E78CFC0.4020003@xenotime.net>
	<CACna6rxGrd-ORWZrc0xsAOKptU_Xj3eGh9qSfX9vJYCPTZrCRg@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011 20:45:57 +0200
Rafa__ Mi__ecki <zajec5@gmail.com> wrote:

> 2011/9/20 Randy Dunlap <rdunlap@xenotime.net>:
> > From: Randy Dunlap <rdunlap@xenotime.net>
> >
> > bcma/driver_chipcommon_pmu.c needs to include <linux/export.h>,
> > so add it to the headers that are included by bcma_private.h.
> 
> Please take a look at discussion in:
> [PATCH -next] bcma: main.c needs to include <linux/slab.h>
> thread (by Andrew).
> 
> I believe that according to the discussion, such a includes should be
> done in .c files.
> 
> Andrew: can you comment? Am I right?

Ordinarily, yes, it is preferable to include the needed .h files from
within the .c files.  However quite a mumber of kernel subsystems do
take the #include "everything.h" approach.

However, drivers/bcma is a bit odd in that it has bcma_private.h which
includes delay.h (the everything.h approach) but most .c files
explicitly include other things, including export.h.

There's no real pattern here and yes, I agree that the minimal and more
typical approach is better.

--- a/drivers/bcma/driver_chipcommon_pmu.c~bcma-needs-exporth
+++ a/drivers/bcma/driver_chipcommon_pmu.c
@@ -10,6 +10,7 @@
 
 #include "bcma_private.h"
 #include <linux/bcma/bcma.h>
+#include <linux/export.h>
 
 static u32 bcma_chipco_pll_read(struct bcma_drv_cc *cc, u32 offset)
 {
_

