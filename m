Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab2IQH6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:58:33 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:51319 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab2IQH6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:58:30 -0400
Message-ID: <5056D820.1060302@linux.vnet.ibm.com>
Date: Mon, 17 Sep 2012 09:58:24 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch v2] gcov: add a kfree() on error to new_node()
References: <20120914065203.GB11886@elgon.mountain>
In-Reply-To: <20120914065203.GB11886@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091707-7282-0000-0000-00000D194B30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.09.2012 08:52, Dan Carpenter wrote:
> We should free "node->loaded_info" on this error path.  We'd never care
> in real life but it makes the static checkers happy.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: some style changes.
>

Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

Thanks for sending this patch.

Andrew, since there is no tree for gcov patches, could you queue this 
for upstream inclusion?


Regards,
   Peter Oberparleiter

---
We should free "node->loaded_info" on this error path.  We'd never care
in real life but it makes the static checkers happy.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
---
v2: some style changes.

diff --git a/kernel/gcov/fs.c b/kernel/gcov/fs.c
index 9bd0934..7ba47f7 100644
--- a/kernel/gcov/fs.c
+++ b/kernel/gcov/fs.c
@@ -451,8 +451,7 @@ static struct gcov_node *new_node(struct gcov_node 
*parent,
  		node->dentry = debugfs_create_dir(node->name, parent->dentry);
  	if (!node->dentry) {
  		pr_warning("could not create file\n");
-		kfree(node);
-		return NULL;
+		goto err_info;
  	}
  	if (info)
  		add_links(node, parent->dentry);
@@ -461,6 +460,8 @@ static struct gcov_node *new_node(struct gcov_node 
*parent,

  	return node;

+err_info:
+	kfree(node->loaded_info);
  err_nomem:
  	kfree(node);
  	pr_warning("out of memory\n");

