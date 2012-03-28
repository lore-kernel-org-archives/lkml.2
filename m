Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab2C1AYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:24:41 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55569 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343Ab2C1AYj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:24:39 -0400
MIME-Version: 1.0
In-Reply-To: <20120327162633.654c8d7e.akpm@linux-foundation.org>
References: <20120311093853.04f049c2@s6510.linuxnetplumber.net>
	<20120327162633.654c8d7e.akpm@linux-foundation.org>
Date: Tue, 27 Mar 2012 20:24:39 -0400
Message-ID: <CA+5PVA4KsG0CEs8MhEL2qQoLBU9M6xAoPX2qnTZJ2R5RQ7-osg@mail.gmail.com>
Subject: Re: [PATCH] floppy: revert floppy disable halt warning
From: Josh Boyer <jwboyer@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>, Len Brown <len.brown@intel.com>,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 7:26 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> (cc some x86 greybeards)
>
> On Sun, 11 Mar 2012 09:38:53 -0700
> Stephen Hemminger <shemminger@vyatta.com> wrote:
>
>> Remove the stupid floppy disable halt warning. It is meaningless since
>> the API is local to floppy driver.  Our boot scripts check for the
>> floppy drive, and this causes the warning to trigger every time. This
>> confuses support, breaks automated tests that look for backtraces on
>> boot,  and adds no value.
>>
>> The message is being displayed to the wrong audience, it looks like it
>> was intended as a compromise of a long discussion on LKML about
>> supporting older x86 hardware; but users don't know or understand what
>> it is saying.
>>
>> If you want to change halt handling then just fix
>> the floppy driver, don't whine about it.
>>
>> ...
>>
>> --- a/drivers/block/floppy.c  2012-03-11 09:27:52.866459327 -0700
>> +++ b/drivers/block/floppy.c  2012-03-11 09:28:29.286579201 -0700
>> @@ -1037,7 +1037,6 @@ static void floppy_disable_hlt(void)
>>  {
>>       unsigned long flags;
>>
>> -     WARN_ONCE(1, "floppy_disable_hlt() scheduled for removal in 2012");
>>       spin_lock_irqsave(&floppy_hlt_lock, flags);
>>       if (!hlt_disabled) {
>>               hlt_disabled = 1;
>
> It would have been nice to have provided a pointer to this "long
> discussion on LKML".  I tried for a while, then gave up.
>
> In my search I came across
> http://lkml.indiana.edu/hypermail/linux/kernel/1104.0/00461.html which
> does indeed remove all the disable_hlt() code as well as the warning
> and the feature-removal-schedule.txt record.  Why didn't we merge that?
> Why shouldn't we merge that now?

And again 5 months later:

https://lkml.org/lkml/2011/10/28/313

Third time's a charm?  I'd buy someone a beverage if we actually went
through our planned feature removal here...

josh
