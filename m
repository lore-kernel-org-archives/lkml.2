Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab0E0PJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:09:18 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:45767 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab0E0PJP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:09:15 -0400
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 May 2010 11:09:14 EDT
Date: Thu, 27 May 2010 17:02:51 +0200
From: Bastian Blank <waldi@debian.org>
To: xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Fix name of Xen event-channel device
Message-ID: <20100527150251.GD6040@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	xen-devel@lists.xensource.com,
	Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
References: <20100526105144.GA28280@wavehammer.waldi.eu.org> <20100527073512.GA17135@wavehammer.waldi.eu.org> <20100527143104.GB6040@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20100527143104.GB6040@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Xen event-channel device is named evtchn in the kernel but always
used as /dev/xen/evtchn in userspace. This patch fixes the name.

Signed-off-by: Bastian Blank <waldi@debian.org>

diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
index 66e185c..89cd743 100644
--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -471,7 +471,7 @@ static const struct file_operations evtchn_fops = {
 
 static struct miscdevice evtchn_miscdev = {
 	.minor        = MISC_DYNAMIC_MINOR,
-	.name         = "evtchn",
+	.name         = "xen/evtchn",
 	.fops         = &evtchn_fops,
 };
 static int __init evtchn_init(void)
-- 
Yes, it is written.  Good shall always destroy evil.
		-- Sirah the Yang, "The Omega Glory", stardate unknown
