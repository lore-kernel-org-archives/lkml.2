Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933714Ab2JKBSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:18:04 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60032 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933620Ab2JKBON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:14:13 -0400
X-Sasl-enc: tL7JtmP6cgtbsok9IL9Ri+HSA4B7b8GE/w8YLULfHqr4 1349918051
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Seiji Aguchi <seiji.aguchi@hds.com>, Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>, Ivan Hu <ivan.hu@canonical.com>
Subject: [ 106/120] efi: initialize efi.runtime_version to make query_variable_info/update_capsule workable
Date: Thu, 11 Oct 2012 10:00:58 +0900
Message-Id: <20121011005846.688947782@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ivan Hu <ivan.hu@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/platform/efi/efi.c |    1 +
 1 file changed, 1 insertion(+)

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


