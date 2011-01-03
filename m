Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab1ACPHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 10:07:09 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:48589 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab1ACPHH convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Mon, 3 Jan 2011 10:07:07 -0500
Message-Id: <4D21F426020000780002A120@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 03 Jan 2011 15:07:02 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: <akpm@linux-foundation.org>, <randy.dunlap@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] name_to_dev_t() must not call __init code
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function can't be __init itself (being called from some sysfs
handler), and hence none of the functions it calls can be either.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

---
 init/do_mounts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.37-rc8/init/do_mounts.c
+++ 2.6.37-rc8-do_mounts-sections/init/do_mounts.c
@@ -93,7 +93,7 @@ no_match:
  *
  * Returns the matching dev_t on success or 0 on failure.
  */
-static dev_t __init devt_from_partuuid(char *uuid_str)
+static dev_t devt_from_partuuid(char *uuid_str)
 {
 	dev_t res = 0;
 	struct device *dev = NULL;



