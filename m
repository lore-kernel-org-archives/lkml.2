Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab2F0JB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:01:57 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:21999 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab2F0JBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:01:55 -0400
Date: Wed, 27 Jun 2012 12:01:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch -resend] 9p: fix min_t() casting in p9pdu_vwritef()
Message-ID: <20120627090141.GF31212@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627085800.GA3007@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think we're actually likely to hit this limit but if we do
then the comparison should be done as size_t.  The original code
is equivalent to:
        len = strlen(sptr) % USHRT_MAX;

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I was told this patch "has already made it upstream via the v9fs pull."
but it must have been dropped accidentally.  Originally sent on Sat,
Jan 15, 2011.

diff --git a/net/9p/protocol.c b/net/9p/protocol.c
index 9ee48cb..3d33ecf 100644
--- a/net/9p/protocol.c
+++ b/net/9p/protocol.c
@@ -368,7 +368,7 @@ p9pdu_vwritef(struct p9_fcall *pdu, int proto_version, const char *fmt,
 				const char *sptr = va_arg(ap, const char *);
 				uint16_t len = 0;
 				if (sptr)
-					len = min_t(uint16_t, strlen(sptr),
+					len = min_t(size_t, strlen(sptr),
 								USHRT_MAX);
 
 				errcode = p9pdu_writef(pdu, proto_version,
