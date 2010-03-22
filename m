Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab0CVP6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 11:58:09 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:40133 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab0CVP6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 11:58:06 -0400
Message-ID: <4BA792F7.8010801@oracle.com>
Date: Mon, 22 Mar 2010 08:55:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH -next] sound: fix usb build error when PM is not enabled
References: <20100322171937.d753bdba.sfr@canb.auug.org.au>
In-Reply-To: <20100322171937.d753bdba.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4BA79350.00B8:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors when CONFIG_PM is not enabled:

sound/usb/card.c:629: error: 'usb_audio_suspend' undeclared here (not in a function)
sound/usb/card.c:630: error: 'usb_audio_resume' undeclared here (not in a function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 sound/usb/card.c |    3 +++
 1 file changed, 3 insertions(+)

--- linux-next-20100322.orig/sound/usb/card.c
+++ linux-next-20100322/sound/usb/card.c
@@ -606,6 +606,9 @@ static int usb_audio_resume(struct usb_i
 
 	return 0;
 }
+#else
+#define usb_audio_suspend	NULL
+#define usb_audio_resume	NULL
 #endif		/* CONFIG_PM */
 
 static struct usb_device_id usb_audio_ids [] = {
