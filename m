Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275Ab0GUDUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 23:20:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60819 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932940Ab0GUDUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 23:20:08 -0400
Date: Wed, 21 Jul 2010 13:20:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@suse.de>,
        mark gross <markgross@thegnar.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: manual merge of the suspend tree with the wireless tree
Message-Id: <20100721132006.ff026db8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

Today's linux-next merge of the suspend tree got a conflict in
drivers/net/wireless/ipw2x00/ipw2100.c between commit
d267be307a3345ef06889511cad2aa1fecc83db7 ("ipw2100: mark
ipw2100_pm_qos_req static") from the wireless tree and commit
82f682514a5df89ffb3890627eebf0897b7a84ec ("pm_qos: Get rid of the
allocation in pm_qos_add_request()") from the suspend tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/ipw2x00/ipw2100.c
index 5bbff4c,7f0d98b..0000000
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@@ -174,7 -174,7 +174,7 @@@ that only one external action is invoke
  #define DRV_DESCRIPTION	"Intel(R) PRO/Wireless 2100 Network Driver"
  #define DRV_COPYRIGHT	"Copyright(c) 2003-2006 Intel Corporation"
  
- static struct pm_qos_request_list *ipw2100_pm_qos_req;
 -struct pm_qos_request_list ipw2100_pm_qos_req;
++static struct pm_qos_request_list ipw2100_pm_qos_req;
  
  /* Debugging stuff */
  #ifdef CONFIG_IPW2100_DEBUG
