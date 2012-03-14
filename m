Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030585Ab2CNCnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:43:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31292 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030422Ab2CNCnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:43:19 -0400
X-AuditID: cbfee61b-b7c62ae000000989-30-4f6005c5c5eb
Message-id: <4F6005DD.3080702@samsung.com>
Date: Wed, 14 Mar 2012 11:43:41 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 00/20] cleanup atmel_mxt_ts
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
In-reply-to: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 09:04 PM, Daniel Kurtz wrote:
> This patchset cleans up the atmel_mxt_ts touchscreen driver.
> In particular, it addresses the following issues:
>
> 1) sysfs
>     a) fw_update only by root
>     b) allow writing config
>     c) add backupnv to save config to device flash
> 2) faster initialization
>     a) read/write sets of registers using i2c block transactions
>     b) fetch object table as a set of i2c reads, one per object
>     c) write config data as a set of i2c writes, one per object
> 3) faster interrupt processing&  initialization times
>     a) cache important values at init instead of computing in isr
>     b) don't read message checksum byte (which isn't even enabled in fw)
>     c) read num messages first, instead of looking for 0xFF reportid
>     d) read all pending message bytes in one i2c read transaction
> 4) more correct MT-B support
>     a) send all (changed) contacts in a single EV_SYN/SYN_REPORT
>
> Daniel Kurtz (20):
>    Input: atmel_mxt_ts - use CONFIG_PM_SLEEP
>    Input: atmel_mxt_ts - only allow root to update firmware
>    Input: atmel_mxt_ts - verify object size in mxt_write_object
>    Input: atmel_mxt_ts - refactor mxt_read/write_reg to take a length
>    Input: atmel_mxt_ts - dump mxt_read/write_reg
>    Input: atmel_mxt_ts - allow writing to object sysfs entry
>    Input: atmel_mxt_ts - add backupnv sysfs entry
>    Input: atmel_mxt_ts - store actual size and instance
>    Input: atmel_mxt_ts - do not read extra (checksum) byte
>    Input: atmel_mxt_ts - dump each message on just 1 line
>    Input: atmel_mxt_ts - refactor mxt_object_show
>    Input: atmel_mxt_ts - simplify event reporting
>    Input: atmel_mxt_ts - parse vector field of data packets
>    Input: atmel_mxt_ts - refactor reading object table
>    Input: atmel_mxt_ts - optimize writing of object table entries
>    Input: atmel_mxt_ts - refactor get info
>    Input: atmel_mxt_ts - use cached T9 reportid range in isr
>    Input: atmel_mxt_ts - read num messages, then all messages
>    Input: atmel_mxt_ts - remove mxt_make_highchg and parse T6 report
>    Input: atmel_mxt_ts - send all MT-B slots in one input report
>
>   drivers/input/touchscreen/atmel_mxt_ts.c |  590 +++++++++++++++---------------
>   1 files changed, 286 insertions(+), 304 deletions(-)
>

Thanks for updating of driver.

About all patches
Reviewed-by: Joonyoung Shim <jy0922.shim@samsung.com>

Henrik's review needs about modification of Multi-touch.

Thanks.
