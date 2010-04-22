Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab0DVTtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:49:33 -0400
Received: from kroah.org ([198.145.64.141]:41031 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756565Ab0DVT2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:54 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:16 2010
Message-Id: <20100422190916.844757206@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [106/197] x86/amd-iommu: Use helper function to destroy domain
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit 8b408fe4f853dcfa18d133aa4cf1d7546b4c3870 upstream.

In the amd_iommu_domain_destroy the protection_domain_free
function is partly reimplemented. The 'partly' is the bug
here because the domain is not deleted from the domain list.
This results in use-after-free errors and data-corruption.
Fix it by just using protection_domain_free instead.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/amd_iommu.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2239,9 +2239,7 @@ static void amd_iommu_domain_destroy(str
 
 	free_pagetable(domain);
 
-	domain_id_free(domain->id);
-
-	kfree(domain);
+	protection_domain_free(domain);
 
 	dom->priv = NULL;
 }


