Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161082Ab2JXSNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 14:13:30 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:58842 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161061Ab2JXSN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 14:13:28 -0400
Date: Wed, 24 Oct 2012 11:13:23 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Scott Liu <scott.liu@emc.com.tw>
Cc: linux-input@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jesse <jesse@emc.com.tw>, Vincent Wang <vincent.wang@emc.com.tw>,
        Paul <paul.liang@emc.com.tw>
Subject: Re: [PATCH v2] Support Elan Touchscreen eKTF product.
Message-ID: <20121024181323.GA18122@core.coreip.homeip.net>
References: <1351042903-27538-1-git-send-email-scott.liu@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351042903-27538-1-git-send-email-scott.liu@emc.com.tw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Scott,

On Wed, Oct 24, 2012 at 09:41:43AM +0800, Scott Liu wrote:
> This patch is for Elan eKTF Touchscreen product, I2C adpater module.
> 
> Signed-off-by: Scott Liu <scott.liu@emc.com.tw>
> ---
> 
> Hi,
>         v2 revision I have fixed some bug as your advise.
>         1. To target the mainline
>         2. No Android dependency
>         3. reuse those duplication code from Henrik's patchset.
>                 (input_mt_sync_frame()  / input_mt_get_slot_by_key())

Just a quick run through the code, so:

- please remove polling support, it is not useful in production;
- why do you need a separate probe work instead of doing what you
  need in elants_probe()
- it is not a good idea to register input device first and then
  allocating memory for MT handling.
- I do not understand why kfifo is needed
- please remove the rest of the custom threads
- you do not need to call input_mt_destroy_slots() explicitly
- use request_firmware() instead of special character device to upload
  firmware.
- please use standard kernel-doc markup.
- consider what attributes are there only for debugging and move them to
  debugfs.
- I find the use of enums in this driver quite unconventional, just
  standard #defines would probably be more straightforward.

Thanks.

-- 
Dmitry
