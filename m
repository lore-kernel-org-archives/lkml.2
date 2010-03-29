Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab0C2TVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 15:21:01 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:41829 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab0C2TU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 15:20:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=oebbk0vLAVkG7yrRAyrBWwJY4qzkXdeOq1HGJcLep4YXBjQnwFJLb+CXcft5dZYfTm
         p5lRkJHVTOXQtAucq8nYzWMyHk0hbZEzw74+3O1WPa3VDQqkHCkbmBxqL3t5WEX0F7Kv
         iv8erMVrP8eG8gxCTnrTeB9DWsdeisVmeunfs=
Message-ID: <4BB0FD96.5020402@lwfinger.net>
Date: Mon, 29 Mar 2010 14:20:54 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ren=E9=5FBolldorf?= <xsecute@googlemail.com>
CC: John Linville <linville@tuxdriver.com>,
       LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] No SPROM available!
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

René,

When you have a wireless problem, please post it to
linux-wireless@vger.kernel.org. The Linux Kernel Mailing List may or may not be
appropriate.

To help in diagnosing your problem, please apply this patch and post the output
line that it produces. On my system, it shows

ssb: chip_id 0x4312, status 0x10

Please also post the output of 'lspci -nnv | grep 14e4'.

Index: wireless-testing/drivers/ssb/sprom.c
===================================================================
--- wireless-testing.orig/drivers/ssb/sprom.c
+++ wireless-testing/drivers/ssb/sprom.c
@@ -182,6 +182,8 @@ bool ssb_is_sprom_available(struct ssb_b
 	if (bus->chipco.dev->id.revision < 11)
 		return true;

+	printk(KERN_INFO "ssb: chip_id 0x%x, status 0x%x\n", bus->chip_id,
+			  bus->chipco.status);
 	switch (bus->chip_id) {
 	case 0x4312:
 		return SSB_CHIPCO_CHST_4312_SPROM_PRESENT(bus->chipco.status);


Larry


