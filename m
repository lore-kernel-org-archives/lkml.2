Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab2HGXbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:31:18 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45258 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757209Ab2HGWak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:30:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sachin Prabhu <sprabhu@redhat.com>,
        =?UTF-8?q?G=C3=BCnter=20Kukkukk?= <linux@kukkukk.com>,
        Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>
Subject: =?UTF-8?q?=5B=20070/122=5D=20cifs=3A=20reinstate=20sec=3Dntlmv2=20mount=20option?=
Date: Tue,  7 Aug 2012 15:25:58 -0700
Message-Id: <20120807221954.841502302@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 7659624ffb550d69c87f9af9ae63e717daa874bd upstream.

sec=ntlmv2 as a mount option got dropped in the mount option overhaul.

Cc: Sachin Prabhu <sprabhu@redhat.com>
Reported-by: Günter Kukkukk <linux@kukkukk.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/connect.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -238,8 +238,8 @@ static const match_table_t cifs_mount_op
 enum {
 	Opt_sec_krb5, Opt_sec_krb5i, Opt_sec_krb5p,
 	Opt_sec_ntlmsspi, Opt_sec_ntlmssp,
-	Opt_ntlm, Opt_sec_ntlmi, Opt_sec_ntlmv2i,
-	Opt_sec_nontlm, Opt_sec_lanman,
+	Opt_ntlm, Opt_sec_ntlmi, Opt_sec_ntlmv2,
+	Opt_sec_ntlmv2i, Opt_sec_lanman,
 	Opt_sec_none,
 
 	Opt_sec_err
@@ -253,8 +253,9 @@ static const match_table_t cifs_secflavo
 	{ Opt_sec_ntlmssp, "ntlmssp" },
 	{ Opt_ntlm, "ntlm" },
 	{ Opt_sec_ntlmi, "ntlmi" },
+	{ Opt_sec_ntlmv2, "nontlm" },
+	{ Opt_sec_ntlmv2, "ntlmv2" },
 	{ Opt_sec_ntlmv2i, "ntlmv2i" },
-	{ Opt_sec_nontlm, "nontlm" },
 	{ Opt_sec_lanman, "lanman" },
 	{ Opt_sec_none, "none" },
 
@@ -1167,7 +1168,7 @@ static int cifs_parse_security_flavors(c
 	case Opt_sec_ntlmi:
 		vol->secFlg |= CIFSSEC_MAY_NTLM | CIFSSEC_MUST_SIGN;
 		break;
-	case Opt_sec_nontlm:
+	case Opt_sec_ntlmv2:
 		vol->secFlg |= CIFSSEC_MAY_NTLMV2;
 		break;
 	case Opt_sec_ntlmv2i:


