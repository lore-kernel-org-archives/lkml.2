Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab2LSVHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 16:07:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab2LSVHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 16:07:25 -0500
Message-ID: <50D22C7F.2020201@redhat.com>
Date: Wed, 19 Dec 2012 22:07:11 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Kernel Team <kernel-team@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org, jgarzik@redhat.com,
        JBottomley@Parallels.com
Subject: [PATCH] dm-crypt: never use write same (was Re: [v3.7 Regression]
  [SCSI] sd: Implement support for WRITE SAME)
References: <50CB8C74.3090102@canonical.com> <yq11uesdzya.fsf@sermon.lab.mkp.net> <50D0C971.1000907@canonical.com> <yq1bodq7zdv.fsf@sermon.lab.mkp.net> <20121219195801.GA14456@redhat.com> <50D22766.9090107@redhat.com>
In-Reply-To: <50D22766.9090107@redhat.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does this help?

dm-crypt: never use write same

Ciphertext device is not compatible with WRITE SAME,
disable it for all dmcrypt devices.

Signed-off-by: Milan Broz <mbroz@redhat.com>

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1844,6 +1844,12 @@ static int crypt_iterate_devices(struct dm_target *ti,
 	return fn(ti, cc->dev, cc->start, ti->len, data);
 }
 
+static void crypt_io_hints(struct dm_target *ti,
+			    struct queue_limits *limits)
+{
+	limits->max_write_same_sectors = 0;
+}
+
 static struct target_type crypt_target = {
 	.name   = "crypt",
 	.version = {1, 11, 0},
@@ -1858,6 +1864,7 @@ static struct target_type crypt_target = {
 	.message = crypt_message,
 	.merge  = crypt_merge,
 	.iterate_devices = crypt_iterate_devices,
+	.io_hints = crypt_io_hints,
 };
 
 static int __init dm_crypt_init(void)

