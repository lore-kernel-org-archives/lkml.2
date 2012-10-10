Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184Ab2JKAgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:36:39 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38447 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933118Ab2JKAXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:23:15 -0400
X-Sasl-enc: vS839qZ2g7bG+egrwwsQ7z7QPdxlYCh8hTCp/tQM7HGk 1349914994
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Gregory Lee Bartholomew <gregory.lee.bartholomew@gmail.com>,
        Sachin Prabhu <sprabhu@redhat.com>, Jeff Layton <jlayton@redhat.com>,
        Steve French <smfrench@gmail.com>
Subject: [ 121/122] cifs: reinstate the forcegid option
Date: Thu, 11 Oct 2012 07:54:47 +0900
Message-Id: <20121010225359.738905775@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 72bd481f860f0125c810bb43d878ce5f9c060c58 upstream.

Apparently this was lost when we converted to the standard option
parser in 8830d7e07a5e38bc47650a7554b7c1cfd49902bf

Reported-by: Gregory Lee Bartholomew <gregory.lee.bartholomew@gmail.com>
Cc: Sachin Prabhu <sprabhu@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/connect.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -67,6 +67,7 @@ enum {
 	/* Mount options that take no arguments */
 	Opt_user_xattr, Opt_nouser_xattr,
 	Opt_forceuid, Opt_noforceuid,
+	Opt_forcegid, Opt_noforcegid,
 	Opt_noblocksend, Opt_noautotune,
 	Opt_hard, Opt_soft, Opt_perm, Opt_noperm,
 	Opt_mapchars, Opt_nomapchars, Opt_sfu,
@@ -118,6 +119,8 @@ static const match_table_t cifs_mount_op
 	{ Opt_nouser_xattr, "nouser_xattr" },
 	{ Opt_forceuid, "forceuid" },
 	{ Opt_noforceuid, "noforceuid" },
+	{ Opt_forcegid, "forcegid" },
+	{ Opt_noforcegid, "noforcegid" },
 	{ Opt_noblocksend, "noblocksend" },
 	{ Opt_noautotune, "noautotune" },
 	{ Opt_hard, "hard" },
@@ -1190,6 +1193,12 @@ cifs_parse_mount_options(const char *mou
 		case Opt_noforceuid:
 			override_uid = 0;
 			break;
+		case Opt_forcegid:
+			override_gid = 1;
+			break;
+		case Opt_noforcegid:
+			override_gid = 0;
+			break;
 		case Opt_noblocksend:
 			vol->noblocksnd = 1;
 			break;


