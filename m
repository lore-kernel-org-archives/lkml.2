Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab2KXVao (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 16:30:44 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34234 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab2KXVan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 16:30:43 -0500
MIME-Version: 1.0
In-Reply-To: <50B124E9.400@zytor.com>
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org>
	<1353482170-10160-12-git-send-email-yinghai@kernel.org>
	<50AD0CA1.8000904@zytor.com>
	<CAE9FiQUSjRT-r5ZE3WHVaKkUOhwFWkm9CTCv1Aa63DOsfMQMiQ@mail.gmail.com>
	<50AD291A.10600@zytor.com>
	<CAE9FiQVed0tXhbtmc_Gug0gFZ=s=j=N4B5Vr2_ZTmSj6L-65dw@mail.gmail.com>
	<a1ca794a-09d4-4d36-8c8c-67100cb3696e@email.android.com>
	<CAE9FiQXJO8uxT9Gzjv9e8XeiLzwBX7fwTFzDVy=oPfboG4L=3Q@mail.gmail.com>
	<CAE9FiQWeGz2TkLBrBZcoPrNABx51XK3xk58P+Zam_LRGoJdSiw@mail.gmail.com>
	<a8b15bf0-4e3b-4fde-9190-26890f9abf77@email.android.com>
	<CAE9FiQUoj9k0Tbqp8LC8Wb21_s_x8naiWX4zkX9pJG-oFnAQ9g@mail.gmail.com>
	<50AE70E7.6060204@zytor.com>
	<87haofi3d3.fsf@xmission.com>
	<50B104BC.90208@zytor.com>
	<50B124E9.400@zytor.com>
Date: Sat, 24 Nov 2012 13:30:41 -0800
X-Google-Sender-Auth: Zse_kP6vZEwbKDQndXDQRUuBf-Q
Message-ID: <CAE9FiQWKzH+BLwak5-n2px1Yhti872o=Qte-v_8N_5X3YSJ=5A@mail.gmail.com>
Subject: Re: [PATCH v3 11/12] x86, boot: add fields to support load bzImage
 and ramdisk high
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 24, 2012 at 11:50 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 11/24/2012 09:32 AM, H. Peter Anvin wrote:
>>
>> On 11/24/2012 04:37 AM, Eric W. Biederman wrote:
>>>
>>>
>>> Certainly /sbin/kexec isn't bothering to calculate the end of the setup
>>> header and just being far more conservative and using all of the 16bit
>>> real mode code as it's initializer.
>>>
>>
>> That's not conservative... that's just plain wrong.  It means you're
>> initializing the fields in struct boot_params with garbage instead of a
>> predictable value (zero).
>>
>> We could work around it with a sentinel hack... except you *also*
>> probably modify *some* fields and now we have a horrid mix of
>> initialized and uninitialized fields to sort out... and there really
>> isn't any sane way for the kernel to sort that out.
>>
>> We have a huge problem on our hands now because of it.
>>
>
> So, given the mess we now have on our hands... any suggestions how to best
> solve it?  There is the option of simply declaring old kexec binaries
> broken; they will then not work reliably with newer kernels, if they even
> work reliably now -- it is hard to know for certain.

yes, if the user updates kernel to be kexeced, then would be
reasonable to ask them to
update kexec-tools.
