Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab1CLN1m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 08:27:42 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59302 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab1CLN1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 08:27:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=WzczU4ZtP4G8wdy8qbZyubb22m74xqAmEHBqTX5YJgKYnfrCqCtPc4OFHw3pcRltkz
         jNq/QTBzuBA9w5VGYWT3I5o8kN4Y1N/6XlT7XcJFs2wxnmPDQFTPJuVpw5+BhNtL0JRc
         7qSneovbHPphyioHmRtAcnUo6tWvMx79vgfHs=
Message-ID: <4D7B74C7.7060506@gmail.com>
Date: Sat, 12 Mar 2011 14:27:35 +0100
From: roel <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        linux-nfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] SUNRPC: svc_register error overwritten in next iteration
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The break is in the inner loop, the svc_register() error is overwritten
in the next iteration. Only the error in the last iteration is returned.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 net/sunrpc/svc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

Is this needed?

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 08e05a8..5fd08c0 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -889,6 +889,8 @@ int svc_register(const struct svc_serv *serv, const int family,
 			if (error < 0)
 				break;
 		}
+		if (error < 0)
+			break;
 	}
 
 	return error;
