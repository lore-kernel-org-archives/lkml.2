Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab2JNPLE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:11:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46218 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754368Ab2JNOmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:42:12 -0400
Message-Id: <20121014143550.928342644@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:40 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Seiji Aguchi <seiji.aguchi@hds.com>, Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [ 127/147] efi: initialize efi.runtime_version to make
 query_variable_info/update_capsule workable
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seiji Aguchi <seiji.aguchi@hds.com>

commit d6cf86d8f23253225fe2a763d627ecf7dfee9dae upstream.

A value of efi.runtime_version is checked before calling
update_capsule()/query_variable_info() as follows.
But it isn't initialized anywhere.

<snip>
static efi_status_t virt_efi_query_variable_info(u32 attr,
                                                 u64 *storage_space,
                                                 u64 *remaining_space,
                                                 u64 *max_variable_size)
{
        if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
                return EFI_UNSUPPORTED;
<snip>

This patch initializes a value of efi.runtime_version at boot time.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
Acked-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/platform/efi/efi.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 92660eda..f55a4ce 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -890,6 +890,7 @@ void __init efi_enter_virtual_mode(void)
 	 *
 	 * Call EFI services through wrapper functions.
 	 */
+	efi.runtime_version = efi_systab.fw_revision;
 	efi.get_time = virt_efi_get_time;
 	efi.set_time = virt_efi_set_time;
 	efi.get_wakeup_time = virt_efi_get_wakeup_time;


