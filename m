Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab2DRPSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 11:18:18 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:33995 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab2DRPSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 11:18:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=dreamhost.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=dreamhost.com;
	 b=NluWsM3ipbCZxlXP0CsSk+HC82R3ojKoImgCRKBcJF9MX51zolfiZKJ+LsnHR
	9rqwmWLor8UC7Bf1jS4A5KgtBoiata/TO7ifvDuef3upX6shmWEZoTSiBQJihuD7
	dZXjtTiyTA8k0BsuPCiCTTbpeIgq7LSIqiTvXYH5Oe8YvQ=
Message-ID: <4F8EDB37.5000900@dreamhost.com>
Date: Wed, 18 Apr 2012 10:18:15 -0500
From: Alex Elder <elder@dreamhost.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: ceph-devel@vger.kernel.org
CC: Al Viro <viro@ZenIV.linux.org.uk>, Sage Weil <sage@newdream.net>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] ceph: osd_client: fix endianness bug in osd_req_encode_op()
References: <4F8ED911.90309@dreamhost.com>
In-Reply-To: <4F8ED911.90309@dreamhost.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From Al Viro <viro@zeniv.linux.org.uk>

Al Viro noticed that we were using a non-cpu-encoded value in
a switch statement in osd_req_encode_op().  The result would
clearly not work correctly on a big-endian machine.

Signed-off-by: Alex Elder <elder@dreamhost.com>

---
  net/ceph/osd_client.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/net/ceph/osd_client.c
===================================================================
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -278,7 +278,7 @@ static void osd_req_encode_op(struct cep
  {
  	dst->op = cpu_to_le16(src->op);

-	switch (dst->op) {
+	switch (src->op) {
  	case CEPH_OSD_OP_READ:
  	case CEPH_OSD_OP_WRITE:
  		dst->extent.offset =
