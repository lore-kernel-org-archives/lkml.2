Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab2ACWmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:42:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40442 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756394Ab2ACWlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:41:55 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:26 2012
Message-Id: <20120103223326.357597879@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:33:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Graf <tgraf@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [63/75] mqprio: Avoid panic if no options are provided
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Thomas Graf <tgraf@redhat.com>

[ Upstream commit 7838f2ce36b6ab5c13ef20b1857e3bbd567f1759 ]

Userspace may not provide TCA_OPTIONS, in fact tc currently does
so not do so if no arguments are specified on the command line.
Return EINVAL instead of panicing.

Signed-off-by: Thomas Graf <tgraf@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/sched/sch_mqprio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -106,7 +106,7 @@ static int mqprio_init(struct Qdisc *sch
 	if (!netif_is_multiqueue(dev))
 		return -EOPNOTSUPP;
 
-	if (nla_len(opt) < sizeof(*qopt))
+	if (!opt || nla_len(opt) < sizeof(*qopt))
 		return -EINVAL;
 
 	qopt = nla_data(opt);


