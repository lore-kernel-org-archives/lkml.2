Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab0EaMCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 08:02:37 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:48721 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab0EaMCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 08:02:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=mF33oK8X6PZDzNRaNunAefyCDHiFQSHWN7XmtIP8jYR/qcgY+BgBTDORn4SCPiOR2W
         ww+IESbbK31RI/oHL+VF3f+7KwMh7kz6oz6ANObirR4sO/u7bxm+wKlFPuJ6FYN9qVoQ
         MNSw+Wd9mAqPlBQ3fMG0JEeqbhOptCRFj3bWA=
Date: Mon, 31 May 2010 14:02:15 +0200
From: Dan Carpenter <error27@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Todd Fischer <todd.fischer@ridgerun.com>,
       Samuel Ortiz <sameo@linux.intel.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 2/2] input/tps6507x-ts: zero vs NULL
Message-ID: <20100531120215.GS5483@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Todd Fischer <todd.fischer@ridgerun.com>,
	Samuel Ortiz <sameo@linux.intel.com>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch silences a sparse warning:

drivers/input/touchscreen/tps6507x-ts.c:345:19:
	warning: Using plain integer as NULL pointer
drivers/input/touchscreen/tps6507x-ts.c:367:19:
	warning: Using plain integer as NULL pointer

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/input/touchscreen/tps6507x-ts.c b/drivers/input/touchscreen/tps6507x-ts.c
index b99db09..1e57e4e 100644
--- a/drivers/input/touchscreen/tps6507x-ts.c
+++ b/drivers/input/touchscreen/tps6507x-ts.c
@@ -342,7 +342,7 @@ err2:
 	cancel_delayed_work(&tsc->work);
 	flush_workqueue(tsc->wq);
 	destroy_workqueue(tsc->wq);
-	tsc->wq = 0;
+	tsc->wq = NULL;
 	input_free_device(input_dev);
 err1:
 	kfree(tsc);
@@ -364,7 +364,7 @@ static int __devexit tps6507x_ts_remove(struct platform_device *pdev)
 	cancel_delayed_work(&tsc->work);
 	flush_workqueue(tsc->wq);
 	destroy_workqueue(tsc->wq);
-	tsc->wq = 0;
+	tsc->wq = NULL;
 
 	input_free_device(input_dev);
 
