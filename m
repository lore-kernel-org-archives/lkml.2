Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab2FSK0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 06:26:10 -0400
Received: from [89.21.227.130] ([89.21.227.130]:52692 "EHLO
	mail.epsilon.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751768Ab2FSK0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 06:26:07 -0400
Message-ID: <4FE053BD.2090605@itdev.co.uk>
Date: Tue, 19 Jun 2012 11:26:05 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yufeng Shen <miletus@google.com>
CC: Daniel Kurtz <djkurtz@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, linux-input@vger.kernel.org,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org,
        "Bowens, Alan" <Alan.Bowens@atmel.com>
Subject: Re: [PATCH 14/22 v4] Input: atmel_mxt_ts - don't re-read matrix after
 applying pdata
References: <1339992522-22073-1-git-send-email-djkurtz@chromium.org> <1339992522-22073-15-git-send-email-djkurtz@chromium.org> <4FDF4345.40508@itdev.co.uk> <CAPDwgkMATDg5_FyJhR2aDCOzHu9DQbxzPHMn7MCC8KmBsS2bhg@mail.gmail.com>
In-Reply-To: <CAPDwgkMATDg5_FyJhR2aDCOzHu9DQbxzPHMn7MCC8KmBsS2bhg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yufeng Shen wrote:
> On Mon, Jun 18, 2012 at 11:03 AM, Nick Dyer <nick.dyer@itdev.co.uk> wrote:
>> Daniel Kurtz wrote:
>>> The matrix x/y size in the Info ID Block represents the number of x/y
>>> trace lines on the device.  There is no need to re-read them after
>>> applying pdata config, since pdata only configures the object table
>>> etnries.  The matrix size read from the ID can only be updated by a
>>> firmware update.
>>
>> This isn't correct. For example, mXT224 can be configured as 16x14, 17x13,
>> 18x12, etc. This only takes effect when the chip is reset, which is why it
>> is necessary to re-read them after applying the config.
> 
> so look at structure mxt_info
> 
>  struct mxt_info {
>           u8 family_id;
>           u8 variant_id;
>           u8 version;
>           u8 build;
>           u8 matrix_xsize;
>           u8 matrix_ysize;
>           u8 object_num;
> };
> 
> I think it is meant to be corresponding to Information Block of the
> device, of which
> the matrix_xsize and matrix_ysize mean "The size of the matrix the
> device supports",
> which should be fixed for a certain chip.

As I said, it's not fixed, there is a mode setting (T28 byte 2) which
alters the matrix size. This is documented in the protocol guide, if you
have it.

You can also verify this if you want: change mode setting, backup, reset,
and read the information block, you'll see the matrix size changes. I've
just checked that myself on an mXT224.

I also asked the guys at Atmel that I work with, and they confirm that this
behaviour is as designed.

> The configurable matrix size is in T9 XSIZE/YSIZE, which, if ever
> needed to be read back,
> probably read back into something other than mxt_info struct.

The position of the touchscreen within the matrix is a separate
configurable setting, you're confusing the two.

cheers

-- 
Nick Dyer
Software Engineer, ITDev Ltd
Hardware and Software Development Consultancy
Website: http://www.itdev.co.uk
