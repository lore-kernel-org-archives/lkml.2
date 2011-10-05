Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933912Ab1JEFyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 01:54:12 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:38849 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932975Ab1JEFyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 01:54:11 -0400
Date: Wed, 5 Oct 2011 08:53:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        kernel-janitors@vger.kernel.org
Subject: [patch] memory hotplug: release lock on an error path
Message-ID: <20111005055326.GA32187@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090204.4E8BF0E0.00A9,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to release the mutex here before returning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index ca8bfe5..164c8a2 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -299,7 +299,7 @@ static int memory_block_change_state(struct memory_block *mem,
 		for (i = 0; i < sections_per_block; i++) {
 			ret = check_page_reservations(mem->start_section_nr + i);
 			if (ret)
-				return ret;
+				goto out;
 		}
 	}

