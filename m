Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab1LEN3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:29:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57566 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab1LEN3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:29:37 -0500
Date: Mon, 5 Dec 2011 05:29:22 -0800
From: tip-bot for Maurice Ma <maurice.ma@intel.com>
Message-ID: <tip-e9a9eca517d4cd94e816538efc400257e34bc63e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@redhat.com, rui.zhang@intel.com, matt.fleming@intel.com,
        maurice.ma@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, rui.zhang@intel.com,
        matt.fleming@intel.com, maurice.ma@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1318330333-4617-1-git-send-email-matt@console-pimps.org>
References: <1318330333-4617-1-git-send-email-matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86, efi: Convert efi_phys_get_time() args to physical addresses
Git-Commit-ID: e9a9eca517d4cd94e816538efc400257e34bc63e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 05:29:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e9a9eca517d4cd94e816538efc400257e34bc63e
Gitweb:     http://git.kernel.org/tip/e9a9eca517d4cd94e816538efc400257e34bc63e
Author:     Maurice Ma <maurice.ma@intel.com>
AuthorDate: Tue, 11 Oct 2011 11:52:13 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 12:45:14 +0100

x86, efi: Convert efi_phys_get_time() args to physical addresses

Because callers of efi_phys_get_time() pass virtual stack
addresses as arguments, we need to find their corresponding
physical addresses and when calling GetTime() in physical mode.

Without this patch the following line is printed on boot,

	"Oops: efitime: can't read time!"

Signed-off-by: Maurice Ma <maurice.ma@intel.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Matthew Garrett <mjg@redhat.com>
Link: http://lkml.kernel.org/r/1318330333-4617-1-git-send-email-matt@console-pimps.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/platform/efi/efi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 37718f0..d2376eb 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -238,7 +238,8 @@ static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
 
 	spin_lock_irqsave(&rtc_lock, flags);
 	efi_call_phys_prelog();
-	status = efi_call_phys2(efi_phys.get_time, tm, tc);
+	status = efi_call_phys2(efi_phys.get_time, virt_to_phys(tm),
+				virt_to_phys(tc));
 	efi_call_phys_epilog();
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
