Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab2BXLco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 06:32:44 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:21246 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab2BXLcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 06:32:10 -0500
Date: Fri, 24 Feb 2012 14:31:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] epoll: remove unneeded variable in reverse_path_check()
Message-ID: <20120224113158.GA17641@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4F477539.003C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We never use the length variable.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index c636fc8..997a6d2 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1042,13 +1042,11 @@ static int reverse_path_check_proc(void *priv, void *cookie, int call_nests)
  */
 static int reverse_path_check(void)
 {
-	int length = 0;
 	int error = 0;
 	struct file *current_file;
 
 	/* let's call this for all tfiles */
 	list_for_each_entry(current_file, &tfile_check_list, f_tfile_llink) {
-		length++;
 		path_count_init();
 		error = ep_call_nested(&poll_loop_ncalls, EP_MAX_NESTS,
 					reverse_path_check_proc, current_file,
