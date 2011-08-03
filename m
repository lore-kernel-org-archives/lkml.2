Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab1HCXZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:25:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650Ab1HCXZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:25:02 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:45 2011
Message-Id: <20110803221245.200438611@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:00:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [011/102] Staging: hv: netvsc: Increase the timeout value in the netvsc driver
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 5c5781b3f88567211ecaaada13431af15c8c6003 upstream.

On some loaded windows hosts, we have discovered that the host may not
respond to guest requests within the specified time (one second)
as evidenced by the guest timing out. Fix this problem by increasing
the timeout to 5 seconds.

It may be useful to apply this patch to the 3.0 kernel as well.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/hv/netvsc.c       |    4 ++--
 drivers/staging/hv/rndis_filter.c |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -270,7 +270,7 @@ static int netvsc_init_recv_buf(struct h
 		goto cleanup;
 	}
 
-	t = wait_for_completion_timeout(&net_device->channel_init_wait, HZ);
+	t = wait_for_completion_timeout(&net_device->channel_init_wait, 5*HZ);
 	BUG_ON(t == 0);
 
 
@@ -513,7 +513,7 @@ static int netvsc_connect_vsp(struct hv_
 	if (ret != 0)
 		goto cleanup;
 
-	t = wait_for_completion_timeout(&net_device->channel_init_wait, HZ);
+	t = wait_for_completion_timeout(&net_device->channel_init_wait, 5*HZ);
 
 	if (t == 0) {
 		ret = -ETIMEDOUT;
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -467,7 +467,7 @@ static int rndis_filter_query_device(str
 	if (ret != 0)
 		goto Cleanup;
 
-	t = wait_for_completion_timeout(&request->wait_event, HZ);
+	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
 	if (t == 0) {
 		ret = -ETIMEDOUT;
 		goto Cleanup;
@@ -543,7 +543,7 @@ static int rndis_filter_set_packet_filte
 	if (ret != 0)
 		goto Cleanup;
 
-	t = wait_for_completion_timeout(&request->wait_event, HZ);
+	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
 
 	if (t == 0) {
 		ret = -1;
@@ -600,7 +600,7 @@ static int rndis_filter_init_device(stru
 	}
 
 
-	t = wait_for_completion_timeout(&request->wait_event, HZ);
+	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
 
 	if (t == 0) {
 		ret = -ETIMEDOUT;


