Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804Ab1DZVhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:37:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:19974 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758711Ab1DZVNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:13:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="425950962"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: segoon@openwall.com, padovan@profusion.mobi, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [24/106] Bluetooth: sco: fix information leak to userspace
Message-Id: <20110426211303.068123E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Vasiliy Kulikov <segoon@openwall.com>

commit c4c896e1471aec3b004a693c689f60be3b17ac86 upstream.

struct sco_conninfo has one padding byte in the end.  Local variable
cinfo of type sco_conninfo is copied to userspace with this uninizialized
one byte, leading to old stack contents leak.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/bluetooth/sco.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/net/bluetooth/sco.c
===================================================================
--- linux-2.6.35.y.orig/net/bluetooth/sco.c
+++ linux-2.6.35.y/net/bluetooth/sco.c
@@ -700,6 +700,7 @@ static int sco_sock_getsockopt_old(struc
 			break;
 		}
 
+		memset(&cinfo, 0, sizeof(cinfo));
 		cinfo.hci_handle = sco_pi(sk)->conn->hcon->handle;
 		memcpy(cinfo.dev_class, sco_pi(sk)->conn->hcon->dev_class, 3);
 
