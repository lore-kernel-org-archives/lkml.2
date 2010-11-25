Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab0KYQLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 11:11:10 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57580 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab0KYQLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 11:11:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=IlbKZrVR4wZ8+uVU+gkFSMYmPmp36wf9dFl3cuhAF4c/kg02VxDikQ4hr/365QLbil
         BZABE0u7TfrH+pbo6lN1W4G3ib4gykmewbAuSwDshQzs/PQOLbXP2bARz3Wez7X+T9iM
         +fnXOfhvOWXWUkLVj9/p0baAo+IrQk64t3wb4=
Message-ID: <4CEE8A99.5020906@gmail.com>
Date: Fri, 26 Nov 2010 01:11:05 +0900
From: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; ja-JP-mac; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, gregkh@suse.de
CC: arnd@arndb.de
Subject: [RESEND][BUG][PATCH]-rc: USB: yurex: add .llseek fop to file_operations
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg-KH,
Sorry for resending this; To: was not enough.

https://bugzilla.kernel.org/show_bug.cgi?id=23512

Default llseek operation behavior was changed by the patch named
"vfs: make no_llseek the default" after the yurex driver was merged,
so the llseek to yurex is now ignored.

This patch add llseek fop with default_llseek to yurex driver
to catch up to the change.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>

 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
index 719c618..ac5bfd6 100644
--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -536,6 +536,7 @@ static const struct file_operations yurex_fops = {
 	.open =		yurex_open,
 	.release =	yurex_release,
 	.fasync	=	yurex_fasync,
+	.llseek =	default_llseek,
 };


-- 
1.7.0

