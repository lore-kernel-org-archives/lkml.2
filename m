Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab0K2LUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 06:20:17 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:48869 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751860Ab0K2LUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 06:20:15 -0500
Message-ID: <4CF38C67.20509@euromail.se>
Date: Mon, 29 Nov 2010 12:20:07 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] input: mt: Add pressure to pointer emulation code
References: <1291014802-17061-1-git-send-email-rydberg@euromail.se> <1291014802-17061-5-git-send-email-rydberg@euromail.se> <20101129094715.GA9303@core.coreip.homeip.net>
In-Reply-To: <20101129094715.GA9303@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PN1mC-0002Cu-8q.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PN1mC-0002Cu-8q 0adc04aca0224b19df08b2997fa2a9f3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> @@ -124,9 +125,13 @@ void input_mt_report_pointer_emulation(struct input_dev
*dev)

>>  	if (oldest) {
>>  		int x = input_mt_get_value(oldest, ABS_MT_POSITION_X);
>>  		int y = input_mt_get_value(oldest, ABS_MT_POSITION_Y);
>> +		int p = input_mt_get_value(oldest, ABS_MT_PRESSURE);
> 
> What if device does not report ABS_MT_PRESSURE/ABS_PRESSURE? Do we rely
> on input core to suppress unsupported events? A comment would be nice...


Yes, the setup values are the only ones producing output here. How about this
addition to the function text: "The input core ensures only the KEY and ABS axes
already setup for this device will produce output."?

> Also, is there a gelper to set up pointer emulation capabilities for MT
> device?


This is certainly the plan with time, but currently it seemed best to leave the
rest of the event setup code untouched.

Thanks,
Henrik
