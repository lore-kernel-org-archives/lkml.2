Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab2K1Cw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 21:52:59 -0500
Received: from us-mx3.synaptics.com ([12.239.217.85]:42494 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab2K1Cw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 21:52:57 -0500
Message-ID: <50B57C86.6090108@synaptics.com>
Date: Tue, 27 Nov 2012 18:52:54 -0800
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: Re: [RFC PATCH 05/06] input/rmi4: F01 - device control
References: <1353124734-16803-1-git-send-email-cheiny@synaptics.com> <1353124734-16803-6-git-send-email-cheiny@synaptics.com> <20121126094018.GC13792@core.coreip.homeip.net> <50B3EDBF.3030209@synaptics.com> <20121127092913.GC25658@core.coreip.homeip.net>
In-Reply-To: <20121127092913.GC25658@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 01:29 AM, Dmitry Torokhov wrote:
> On Mon, Nov 26, 2012 at 02:31:27PM -0800, Christopher Heiny wrote:
>> >On 11/26/2012 01:40 AM, Dmitry Torokhov wrote:
>>> > >Hi Christopher,
>>> > >
>>> > >On Fri, Nov 16, 2012 at 07:58:53PM -0800, Christopher Heiny wrote:
>>>> > >>RMI Function 01 implements basic device control and power management
>>>> > >>behaviors for the RMI4 sensor.
>>>> > >>
>>>> > >>rmi_f01.h exports definitions that we expect to be used by other functionality
>>>> > >>in the future (such as firmware reflash).
>>> > >
>>> > >Please see my comments below.
>> >
>> >Hi Dmitry,
>> >
>> >Thanks for the feedback and the patch.  I've got just one question,
>> >included below, with a bunch of snipping).
>> >
>> >				Chris
>> >
>>> > >
>>>> > >>
>>>> > >>
>>>> > >>Signed-off-by: Christopher Heiny<cheiny@synaptics.com>
>>>> > >>
>>>> > >>Cc: Dmitry Torokhov<dmitry.torokhov@gmail.com>
>>>> > >>Cc: Linus Walleij<linus.walleij@stericsson.com>
>>>> > >>Cc: Naveen Kumar Gaddipati<naveen.gaddipati@stericsson.com>
>>>> > >>Cc: Joeri de Gram<j.de.gram@gmail.com>
>>>> > >>
>>>> > >>
>>>> > >>---
>>>> > >>
>>>> > >>  drivers/input/rmi4/rmi_f01.c | 1348 ++++++++++++++++++++++++++++++++++++++++++
>>>> > >>  drivers/input/rmi4/rmi_f01.h |  160 +++++
>>>> > >>  2 files changed, 1508 insertions(+), 0 deletions(-)
>>>> > >>
>>>> > >>diff --git a/drivers/input/rmi4/rmi_f01.c b/drivers/input/rmi4/rmi_f01.c
>>>> > >>new file mode 100644
>>>> > >>index 0000000..038266c
>>>> > >>--- /dev/null
>>>> > >>+++ b/drivers/input/rmi4/rmi_f01.c
>>>> > >>@@ -0,0 +1,1348 @@
>>>> > >>+/*
>>>> > >>+ * Copyright (c) 2011-2012 Synaptics Incorporated
>>>> > >>+ * Copyright (c) 2011 Unixphere
>>>> > >>+ *
>>>> > >>+ * This program is free software; you can redistribute it and/or modify
>>>> > >>+ * it under the terms of the GNU General Public License as published by
>>>> > >>+ * the Free Software Foundation; either version 2 of the License, or
>>>> > >>+ * (at your option) any later version.
>> >
>> >[snip]
>> >
>>>> > >>+/**
>>>> > >>+ * @reset - set this bit to force a firmware reset of the sensor.
>>>> > >>+ */
>>>> > >>+struct f01_device_commands {
>>>> > >>+	bool reset:1;
>>>> > >>+	u8 reserved:7;
>>> > >
>>> > >When specifying bitwise fields please use u8, u16, etc only.
>> >
>> >Um, OK.  Previously patch feedback suggested to use bool instead of
>> >u8 for single bit fields (see here:
>> >http://www.spinics.net/lists/linux-input/msg22198.html).  So I'm a
>> >little confused.  It's no big deal to change it back, but I'd like
>> >confirmation that it is really what we should do.
 >
> I believe that it is better to specify exact bitness of the base type of
> the bitfield so you do not surprised by the alignment.

OK, thanks!
