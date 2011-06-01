Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163225Ab1FAI31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:29:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163248Ab1FAI3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:29:17 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:12:28 2011
Message-Id: <20110601081227.779439393@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:12:10 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [160/165] xen/setup: Ignore E820_UNUSABLE when setting 1-1 mappings.
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 922
Lines: 28

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 15bfc094517db2ddf38ca7ed47f3a1c0ad24f7c4 upstream.

When we parse the raw E820, the Xen hypervisor can set "E820_RAM"
to "E820_UNUSABLE" if the mem=X argument is used. As such we
should _not_ consider the E820_UNUSABLE as an 1-1 identity
mapping, but instead use the same case as for E820_RAM.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -166,7 +166,7 @@ static unsigned long __init xen_set_iden
 		if (last > end)
 			continue;
 
-		if (entry->type == E820_RAM) {
+		if ((entry->type == E820_RAM) || (entry->type == E820_UNUSABLE)) {
 			if (start > start_pci)
 				identity += set_phys_range_identity(
 						PFN_UP(start_pci), PFN_DOWN(start));


