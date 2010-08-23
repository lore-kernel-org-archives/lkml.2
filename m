Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab0HWVVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 17:21:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44253 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab0HWVVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 17:21:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=dqWUcE7o5ZSk/CywlE0KzTtAT7x2AhcCkftZD+xSCGgtQxTp84KZGOBgmlq5IR43X1
         ozLMGdZVLfmFo+QKIGONbWwKNoJDyez7hXaH6zoiBWF4vBwsUR63uiDSZaTVdvRmAha5
         t85coRAtnGxM12UzbADfGywxuK/CWzLp9c+IY=
Date: Mon, 23 Aug 2010 23:21:03 +0200
From: Dan Carpenter <error27@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] pda_power: remove unneeded assignment
Message-ID: <20100823212103.GA7340@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Anton Vorontsov <cbouatmailru@gmail.com>,
	Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We never use the "ret" value from this assignment, and also
PTR_ERR(NULL) is zero.  I looked at it and this driver is designed to
accept a NULL value for "ac_draw".  So there isn't a bug in the original
code and we can just remove this confusing assignment.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index 69f8aa3..63a6a4d 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -279,7 +279,6 @@ static int pda_power_probe(struct platform_device *pdev)
 	if (IS_ERR(ac_draw)) {
 		dev_dbg(dev, "couldn't get ac_draw regulator\n");
 		ac_draw = NULL;
-		ret = PTR_ERR(ac_draw);
 	}
 
 	if (pdata->is_ac_online) {
