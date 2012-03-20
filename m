Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760474Ab2CTOvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 10:51:50 -0400
Received: from [89.21.227.130] ([89.21.227.130]:42955 "EHLO
	mail.epsilon.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760253Ab2CTOvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 10:51:48 -0400
Message-ID: <4F689980.6030003@itdev.co.uk>
Date: Tue, 20 Mar 2012 07:51:44 -0700
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Daniel Kurtz <djkurtz@chromium.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>,
        "Bowens, Alan" <Alan.Bowens@atmel.com>,
        "Tiwari, Atul" <Atul.Tiwari@atmel.com>
Subject: Re: [PATCH 06/20] Input: atmel_mxt_ts - allow writing to object sysfs
 entry
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org> <1331640263-18935-7-git-send-email-djkurtz@chromium.org>
In-Reply-To: <1331640263-18935-7-git-send-email-djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Kurtz wrote:
> Userspace can write a 24-bit value (encoded as a 6 character hex string)
> to the 'object' sysfs entry to modify a single byte of the object table.
> The hex string encodes a 3 bytes, in the following format:
>  TTFFVV
> 
> Where:
>  TT = object type
>  FF = object offset
>  VV = byte value
> 
> The object table is modified in device ram, which means the change is
> volatile, and will be overwritten on the next device reset.  To make
> changes permanent, the new settings should be persisted in the device's
> Non-Voltatile Memory using the updatenv sysfs entry.
> 
> Also, since the device driver initializes itself by reading some values
> from the object table, the entire driver may need to be unloaded and
> reloaded after writing the values for the driver to stay in sync.  Whether
> this is required depends on exactly which values were updated.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>

NAK. I have several concerns about this:

1) The object sysfs entry doesn't follow the sysfs guidelines, this is
abusing it further.
2) Object type can be larger than 1 byte in the future.
3) Your interface restricts you to doing 1 byte writes. What about larger
block sizes?

In short, I think exposing the entire register space as a binary attribute
(the same way that regmap does) is a preferable solution to this
requirement, and we already have user space tools which use it.

cheers

-- 
Nick Dyer
Software Engineer, ITDev Ltd
Hardware and Software Development Consultancy
Website: http://www.itdev.co.uk
