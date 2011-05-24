Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449Ab1EXXx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 19:53:57 -0400
Received: from smtp-out.google.com ([74.125.121.67]:55644 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933278Ab1EXXxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 19:53:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=VgcFSngrbIGeLtzkld+BgzKG+NnSNiyNTkqlUM5kTBqW436WvGjPedjJIvAVkgfUmH
         COjkI9zJ+n3gxGDnhIVA==
Date: Tue, 24 May 2011 16:53:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 3/6] scsi, fnic: require DMA support for Cisco FNIC
In-Reply-To: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1105241651350.29780@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Cisco FNIC driver requires creating a SLAB_CACHE_DMA cache, which is
not possible if CONFIG_ZONE_DMA is disasbled.  Avoid compiling it without
DMA support.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/scsi/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -688,7 +688,7 @@ config FCOE
 
 config FCOE_FNIC
 	tristate "Cisco FNIC Driver"
-	depends on PCI && X86
+	depends on PCI && X86 && ZONE_DMA
 	select LIBFCOE
 	help
 	  This is support for the Cisco PCI-Express FCoE HBA.
