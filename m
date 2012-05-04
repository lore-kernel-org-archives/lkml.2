Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab2EDRj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 13:39:28 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49489 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab2EDRj0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 13:39:26 -0400
MIME-Version: 1.0
In-Reply-To: <1334755319-21365-1-git-send-email-djkurtz@chromium.org>
References: <1334755319-21365-1-git-send-email-djkurtz@chromium.org>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Sat, 5 May 2012 01:39:05 +0800
X-Google-Sender-Auth: SYv3HcKL7sAzkT-Wfs2ZcL8iwy8
Message-ID: <CAGS+omDm36Sxpv_e1=W6BNx9EoeWd1H2EaPqHAaGYYWnaZjZAw@mail.gmail.com>
Subject: Re: [PATCH 00/14 v3] cleanup atmel_mxt_ts
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 9:21 PM, Daniel Kurtz <djkurtz@chromium.org> wrote:
>
> This patchset cleans up the atmel_mxt_ts touchscreen driver.
> In particular, v3 implements the following:
>
> 1) sysfs
>   a) fw_update only by root
>   b) use sncprintf()
> 2) faster initialization
>   a) read/write sets of registers using i2c block transactions
>   b) fetch object descriptor table as a single i2c transaction
>   c) fetch objects  as a set of i2c reads, one per object
>   d) write config data as a set of i2c writes, one per object
> 3) faster interrupt processing & initialization times
>   a) cache important values at init instead of computing in isr
>   b) don't read message checksum byte (which isn't even enabled in fw)
> 4) more correct MT-B support
>   a) send all (changed) contacts in a single EV_SYN/SYN_REPORT
>
> v3:
>  * Address Henrik's feedback:
>    1) removed some more stack allocations
>    2) use sncprintf() in sysfs handler
>
>
> The patches were tested using an MXT224E.
> They should apply cleanly to input/next.
>
> Daniel Kurtz (14):
>  Input: atmel_mxt_ts - use CONFIG_PM_SLEEP
>  Input: atmel_mxt_ts - only allow root to update firmware
>  Input: atmel_mxt_ts - refactor mxt_read/write_reg to take a length
>  Input: atmel_mxt_ts - verify object size in mxt_write_object
>  Input: atmel_mxt_ts - do not read extra (checksum) byte
>  Input: atmel_mxt_ts - dump each message on just 1 line
>  Input: atmel_mxt_ts - refactor mxt_object_show
>  Input: atmel_mxt_ts - optimize writing of object table entries
>  Input: atmel_mxt_ts - refactor get info
>  Input: atmel_mxt_ts - simplify event reporting
>  Input: atmel_mxt_ts - cache T9 reportid range when reading object
>    table
>  Input: atmel_mxt_ts - parse vector field of data packets
>  Input: atmel_mxt_ts - send all MT-B slots in one input report
>  Input: atmel_mxt_ts - parse T6 reports


Thank you to Henrik for reviewing again, and ACK'ing patch 3.

Could I get a review for the rest of the set?
There will actually be quite a few more patches that follow these.

-Daniel
