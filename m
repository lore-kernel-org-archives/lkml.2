Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab2JYEcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 00:32:47 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:44466 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab2JYEcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 00:32:45 -0400
From: =?big5?B?vEK5xcJA?= <scott.liu@emc.com.tw>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
Cc: <linux-input@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "'Benjamin Tissoires'" <benjamin.tissoires@gmail.com>,
        "'Jesse'" <jesse@emc.com.tw>,
        "'Vincent Wang'" <vincent.wang@emc.com.tw>,
        "'Paul'" <paul.liang@emc.com.tw>
Subject: RE: [PATCH v2] Support Elan Touchscreen eKTF product.
Date: Thu, 25 Oct 2012 12:32:39 +0800
Message-ID: <EA73774BB37B4F518A6EA9926BB96304@elan.corp>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac2yE0VGGG6xXG/PR7WcIJ+qyjetVAARimWg
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
In-Reply-To: <20121024181323.GA18122@core.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,
	Thanks for review.

> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Thursday, October 25, 2012 2:13 AM
> To: Scott Liu
> Cc: linux-input@vger.kernel.org; linux-i2c@vger.kernel.org;
linux-kernel@vger.kernel.org;
> Benjamin Tissoires; Jesse; Vincent Wang; Paul
> Subject: Re: [PATCH v2] Support Elan Touchscreen eKTF product.
> 
> Hi Scott,
> 
> On Wed, Oct 24, 2012 at 09:41:43AM +0800, Scott Liu wrote:
> > This patch is for Elan eKTF Touchscreen product, I2C adpater module.
> >
> > Signed-off-by: Scott Liu <scott.liu@emc.com.tw>
> > ---
> >
> > Hi,
> >         v2 revision I have fixed some bug as your advise.
> >         1. To target the mainline
> >         2. No Android dependency
> >         3. reuse those duplication code from Henrik's patchset.
> >                 (input_mt_sync_frame()  / input_mt_get_slot_by_key())
> 
> Just a quick run through the code, so:
> 
> - please remove polling support, it is not useful in production;

OK.

> - why do you need a separate probe work instead of doing what you
>   need in elants_probe()

will fix.

> - it is not a good idea to register input device first and then
>   allocating memory for MT handling.

Ooop...will fix.

> - I do not understand why kfifo is needed

The firmware and the host would conflict by read command and finger report
simultaneously. So I'm simply using kfifo in IRQ thread function.

* read command: writing 4 bytes commands and the device asserts GPIO
interrupt and then response 4 bytes data.

There was an error if we do not use kfifo:
	With heavy loading by finger report / read command, the driver may
get finger report as response data.

So, do you understand my meaning? 

> - please remove the rest of the custom threads
OK

> - you do not need to call input_mt_destroy_slots() explicitly
OK
> - use request_firmware() instead of special character device to upload
>   firmware.
OK, but I'll remove firmware update function at this patch first.

> - please use standard kernel-doc markup.
> - consider what attributes are there only for debugging and move them to
>   debugfs.
OK.

> - I find the use of enums in this driver quite unconventional, just
>   standard #defines would probably be more straightforward.
OK.

Thanks,
Scott

> 
> Thanks.
> 
> --
> Dmitry

