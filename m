Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394Ab1JRMH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 08:07:56 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40969 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332Ab1JRMHw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 08:07:52 -0400
MIME-Version: 1.0
In-Reply-To: <4E9D3A0D.9070108@cam.ac.uk>
References: <1318926486-10330-1-git-send-email-ricardo.ribalda@gmail.com>
 <1318926486-10330-3-git-send-email-ricardo.ribalda@gmail.com> <4E9D3A0D.9070108@cam.ac.uk>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 18 Oct 2011 14:07:11 +0200
Message-ID: <CAPybu_0hXDjKnmQF6OtoeC=mmqfNRK6pVSf4ZA+2Jn9BHFWV2Q@mail.gmail.com>
Subject: Re: [PATCH 2/5] input/cma3000_d0x: Check silicon version
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: dmitry.torokhov@gmail.com, sameo@linux.intel.com, peter.ujfalusi@ti.com,
        aghayal@codeaurora.org, david@hardeman.nu, Shubhrajyoti@ti.com,
        saaguirre@ti.com, hemanthv@ti.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jonathan

>> +     if (rev != CMA3000_REV) {
>> +             error = -EINVAL;
>> +             pr_err("CMA3000 Accelerometer: Unknown Revision %x\n", rev);
> warning perhaps rather than error?

IMHO it should be an error. If the revision is different, either you
are in front of a unknown chip or the chip is going to behave
differently and lead into an unstable system. Better be safe than
sorry.

> Patch could do with a statement of why anyone would care about this.
>>       error = request_threaded_irq(irq, NULL, cma3000_thread_irq,
>>                                    pdata->irqflags | IRQF_ONESHOT,
>>                                    "cma3000_d0x", data);

You are right... not so useful information :). Maybe as part of a
sysfs file, but definately not as as a printk

>
>



-- 
Ricardo Ribalda
