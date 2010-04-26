Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab0DZIxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 04:53:51 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:28517 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab0DZIxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 04:53:49 -0400
X-IronPort-AV: E=Sophos;i="4.52,272,1270440000"; 
   d="scan'208";a="15856955"
From: <michael.hennerich@analog.com>
To: gregkh@suse.de
CC: jic23@cam.ac.uk, uclinux-dist-devel@blackfin.uclinux.org,
       linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
       Michael Hennerich <Michael.Hennerich@analog.com>
Subject: [PATCH] iio_trigger_find_by_name: Skip trailing newline if available
Date: Mon, 26 Apr 2010 10:49:10 +0200
Message-ID: <1272271750-6182-1-git-send-email-michael.hennerich@analog.com>
X-Mailer: git-send-email 1.6.0.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Skip trailing newline if available.

Signed-off-by: Michael Hennerich <Michael.Hennerich@analog.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

 drivers/staging/iio/industrialio-trigger.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/iio/industrialio-trigger.c b/drivers/staging/iio/industrialio-trigger.c
index 693ebc4..5f76fc1 100644
--- a/drivers/staging/iio/industrialio-trigger.c
+++ b/drivers/staging/iio/industrialio-trigger.c
@@ -155,6 +155,9 @@ struct iio_trigger *iio_trigger_find_by_name(const char *name, size_t len)
 	struct iio_trigger *trig;
 	bool found = false;
 
+	if (len && name[len - 1] == '\n')
+		len--;
+
 	mutex_lock(&iio_trigger_list_lock);
 	list_for_each_entry(trig, &iio_trigger_list, list) {
 		if (strncmp(trig->name, name, len) == 0) {
