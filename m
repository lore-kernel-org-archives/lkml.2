Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab2DINPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 09:15:15 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35904 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab2DINPN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 09:15:13 -0400
MIME-Version: 1.0
In-Reply-To: <1333039766-8617-1-git-send-email-djkurtz@chromium.org>
References: <1333039766-8617-1-git-send-email-djkurtz@chromium.org>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Mon, 9 Apr 2012 21:14:52 +0800
X-Google-Sender-Auth: A-z94kC_PUx5yH6OU4DoKmq1RI0
Message-ID: <CAGS+omB=dC8u+eJo5_mKJRH6=8=6BoQJ1uctKrhso6R4S5FTEg@mail.gmail.com>
Subject: Re: [PATCH 00/16 v2] cleanup atmel_mxt_ts
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Cc: Daniel Kurtz <djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 12:49 AM, Daniel Kurtz <djkurtz@chromium.org> wrote:
> This patchset cleans up the atmel_mxt_ts touchscreen driver.
> In particular, v2 implements the following:
>
> 1) sysfs
>   a) fw_update only by root
> 2) faster initialization
>   a) read/write sets of registers using i2c block transactions
>   b) fetch object table as a set of i2c reads, one per object
>   c) write config data as a set of i2c writes, one per object
> 3) faster interrupt processing & initialization times
>   a) cache important values at init instead of computing in isr
>   b) don't read message checksum byte (which isn't even enabled in fw)
> 4) more correct MT-B support
>   a) send all (changed) contacts in a single EV_SYN/SYN_REPORT
>
> v2:
>  * Writable config via sysfs has been removed to resolve possible
>    conflict with Nick Dyer's implementation.
>  * Using T44 has been removed from this patchset, hopefully it can
>    be reexamined after most of these patches are accepted.
>
> The patches were tested using an MXT224E.

Joonyoung, Nick, Henrik,

Can you please take a look at this second version of the atmel_mxt_ts patches?
Thanks!

>
> Daniel Kurtz (16):
>  Input: atmel_mxt_ts - use CONFIG_PM_SLEEP
>  Input: atmel_mxt_ts - only allow root to update firmware
>  Input: atmel_mxt_ts - refactor mxt_read/write_reg to take a length
>  Input: atmel_mxt_ts - store actual size and instance
>  Input: atmel_mxt_ts - verify object size in mxt_write_object
>  Input: atmel_mxt_ts - do not read extra (checksum) byte
>  Input: atmel_mxt_ts - dump each message on just 1 line
>  Input: atmel_mxt_ts - refactor mxt_object_show
>  Input: atmel_mxt_ts - optimize writing of object table entries
>  Input: atmel_mxt_ts - refactor get info
>  Input: atmel_mxt_ts - refactor reading object table
>  Input: atmel_mxt_ts - simplify event reporting
>  Input: atmel_mxt_ts - cache T9 reportid range when reading object
>    table
>  Input: atmel_mxt_ts - parse vector field of data packets
>  Input: atmel_mxt_ts - send all MT-B slots in one input report
>  Input: atmel_mxt_ts - parse T6 reports
>
>  drivers/input/touchscreen/atmel_mxt_ts.c |  477 ++++++++++++------------------
>  1 files changed, 191 insertions(+), 286 deletions(-)
>
> --
> 1.7.7.3
>
