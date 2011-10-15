Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab1JOWis (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 18:38:48 -0400
Received: from smtp-out.google.com ([216.239.44.51]:43545 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab1JOWiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 18:38:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=f9QYwCRXENXyf4sZXGX8PIEP9EgOqxlNopi+y/3wvvT4YAkPwjW52n/1KvCe18hEX
	47lvAmOOt8TQWw1IrUh3g==
Date: Sat, 15 Oct 2011 15:38:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: James Bottomley <James.Bottomley@hansenpartnership.com>
cc: Andi Kleen <andi@firstfloor.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [patch] parisc, iommu: add missing include for prefetchw()
In-Reply-To: <1318631204.3018.101.camel@dabdike.int.hansenpartnership.com>
Message-ID: <alpine.DEB.2.00.1110151536310.25063@chino.kir.corp.google.com>
References: <20111013233818.GB26654@one.firstfloor.org> <1318631204.3018.101.camel@dabdike.int.hansenpartnership.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prefetchw() requires it to be defined by linux/prefetch.h, or it results
in a compile error:

In file included from drivers/parisc/sba_iommu.c:916:0:
drivers/parisc/iommu-helpers.h: In function 'iommu_fill_pdir':
drivers/parisc/iommu-helpers.h:62:4: error: implicit declaration of function 'prefetchw'

Include linux/prefetch.h.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/parisc/iommu-helpers.h |    2 ++
 1 files changed, 2 insertions(+)

diff --git a/drivers/parisc/iommu-helpers.h b/drivers/parisc/iommu-helpers.h
--- a/drivers/parisc/iommu-helpers.h
+++ b/drivers/parisc/iommu-helpers.h
@@ -1,3 +1,5 @@
+#include <linux/prefetch.h>
+
 /**
  * iommu_fill_pdir - Insert coalesced scatter/gather chunks into the I/O Pdir.
  * @ioc: The I/O Controller.
