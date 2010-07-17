Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759862Ab0GQK1e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 06:27:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45621 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759843Ab0GQK1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 06:27:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=PyOdGjOxRBofMFP3aAhm7bHdoWU1pLlOFDKgh8Rjg4+8mssA+ZXHd1pShzrea18fTk
         Q7iWZPpWOMCIh1FMF7z5QzDIZjGXUb21Wb1kwyEqmd7qggvj7xoIHkkiT60OruA84uN8
         0O4mAbIRY4H3zRqRFAhtvoT1ef0SVqY8MSN6I=
Date: Sat, 17 Jul 2010 12:26:08 +0200
From: Dan Carpenter <error27@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] auditsc: audit_log_single_execve_arg() returns signed
Message-ID: <20100717102608.GE17585@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"len" needs to be signed because audit_log_single_execve_arg() returns
-1 and we want to check for that:

                len = audit_log_single_execve_arg(context, ab, i,
                                                  &len_sent, p, buf);
                if (len <= 0)
                        break;

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 3828ad5..2c060c3 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1158,7 +1158,8 @@ static void audit_log_execve_info(struct audit_context *context,
 				  struct audit_aux_data_execve *axi)
 {
 	int i;
-	size_t len, len_sent = 0;
+	ssize_t len;
+	size_t len_sent = 0;
 	const char __user *p;
 	char *buf;
 
