Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048Ab2KNReo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 12:34:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50054 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978Ab2KNRem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 12:34:42 -0500
Date: Wed, 14 Nov 2012 09:34:23 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-5d6d578c170bb280db5d4779f666e456f4f82ec5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jbeulich@suse.com, matt.fleming@intel.com, JBeulich@suse.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@suse.com, matt.fleming@intel.com, JBeulich@suse.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <509A9E6002000078000A7079@nat28.tlf.novell.com>
References: <509A9E6002000078000A7079@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/efi] x86, efi:
  Check table header length in efi_bgrt_init()
Git-Commit-ID: 5d6d578c170bb280db5d4779f666e456f4f82ec5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 14 Nov 2012 09:34:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5d6d578c170bb280db5d4779f666e456f4f82ec5
Gitweb:     http://git.kernel.org/tip/5d6d578c170bb280db5d4779f666e456f4f82ec5
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Wed, 7 Nov 2012 16:46:08 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 14 Nov 2012 08:49:34 -0800

x86, efi: Check table header length in efi_bgrt_init()

Header length should be validated for all ACPI tables before accessing
any non-header field.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/509A9E6002000078000A7079@nat28.tlf.novell.com
Acked-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/efi/efi-bgrt.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
index f6a0c1b..d9c1b95 100644
--- a/arch/x86/platform/efi/efi-bgrt.c
+++ b/arch/x86/platform/efi/efi-bgrt.c
@@ -39,6 +39,8 @@ void efi_bgrt_init(void)
 	if (ACPI_FAILURE(status))
 		return;
 
+	if (bgrt_tab->header.length < sizeof(*bgrt_tab))
+		return;
 	if (bgrt_tab->version != 1)
 		return;
 	if (bgrt_tab->image_type != 0 || !bgrt_tab->image_address)
