Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab1K1Wtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 17:49:42 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37516 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab1K1Wtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 17:49:41 -0500
Subject: [PATCH] efivars: add missing parameter to efi_pstore_read()
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Mike Waychison <mikew@google.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Tony Luck <tony.luck@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Dan Carpenter <error27@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 28 Nov 2011 23:49:33 +0100
Message-ID: <1322520574.24241.10.camel@mars>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case where CONFIG_PSTORE=n, the function efi_pstore_read() doesn't
have the correct list of parameters. This patch provides a definition
of efi_pstore_read() with 'char **buf' added to fix this warning:
"drivers/firmware/efivars.c:609: warning: initialization from".

Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
---
 drivers/firmware/efivars.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index a54a6b9..b0a8117 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -581,7 +581,8 @@ static int efi_pstore_close(struct pstore_info *psi)
 }
 
 static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
-			       struct timespec *time, struct pstore_info *psi)
+			       struct timespec *timespec,
+			       char **buf, struct pstore_info *psi)
 {
 	return -1;
 }
-- 
1.7.2.5


