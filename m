Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965340Ab0COQRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 12:17:08 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56827 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965297Ab0COQRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 12:17:04 -0400
Message-ID: <4B9E5D79.6070203@canonical.com>
Date: Mon, 15 Mar 2010 17:16:57 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Lars-Peter Clausen <lars@metafoo.de>, linux-mmc@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [patch 109/123] s3cmci: initialize default platform
 data no_wprotect and no_detect with 1
References: <20100313001514.672290530@kvm.kroah.org>
In-Reply-To: <20100313001514.672290530@kvm.kroah.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------010502050404090607040400"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010502050404090607040400
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch does not seem to be applied to 2.6.32.y while the one

[patch 108/123] s3cmci: s3cmci_card_present: Use no_detect to decide whether
there is a card detect pin

is. I checked and the only problem that makes it fail is the uncorrected comment
above (revised patch attached)

Stefan

--------------010502050404090607040400
Content-Type: text/x-diff;
 name="0001-s3cmci-initialize-default-platform-data-no_wprotect-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-s3cmci-initialize-default-platform-data-no_wprotect-.pa";
 filename*1="tch"

>From e1dcbab5755d0ffa32f8f6cbeb562c769872bd7c Mon Sep 17 00:00:00 2001
From: Lars-Peter Clausen <lars@metafoo.de>
Date: Fri, 5 Mar 2010 13:43:35 -0800
Subject: [PATCH] s3cmci: initialize default platform data no_wprotect and no_detect with 1

commit c212808a1ba6bfba489006399b8152a047305acf upstream.

If no platform_data was givin to the device it's going to use it's default
platform data struct which has all fields initialized to zero.  As a
result the driver is going to try to request gpio0 both as write protect
and card detect pin.  Which of course will fail and makes the driver
unusable

Previously to the introduction of no_wprotect and no_detect the behavior
was to assume that if no platform data was given there is no write protect
or card detect pin.  This patch restores that behavior.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/mmc/host/s3cmci.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/s3cmci.c b/drivers/mmc/host/s3cmci.c
index f31f05a..fba147c 100644
--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -1361,6 +1361,8 @@ static struct mmc_host_ops s3cmci_ops = {
 static struct s3c24xx_mci_pdata s3cmci_def_pdata = {
 	/* This is currently here to avoid a number of if (host->pdata)
 	 * checks. Any zero fields to ensure reaonable defaults are picked. */
+	.no_wprotect = 1,
+	.no_detect = 1,
 };
 
 #ifdef CONFIG_CPU_FREQ
-- 
1.6.3.3


--------------010502050404090607040400--
