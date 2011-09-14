Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab1INBRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 21:17:06 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39974 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab1INBRE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 21:17:04 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1109111636410.21533-100000@netrider.rowland.org>
References: <1315665442-4194-2-git-send-email-tom.leiming@gmail.com>
	<Pine.LNX.4.44L0.1109111636410.21533-100000@netrider.rowland.org>
Date: Wed, 14 Sep 2011 09:17:03 +0800
Message-ID: <CACVXFVOfXBT9jPRq=WwasN0rNeaZ_T3ceZ1hsnP_QYdXHh+nDQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] PM/runtime: handle ->runtime_suspend failure correctly
From: Ming Lei <tom.leiming@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 12, 2011 at 4:44 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sat, 10 Sep 2011 tom.leiming@gmail.com wrote:
>
>> From: Ming Lei <tom.leiming@gmail.com>
>>
>> If ->runtime_suspend returns -EAGAIN or -EBUSY, the device should
>> still be in ACTIVE state, so it is not needed to handle defered
>> resume and idle notification to its parent; if ->runtime_suspend
>> returns other fatal failure, it doesn't make sense to process defered
>> resume and send idle notification to its parent.
>
>> @@ -422,6 +425,9 @@ static int rpm_suspend(struct device *dev, int rpmflags)
>>       }
>>       wake_up_all(&dev->power.wait_queue);
>>
>> +     if (retval)
>> +             goto out;
>> +
>>       if (dev->power.deferred_resume) {
>>               rpm_resume(dev, 0);
>>               retval = -EAGAIN;
>
> If there's a suspend failure, the deferred_resume flag gets turned off
> anyway.  But skipping this test won't hurt, and skipping the parent
> notification is a good idea.

Yes, I will update the commit log.

>
> In fact, it might be even better to put a copy of the wake_up_all() in
> the "if (retval)" branch after the suspend callback and then go
> directly to out.  The "else" branch could then become part of the
> straight-through code, not indented.

Good idea, will update this in -v1.

thanks,
-- 
Ming Lei
