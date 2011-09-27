Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab1I0S3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:29:13 -0400
Received: from smtp-out.google.com ([216.239.44.51]:60458 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab1I0S3K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:29:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=OlfqRrirytXvehsyloVEw6XuQRmyA4Dmn17j/Ql6PPWAkzYwQ+sfQ5F/ZuEgOWDjh
	JyPiUKUPO1AJb1XUq7fGQ==
MIME-Version: 1.0
In-Reply-To: <4E802F7D.9000006@parrot.com>
References: <1316818998-30711-1-git-send-email-sjg@chromium.org>
	<20110924083203.GZ17169@n2100.arm.linux.org.uk>
	<4E802F7D.9000006@parrot.com>
Date: Tue, 27 Sep 2011 11:29:07 -0700
X-Google-Sender-Auth: d1PafaMJCyYS643YPVy1ty_DK2M
Message-ID: <CAPnjgZ11uannvUOGSM_FuR9mhSY_yiSGv3vuJtmsMFMgV+Jo0Q@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Add accurate boot timing to a Linux system
From: Simon Glass <sjg@chromium.org>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthieu,

On Mon, Sep 26, 2011 at 12:53 AM, Matthieu CASTET
<matthieu.castet@parrot.com> wrote:
> Hi,
>
> Russell King - ARM Linux a écrit :
>> On Fri, Sep 23, 2011 at 04:03:15PM -0700, Simon Glass wrote:
>>> An accurate timer is required to make the numbers meaningful. Many
>>> modern platforms have a microsecond timer. This patch set uses a
>>> function called timer_get_us() to read the timer.
>>
>> Not another 'get a time value' function.  Why do we need soo many?
>> We have - at least:
>>
>> ktime_get (and various flavours of it)
>> do_gettimeofday
>> getnstimeofday
>> sched_clock
>>
>> Do we really need yet another one which will have to be multiplexed
>> amongst platforms, requiring scaling and so forth from whatever the
>> platform provides?
>>
>> Remember that ARM timers are virtually all MMIO mapped, which means
>> they don't work during early kernel bringup when the MMU mappings for
>> the hardware have not been setup.  (That's the reason stuff like
>> sched_clock for printk doesn't work early.)
> Doesn't cortexA-8 (and A9 ?) have a cycle counter that can be read by
> coprocessor 15 ?
>
> Couldn't we use that counter for early stuff on those architectures ?

Yes we could, but we need to be careful that we use a 'time of day'
counter, not dependent on clock speed, CPU load and the like. See my
other email for what I see as the ideal timer. Obviously this will
have to be architecture-specific, but I hope for a simple fallback to
something available on all architectures, with perhaps the ability to
use better timers available on specific architectures which implement
them.

Regards,
Simon

>
>
> Matthieu
>
