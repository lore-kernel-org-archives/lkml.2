Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab2K2Ra4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 12:30:56 -0500
Received: from ra.se.axis.com ([195.60.68.13]:37515 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518Ab2K2Raz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 12:30:55 -0500
Date: Thu, 29 Nov 2012 18:30:53 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: linux-cifs@vger.kernel.org, sfrench@samba.org,
        linux-kernel@vger.kernel.org
Subject: [RFQ PATCH] cifs: Change default security error message
Message-ID: <20121129173053.GQ27196@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Connecting with a default security mechanism prompts an KERN_ERROR
output warning to the user that the default mechanism will be changed
in Linux 3.3.

We're now at 3.7, so we either could remove the warning completely
(if the default has been changed), or we could bump the number to
what our current target for the change is.


The below patch changes the cERROR (which turns into a printk with KERN_ERROR)
into a straight printk with KERN_WARNING and changes the text to indicate
that it was changed in 3.3.

I expect that the patch is incorrect and that we should choose
another of the alternative solutions above, but I'd like to get
some input on this.

Not-Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c83f5b65..968456f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2480,9 +2480,9 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 	supported for many years, time to update default security mechanism */
 	if ((volume_info->secFlg == 0) && warned_on_ntlm == false) {
 		warned_on_ntlm = true;
-		cERROR(1, "default security mechanism requested.  The default "
-			"security mechanism will be upgraded from ntlm to "
-			"ntlmv2 in kernel release 3.3");
+		printk(KERN_WARNING "default security mechanism requested.  "
+			"The default security mechanism was changed "
+			" from ntlm to ntlmv2 in kernel release 3.3");
 	}
 	ses->overrideSecFlg = volume_info->secFlg;
 


/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
