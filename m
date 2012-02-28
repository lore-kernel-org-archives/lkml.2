Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab2B1JOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 04:14:10 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36730 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab2B1JOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 04:14:07 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of joshuacov@googlemail.com designates 10.236.175.36 as permitted sender) smtp.mail=joshuacov@googlemail.com; dkim=pass header.i=joshuacov@googlemail.com
MIME-Version: 1.0
In-Reply-To: <4F4C1F76.70403@zytor.com>
References: <CAKL7Q7qU0OKzqC-XnM1mY7YWs1SstayqH-8P-5MY3Yg7_wrQZw@mail.gmail.com>
	<4F4BF11E.4090000@zytor.com>
	<CAKL7Q7pK_jacfk9shdNootT46AihgABZkN54sbP-SnhA6-1F8Q@mail.gmail.com>
	<4F4C1F76.70403@zytor.com>
Date: Tue, 28 Feb 2012 10:14:07 +0100
Message-ID: <CAKL7Q7q8oRRQH4bh3JDpB_pGcKTJkOwzhKmOmAtk6sode8kU=g@mail.gmail.com>
Subject: Re: [RESUBMIT] [PATCH] Use BIOS Keyboard variable to set Numlock
From: "Joshua C." <joshuacov@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Bodo Eggert <7eggert@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/28 H. Peter Anvin <hpa@zytor.com>:
> On 02/27/2012 04:08 PM, Joshua C. wrote:
>>
>> If so I'm not sure about it. We check the BIOS data area as defined
>> for IBM PCs (1981), so a fair amount of user should benefit from the
>> change. Those non-BIOS boots can set the numlock=0 and won't be
>> affected by this. I think this isa lot easier to implement than doing
>> it in the BIOS bootstrap code.
>>
>
> Here is a patch to query the BIOS state properly; if you could fill out
> the rest of the patch then we can merge this in easily enough.
>
>        -hpa

I think this should be the missing part:

@@ -1432,7 +1439,17 @@ int __init kbd_init(void)
 {
 	int i;
 	int error;
-
+	
+#ifdef CONFIG_KBD_DEFLEDS_PCBIOS
+	int KBD_DEFLEDS = 0;
+	char * bios_kbd_lock_status=boot_params.kbd_status
+	
+	/* Numlock status bit set? */
+	if ((*bios_kbd_lock_status & 0x20) && numlock)
+	KBD_DEFLEDS = 1 << VC_NUMLOCK;
+#endif
+	
         for (i = 0; i < MAX_NR_CONSOLES; i++) {
 		kbd_table[i].ledflagstate = KBD_DEFLEDS;
 		kbd_table[i].default_ledflagstate = KBD_DEFLEDS;
