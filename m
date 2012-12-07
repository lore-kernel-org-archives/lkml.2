Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab2LGPNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 10:13:33 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50199 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab2LGPNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 10:13:31 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1212061101100.28002@pobox.suse.cz>
References: <1354716176-12558-1-git-send-email-benjamin.tissoires@gmail.com>
	<1354716176-12558-5-git-send-email-benjamin.tissoires@gmail.com>
	<20121205205926.143070ef@endymion.delvare>
	<alpine.LNX.2.00.1212061101100.28002@pobox.suse.cz>
Date: Fri, 7 Dec 2012 16:13:29 +0100
Message-ID: <CAN+gG=EWdZcTFNJxhcCB8Lw+mLAgb5NNV6eCb9RpWf+nt+ebzw@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] HID: i2c-hid: fix i2c_hid_get_raw_report count mismatches
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jean Delvare <khali@linux-fr.org>, linux-input@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 6, 2012 at 11:01 AM, Jiri Kosina <jkosina@suse.cz> wrote:
>> > -   count = ihid->inbuf[0] | (ihid->inbuf[1] << 8);
>> > +   ret_count = ihid->inbuf[0] | (ihid->inbuf[1] << 8);
>> >
>> > +   if (!ret_count)
>>
>> I'd make this (ret_count <= 2), as this would let you call memcpy with a
>> null or even negative length.
>
> Good catch, it doesn't account for the 2 bytes needed for storing the
> reply size.
>
> I have fixed that and applied the patch, thanks everybody!
>

Hi Jiri, Jean,

thank you very much for the work done. I was in a meeting past two
days, so I was not able to answer sooner.

Cheers,
Benjamin
