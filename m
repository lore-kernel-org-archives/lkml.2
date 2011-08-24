Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab1HXElm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 00:41:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47123 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab1HXElk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 00:41:40 -0400
Date: Wed, 24 Aug 2011 14:41:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: linux-next: manual merge of the staging tree with the fbdev tree
Message-Id: <20110824144134.00bd3a688fb39b5d5563ff13@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/xgifb/XGI_main_26.c between commit c42a3d543d2b
("staging: xgifb: use display information in info not in var for
panning") from the fbdev tree and commit c39aada6926c ("staging: xgifb:
eliminate #ifdef XGIFB_PAN") from the staging tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/xgifb/XGI_main_26.c
index f8b88ad,4415d4a..0000000
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@@ -1363,8 -1357,7 +1357,7 @@@ static int XGIfb_do_set_var(struct fb_v
  	return 0;
  }
  
- #ifdef XGIFB_PAN
 -static int XGIfb_pan_var(struct fb_var_screeninfo *var)
 +static int XGIfb_pan_var(struct fb_var_screeninfo *var, struct fb_info *info)
  {
  	unsigned int base;
  
