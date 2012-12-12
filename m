Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab2LLQyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 11:54:25 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:36807 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab2LLQyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 11:54:23 -0500
MIME-Version: 1.0
In-Reply-To: <20121212173444.471d5cc6@endymion.delvare>
References: <1355328736-31418-1-git-send-email-benjamin.tissoires@gmail.com>
	<20121212173444.471d5cc6@endymion.delvare>
Date: Wed, 12 Dec 2012 17:54:21 +0100
Message-ID: <CAN+gG=Fb4Y+H+rqaxquBv6OSM__Y9Z7ww+mpRZpBThwDVExDQQ@mail.gmail.com>
Subject: Re: [PATCH] HID: i2c-hid: add mutex protecting open/close race
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 5:34 PM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Benjamin,
>
> On Wed, 12 Dec 2012 17:12:16 +0100, Benjamin Tissoires wrote:
>> We should not enter close function while someone else is in open.
>> This mutex prevents this race.
>>
>> There is also no need to override the ret value with -EIO in case of
>> a failure of i2c_hid_set_power.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> ---
>
> Looks good to me except that you forgot to include <linux/mutex.h> and
> this could cause build failures on some architectures/configs.
>
> Once this is fixed, you can add:
>
> Reviewed-by: Jean Delvare <khali@linux-fr.org>

Thanks, I will resend it right now.

Cheers,
Benjamin

>
> --
> Jean Delvare
