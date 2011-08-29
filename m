Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab1H2OCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:02:03 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48364 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab1H2OB5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:01:57 -0400
MIME-Version: 1.0
In-Reply-To: <4E5B65C6.6070300@samsung.com>
References: <4E5B4AAF.2040101@samsung.com>
	<CAF1ivSaveqVs8dGF+HZBytJpUpTJPysUox=qmHDTFQvqBmm+rw@mail.gmail.com>
	<4E5B65C6.6070300@samsung.com>
Date: Mon, 29 Aug 2011 23:01:55 +0900
X-Google-Sender-Auth: L4sd-WTEbfSaPLE1t-zsTQIX3Jg
Message-ID: <CAH9JG2Xfh7JcdBdaCUuD9wFyNPTXg_0JbvVZkEWK5jT2=W3ybA@mail.gmail.com>
Subject: Re: [RFC PATCH v2] support ioctl for tunable user request
From: Kyungmin Park <kmpark@infradead.org>
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Lin Ming <lxy@ss.pku.edu.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 7:11 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> Hi
>
> Lin Ming wrote:
>> On Mon, Aug 29, 2011 at 4:15 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>>> This patch is added the ioctl for tunable user request.
>>
>> Hi,
>>
>> What's the use case for this new ioctl?

The below is the just mmc example.

The main reason is that there's no way to know system or I/O idle, so
user provides the hint. Using user based I/O, device can TUNE the
device itself. In case of MMC, background operation can be used.

and another difference from other user request, it's just trigger the
device tune request, no need to wait the request is done.

Thank you,
Kyungmin Park
>>
> In my case, this ioctl is used the background operation for eMMC.
> In eMMC's case, background operation(BKOPS) is supported.
> (but that is running with only card notifier, so i added new ioctl for user request)
>
> if we send the BKOPS request, card is notified to need the BKOPS.
> then running background operation. (Then user's responsibility is done)
>
> In future, i think that other block device should be used this ioctl.
> (if supported like BKOPS)
>
> Regard,
> Jaehoon Chung
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
