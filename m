Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab1HCXof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:44:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33413 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755966Ab1HCX0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:26:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:45 2011
Message-Id: <20110803221244.994023887@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:00:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [009/102] Staging: hv: storvsc: Increase the timeout value in the storvsc driver
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 46d2eb6d82ef44be58ae192c35e8cd52485f02eb upstream.

On some loaded windows hosts, we have discovered that the host may not
respond to guest requests within the specified time (one second)
as evidenced by the guest timing out. Fix this problem by increasing
the timeout to 5 seconds.

It may be useful to apply this patch to the 3.0 kernel as well.
the 3.0 kernel as well.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/hv/storvsc.c     |    8 ++++----
 drivers/staging/hv/storvsc_drv.c |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -135,7 +135,7 @@ static int storvsc_channel_init(struct h
 	if (ret != 0)
 		goto cleanup;
 
-	t = wait_for_completion_timeout(&request->wait_event, HZ);
+	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
 	if (t == 0) {
 		ret = -ETIMEDOUT;
 		goto cleanup;
@@ -163,7 +163,7 @@ static int storvsc_channel_init(struct h
 	if (ret != 0)
 		goto cleanup;
 
-	t = wait_for_completion_timeout(&request->wait_event, HZ);
+	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
 	if (t == 0) {
 		ret = -ETIMEDOUT;
 		goto cleanup;
@@ -192,7 +192,7 @@ static int storvsc_channel_init(struct h
 	if (ret != 0)
 		goto cleanup;
 
-	t = wait_for_completion_timeout(&request->wait_event, HZ);
+	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
 	if (t == 0) {
 		ret = -ETIMEDOUT;
 		goto cleanup;
@@ -222,7 +222,7 @@ static int storvsc_channel_init(struct h
 	if (ret != 0)
 		goto cleanup;
 
-	t = wait_for_completion_timeout(&request->wait_event, HZ);
+	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
 	if (t == 0) {
 		ret = -ETIMEDOUT;
 		goto cleanup;
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -393,7 +393,7 @@ static int storvsc_host_reset(struct hv_
 	if (ret != 0)
 		goto cleanup;
 
-	t = wait_for_completion_timeout(&request->wait_event, HZ);
+	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
 	if (t == 0) {
 		ret = -ETIMEDOUT;
 		goto cleanup;


