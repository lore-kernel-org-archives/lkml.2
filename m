Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab1IXOGx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 10:06:53 -0400
Received: from smtp-out.google.com ([74.125.121.67]:59992 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab1IXOGv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 10:06:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=GTu4L3AvxI1Ah/2oDSOcDouhRsiOvvbvzakrJmMrxHaUmhAbrko7Lrv19TQTRhhBV
	d2ydhCSIHw8koVleUlsvQ==
MIME-Version: 1.0
In-Reply-To: <20110924083203.GZ17169@n2100.arm.linux.org.uk>
References: <1316818998-30711-1-git-send-email-sjg@chromium.org>
	<20110924083203.GZ17169@n2100.arm.linux.org.uk>
Date: Sat, 24 Sep 2011 07:06:47 -0700
X-Google-Sender-Auth: fayVSDpJgL8VxTYxiYVTUam0--o
Message-ID: <CAPnjgZ0yt2VGUHB+deb4BQ_dto8Jd+W8mxw7PjNYO9oiqEObuw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Add accurate boot timing to a Linux system
From: Simon Glass <sjg@chromium.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Sat, Sep 24, 2011 at 1:32 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Sep 23, 2011 at 04:03:15PM -0700, Simon Glass wrote:
>> An accurate timer is required to make the numbers meaningful. Many
>> modern platforms have a microsecond timer. This patch set uses a
>> function called timer_get_us() to read the timer.
>
> Not another 'get a time value' function.  Why do we need soo many?
> We have - at least:
>
> ktime_get (and various flavours of it)
> do_gettimeofday
> getnstimeofday
> sched_clock
>
> Do we really need yet another one which will have to be multiplexed
> amongst platforms, requiring scaling and so forth from whatever the
> platform provides?

No we don't need another! It is just a convenience for this RFC since
the actual timer mechanism is not clear and not important for this
RFC. Insert your favourite timer mechanism instead.

>
> Remember that ARM timers are virtually all MMIO mapped, which means
> they don't work during early kernel bringup when the MMU mappings for
> the hardware have not been setup.  (That's the reason stuff like
> sched_clock for printk doesn't work early.)  That can't be solved by
> creating yet another per-platform method to get microseconds.
>

While it would be useful to measure early things like kernel
decompression, it's hard to make that work cross-platform and there
are other problems like you raise, and where to store timing info.
>From the POV of kernel timing this RFC is about start_kernel() and
onwards. I should have been more clear in the description.

Regards,
Simon
