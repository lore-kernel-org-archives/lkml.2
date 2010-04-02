Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab0DBLfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 07:35:08 -0400
Received: from mail-bw0-f217.google.com ([209.85.218.217]:42745 "EHLO
	mail-bw0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab0DBLfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 07:35:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=aN2W83qQ5AA08VDfDwhiWgdbLnVe4+G3nLRnOVwMIuGjR2wpBSrMnppIyRpTYkxQDV
         d6x/vrMTWr2lBTPBUZXgDvyU28bqsX7CTgegu/cxbE571Dto8iyXXi9nBY2nMlwIIHQQ
         lVmiocc/xoJDA1Qxj2XcxHKupwPgqUTGjaOL8=
Date: Fri, 2 Apr 2010 14:28:43 +0300
From: Dan Carpenter <error27@gmail.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Shaun Ruffell <sruffell@digium.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] dma-debug: off by one issue
Message-ID: <20100402112843.GI5265@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Joerg Roedel <joerg.roedel@amd.com>, Ingo Molnar <mingo@elte.hu>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	Shaun Ruffell <sruffell@digium.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to reserve the last character for the NULL terminator.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index ba8b670..01e6427 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -570,7 +570,7 @@ static ssize_t filter_write(struct file *file, const char __user *userbuf,
 	 * Now parse out the first token and use it as the name for the
 	 * driver to filter for.
 	 */
-	for (i = 0; i < NAME_MAX_LEN; ++i) {
+	for (i = 0; i < NAME_MAX_LEN - 1; ++i) {
 		current_driver_name[i] = buf[i];
 		if (isspace(buf[i]) || buf[i] == ' ' || buf[i] == 0)
 			break;
