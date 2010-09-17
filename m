Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab0IQI1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 04:27:12 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63415 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab0IQIZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 04:25:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TE1We6m3mujgBvm5GBF6gLCOvnziD/RsWtX5nnNsUeVek/ngv4V5STzkiGD0u6+Gak
         WC4A3Q8ZML+akEYifmCG5NESoSyauHgQo55qU+8bb7wUArcKRktDDd83r+4kfRYg/8ET
         ar+Xt4lfwwDhw+nO8PFmoiYda3N12Di1uNwOU=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 3/9] staging: cxt1e1: '&pointer[0]' to 'pointer' fix
Date: Fri, 17 Sep 2010 11:24:45 +0300
Message-Id: <268ead0b2dead55f39d2d2a1c09b165a2f73bd7f.1284711623.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <20100916225346.GA14448@kroah.com>
References: <20100916225346.GA14448@kroah.com>
In-Reply-To: <668ce39e9bd64e2a285367e2cc0963d678d1b501.1284711623.git.andy.shevchenko@gmail.com>
References: <668ce39e9bd64e2a285367e2cc0963d678d1b501.1284711623.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/cxt1e1/sbeproc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/cxt1e1/sbeproc.c b/drivers/staging/cxt1e1/sbeproc.c
index af8fce4..c3eed4b 100644
--- a/drivers/staging/cxt1e1/sbeproc.c
+++ b/drivers/staging/cxt1e1/sbeproc.c
@@ -143,7 +143,7 @@ sbecom_proc_get_sbe_info (char *buffer, char **start, off_t offset,
     len += sprintf (buffer + len, "Hardware ID:   0x%02X\n", ci->hdw_bid);
     len += sprintf (buffer + len, "Board SN:      %06X\n", bip->brd_sn);
 	len += sprintf(buffer + len, "Board MAC:     %pMF\n",
-		&bip->brd_mac_addr[0]);
+		bip->brd_mac_addr);
     len += sprintf (buffer + len, "Ports:         %d\n", ci->max_port);
     len += sprintf (buffer + len, "Channels:      %d\n", bip->brd_chan_cnt);
 #if 1
-- 
1.7.2.2

