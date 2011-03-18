Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab1CRLBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 07:01:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54285 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab1CRLBK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 07:01:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=f/f4O6id4Z2HFacO4yEaBVnLVBASNAZaF894wFe6+QPe/0rOHEbPOqpCrgSvTKnhIX
         NYWH1c09oDODPOCZaCIrD6GQWRCkvYy6g/IY1RLtOLhELplrQFej/GR1aDoz9WgkHRTX
         /FIsSnx6Zt96/sHPtwhkcNh8EIhGuWWmLVqiQ=
MIME-Version: 1.0
Date: Fri, 18 Mar 2011 17:01:08 +0600
Message-ID: <AANLkTi=uysftkFdzEE2Xshg3br_tFB=hhZ4BwX-TzLm0@mail.gmail.com>
Subject: [PATCH] fs,ocfs2: Move o2net_get_func_run_time under CONFIG_OCFS2_FS_STATS.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <jlbec@evilplan.org>,
        Sunil Mushran <sunil.mushran@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_DEBUG_FS=y and CONFIG_OCFS2_FS_STATS=n, we get the
following warning:

fs/ocfs2/cluster/tcp.c:213:16: warning: ‘o2net_get_func_run_time’
defined but not used

Since o2net_get_func_run_time is only called from
o2net_update_recv_stats, so move it under CONFIG_OCFS2_FS_STATS.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 3b11cb1..ee04ff5 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -210,10 +210,6 @@ static inline void
o2net_set_func_stop_time(struct o2net_sock_container *sc)
 	sc->sc_tv_func_stop = ktime_get();
 }

-static ktime_t o2net_get_func_run_time(struct o2net_sock_container *sc)
-{
-	return ktime_sub(sc->sc_tv_func_stop, sc->sc_tv_func_start);
-}
 #else  /* CONFIG_DEBUG_FS */
 # define o2net_init_nst(a, b, c, d, e)
 # define o2net_set_nst_sock_time(a)
@@ -227,10 +223,14 @@ static ktime_t o2net_get_func_run_time(struct
o2net_sock_container *sc)
 # define o2net_set_advance_stop_time(a)
 # define o2net_set_func_start_time(a)
 # define o2net_set_func_stop_time(a)
-# define o2net_get_func_run_time(a)		(ktime_t)0
 #endif /* CONFIG_DEBUG_FS */

 #ifdef CONFIG_OCFS2_FS_STATS
+static ktime_t o2net_get_func_run_time(struct o2net_sock_container *sc)
+{
+	return ktime_sub(sc->sc_tv_func_stop, sc->sc_tv_func_start);
+}
+
 static void o2net_update_send_stats(struct o2net_send_tracking *nst,
 				    struct o2net_sock_container *sc)
 {
