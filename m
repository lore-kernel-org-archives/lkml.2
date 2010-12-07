Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab0LGPCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:02:07 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:36192 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab0LGPCE convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:1:1>);
	Tue, 7 Dec 2010 10:02:04 -0500
Message-Id: <4CFE5A7B020000780002671D@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 07 Dec 2010 15:02:03 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] name_to_dev_t() must not call __init code
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function can't be __init itself (being called from some sysfs
handler), and hence none of the functions it call can be either.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 init/do_mounts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.37-rc5/init/do_mounts.c
+++ 2.6.37-rc5-do_mounts-sections/init/do_mounts.c
@@ -93,7 +93,7 @@ no_match:
  *
  * Returns the matching dev_t on success or 0 on failure.
  */
-static dev_t __init devt_from_partuuid(char *uuid_str)
+static dev_t devt_from_partuuid(char *uuid_str)
 {
 	dev_t res = 0;
 	struct device *dev = NULL;



