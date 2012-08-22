Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab2HVFnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 01:43:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48247 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201Ab2HVFnl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 01:43:41 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Subject: RE: [PATCH 1/4] leds-lp5523: add channel name in the platform data
Thread-Topic: [PATCH 1/4] leds-lp5523: add channel name in the platform data
Thread-Index: Ac1/e8n5oMMAm/XERXqosJtmV9h97AAUPsYAABHJYrA=
Date: Wed, 22 Aug 2012 05:43:29 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF0BF4@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF0AD5@DQHE02.ent.ti.com>
 <CAK5ve-+LWG=YzEy=qWnGvqzw6+tX=7su5NH5V=5g+fjHA6gJrg@mail.gmail.com>
In-Reply-To: <CAK5ve-+LWG=YzEy=qWnGvqzw6+tX=7su5NH5V=5g+fjHA6gJrg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  LP5523 can drive up to 9 channels. Leds can be controlled directly
> via
> > -the led class control interface. Channels have generic names:
> > +the led class control interface.
> > +The name of each channel is configurable in the platform data.
> > +If the name is NULL, channels have generic names:
> >  lp5523:channelx where x is 0...8

> Why we need a test here "pdata->label ?:"? From the document, looks
> like we use lp5523:channel%d as default.

To define the channel name, we have three options.
a) using 'name' field for each channel
b) using 'label' field without 'name'
c) default : neither data is defined

So I would change the description as below.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 Documentation/leds/leds-lp5523.txt |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/Documentation/leds/leds-lp5523.txt b/Documentation/leds/leds-lp5523.txt
index fad2feb..120fdfe 100644
--- a/Documentation/leds/leds-lp5523.txt
+++ b/Documentation/leds/leds-lp5523.txt
@@ -10,8 +10,22 @@ Contact: Samu Onkalo (samu.p.onkalo-at-nokia.com)
 Description
 -----------
 LP5523 can drive up to 9 channels. Leds can be controlled directly via
-the led class control interface. Channels have generic names:
-lp5523:channelx where x is 0...8
+the led class control interface.
+The name of each channel is configurable in the platform data - name and label.
+There are three options to make the channel name.
+
+a) Define the 'name' in the platform data
+To make specific channel name, then use 'name' platform data.
+/sys/class/leds/R1               (name: 'R1')
+/sys/class/leds/B1               (name: 'B1')
+
+b) Use the 'label' with no 'name' field
+For one device name with channel number, then use 'label'.
+/sys/class/leds/RGB:channelN     (label: 'RGB', N: 0 ~ 8)
+
+c) Default
+If both fields are NULL, 'lp5523' is used by default.
+/sys/class/leds/lp5523:channelN  (N: 0 ~ 8)
 
 The chip provides 3 engines. Each engine can control channels without
 interaction from the main CPU. Details of the micro engine code can be found
-- 
1.7.2.5


Best Regards,
Milo



