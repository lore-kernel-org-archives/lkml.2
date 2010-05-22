Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab0EVJMT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 05:12:19 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:49821 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752275Ab0EVJMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 05:12:16 -0400
Message-ID: <4BF79FBD.3020606@euromail.se>
Date: Sat, 22 May 2010 11:11:25 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Ping Cheng <pinglinux@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev3)
References: <1274457354-5570-1-git-send-email-rydberg@euromail.se>	 <AANLkTikBWzgRmso0oQNXcTxeExdKZORXYbIwK9CcMl85@mail.gmail.com>	 <4BF6B673.1080507@euromail.se>	 <20100521165218.GA26439@core.coreip.homeip.net>	 <4BF6BB43.2020405@euromail.se>	 <20100521172222.GB26439@core.coreip.homeip.net>	 <4BF6C303.7030804@euromail.se>	 <20100521174140.GA23155@core.coreip.homeip.net>	 <4BF6C7B6.2020008@euromail.se> <AANLkTikzH7IscIAYGNw00fjXSYJosaaAsbUArt9M7wfJ@mail.gmail.com>
In-Reply-To: <AANLkTikzH7IscIAYGNw00fjXSYJosaaAsbUArt9M7wfJ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OFkkE-00012W-3s.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1OFkkE-00012W-3s 70a975dcb41d20416c3543e76d372ebe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I will make another leap here, in an attempt to find a workable compromise
for the MT slots.

The issue at hand seems to be a general reluctance to move MT-related stuff
outside of the ABS_MT namespace. My objection relates to the identification of
events handled on a per-slot basis in user space. So let us treat these as
separate issues.

1. Use the name ABS_MT_SLOT

2. Move the list of slot events to input.h, like this:

diff --git a/drivers/input/input.c b/drivers/input/input.c
@@ -33,21 +33,8 @@ MODULE_LICENSE("GPL");

 #define INPUT_DEVICES	256

-/*
- * EV_ABS events which should be filtered on a per-slot basis are listed here.
- */
 static unsigned int input_mt_abs_map_init_data[] __initdata = {
-	ABS_MT_TOUCH_MAJOR,
-	ABS_MT_TOUCH_MINOR,
-	ABS_MT_WIDTH_MAJOR,
-	ABS_MT_WIDTH_MINOR,
-	ABS_MT_ORIENTATION,
-	ABS_MT_POSITION_X,
-	ABS_MT_POSITION_Y,
-	ABS_MT_TOOL_TYPE,
-	ABS_MT_BLOB_ID,
-	ABS_MT_TRACKING_ID,
-	ABS_MT_PRESSURE,
+	MT_SLOT_ABS_EVENTS
 };
 static unsigned char input_mt_abs_map[ABS_CNT];

diff --git a/include/linux/input.h b/include/linux/input.h
@@ -815,6 +815,23 @@ struct input_absinfo {
 #define MT_TOOL_PEN		1

 /*
+ * MT slot event lists
+ */
+
+#define MT_SLOT_ABS_EVENTS		\
+	ABS_MT_TOUCH_MAJOR,		\
+	ABS_MT_TOUCH_MINOR,		\
+	ABS_MT_WIDTH_MAJOR,		\
+	ABS_MT_WIDTH_MINOR,		\
+	ABS_MT_ORIENTATION,		\
+	ABS_MT_POSITION_X,		\
+	ABS_MT_POSITION_Y,		\
+	ABS_MT_TOOL_TYPE,		\
+	ABS_MT_BLOB_ID,			\
+	ABS_MT_TRACKING_ID,		\
+	ABS_MT_PRESSURE,		\
+
+/*
  * Values describing the status of a force-feedback effect
  */
 #define FF_STATUS_STOPPED	0x00


In my mind, this resolves the outstanding issues, including providing a way for
userspace to enumerate the MT events. Comments are highly appreciated.

Henrik

