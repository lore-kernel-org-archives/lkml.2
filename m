Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab1I0S0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:26:18 -0400
Received: from smtp-out.google.com ([74.125.121.67]:20513 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab1I0S0R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:26:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=yVQ8RM2Uas6kuGRUe7/bAc0IYhye/sdRxu4lhS0BaPp0yOGmZBIpgyoMpF6+F/7D4
	zYcFOOGqIM3zaUZl2KPMA==
MIME-Version: 1.0
In-Reply-To: <CAErSpo63fYmQVRO2O3sB37k6rAo7Qttdh1xo=WH+QwcVb+neGg@mail.gmail.com>
References: <1316818998-30711-1-git-send-email-sjg@chromium.org>
	<CAErSpo63fYmQVRO2O3sB37k6rAo7Qttdh1xo=WH+QwcVb+neGg@mail.gmail.com>
Date: Tue, 27 Sep 2011 11:26:13 -0700
X-Google-Sender-Auth: 0LVA7tLHFp7_5JKSyZsY2CAuWgc
Message-ID: <CAPnjgZ2Z-nBg2m1P2zkda=nMAG0qCOzVtpAOSth6nwoGSUfrFQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Add accurate boot timing to a Linux system
From: Simon Glass <sjg@chromium.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On Sun, Sep 25, 2011 at 5:54 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, Sep 23, 2011 at 5:03 PM, Simon Glass <sjg@chromium.org> wrote:
>> This experimental patch set adds boot timing to a Linux system. The
>> timing starts with the boot loader and extends through the kernel into
>> user space to the completion of the boot process. The timing starts when
>> the system leaves reset, not later when the kernel starts.
>>
>> The concept is:
>> - Boot loader records a timestamp for key events during its operation
>> - These timestamps are passed to Linux, which adds more as it boots
>> - These timestamps are made available to user space, where more
>> timestamps are added as init does its job
>> - Finally the whole record is collected by a user-space script run at
>> the end of init. This is fed back through some mechanism to monitor
>> boot time in the field.
>
> I think this is a cool idea.  It's quite difficult to extract this
> sort of information today, and making it easily and consistently
> available should help focus attention and improve things.
>
> There are difficult issues about which clock to use, how to correlate
> bootloader & kernel timestamps, how to make sure the timestamps stay
> sensible even when we use hwclock, ntp, etc., but I think it's worth
> pushing on this to see how far you can go.

Yes it is not easy to get all of this right, especially trying to
cross two completely different projects. I think the timestamps should
be measured from reset. The kernel timestamps start not at zero, but
from the time the kernel starts. This guarantees a consistent time
base across the data. Also if there is a pre-boot program (such as a
NAND loader) then its time will be counted also.

A good timer would be an accurate monotonic wall clock, not
necessarily related to time of day. An ideal timer would be a
microsecond/nanosecond timer maintained by the hardware / SOC.

Regards,
Simon

>
> Bjorn
>
