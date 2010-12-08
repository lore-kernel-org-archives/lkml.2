Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab0LHBLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:11:20 -0500
Received: from kroah.org ([198.145.64.141]:33817 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932821Ab0LHBDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:49 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:47 2010
Message-Id: <20101208005747.106830569@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Vorontsov <cbouatmailru@gmail.com>
Subject: [257/289] ARM: cns3xxx: Fix build with CONFIG_PCI=y
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Vorontsov <cbouatmailru@gmail.com>

commit 44266416f786514ec43a0d15ad951c34566b99c9 upstream.

commit 6338a6aa7c082f11d55712251e14178c68bf5869 ("ARM: 6269/1: Add 'code'
parameter for hook_fault_code()") breaks CNS3xxx build:

  CC      arch/arm/mach-cns3xxx/pcie.o
pcie.c: In function 'cns3xxx_pcie_init':
pcie.c:373: warning: passing argument 4 of 'hook_fault_code' makes integer from pointer without a cast
pcie.c:373: error: too few arguments to function 'hook_fault_code'

This commit fixes the small issue.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-cns3xxx/pcie.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-cns3xxx/pcie.c
+++ b/arch/arm/mach-cns3xxx/pcie.c
@@ -369,7 +369,7 @@ static int __init cns3xxx_pcie_init(void
 {
 	int i;
 
-	hook_fault_code(16 + 6, cns3xxx_pcie_abort_handler, SIGBUS,
+	hook_fault_code(16 + 6, cns3xxx_pcie_abort_handler, SIGBUS, 0,
 			"imprecise external abort");
 
 	for (i = 0; i < ARRAY_SIZE(cns3xxx_pcie); i++) {


