Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab1DRP7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 11:59:37 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37666 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab1DRP7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 11:59:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=c2e9TvfwbI09ZgBElr7U+fH+giVrVOlD8ju5UJ2nec0iYPzNMlAFJ8QB2XwWTcfilI
         NCvnvCRxNshIMVBoFbxgcHQCHDMjKc1dOw9qJtB/RNGtKIJBAcY1uzHG3kPZeRUkA/09
         Vn6Y2BEACinlWR1EjQCXmmARK9PePzpCkBT0c=
MIME-Version: 1.0
In-Reply-To: <BANLkTintukwS-FibGRdP0R52nSjcGywV=g@mail.gmail.com>
References: <BANLkTinud+4nUkZtnYRrU_gAFaMDWRa_AA@mail.gmail.com>
	<4DA655E7.3000904@zytor.com>
	<BANLkTimqR_M5keMqr5WAuz-t+1BkCZbwCg@mail.gmail.com>
	<BANLkTincU4rM+SqhzGOK_Rgxgg8fqJOOdQ@mail.gmail.com>
	<20110415131152.GJ18463@8bytes.org>
	<20110415131650.GB18660@elte.hu>
	<20110415154604.GN18463@8bytes.org>
	<BANLkTim23SQiyb4R+QA7=fpPZrnQw9_PRQ@mail.gmail.com>
	<20110416163509.GS18463@8bytes.org>
	<BANLkTimxG3QoLx0vqw9YgE_s4qyzcEoEaQ@mail.gmail.com>
	<20110417140924.GU18463@8bytes.org>
	<BANLkTikEsZHjqzT6Ur+XgJhkzJDpSy-FDA@mail.gmail.com>
	<BANLkTin3XeXBEvWZcKVdPvif=Ndr0h3UVA@mail.gmail.com>
	<BANLkTintukwS-FibGRdP0R52nSjcGywV=g@mail.gmail.com>
Date: Mon, 18 Apr 2011 11:59:25 -0400
Message-ID: <BANLkTimW2WpbxRGDwJ9AFQf9FnYSCXs9Ow@mail.gmail.com>
Subject: Re: Linux 2.6.39-rc3
From: Jerome Glisse <j.glisse@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Joerg Roedel <joro@8bytes.org>, Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, alexandre.f.demers@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 11:33 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
> On Mon, Apr 18, 2011 at 11:29 AM, Jerome Glisse <j.glisse@gmail.com> wrote:
>> On Mon, Apr 18, 2011 at 11:23 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
>>> On Sun, Apr 17, 2011 at 10:09 AM, Joerg Roedel <joro@8bytes.org> wrote:
>>>> On Sat, Apr 16, 2011 at 02:54:04PM -0400, Jerome Glisse wrote:
>>>>
>>>>> If you want to go the printk way you can add printk before each test
>>>>> ring_test, ib_test in r600.c this 2 functions are the own that might
>>>>> trigger the first GPU gart activities.
>>>>
>>>> Okay, I found the place in source that triggers this. It happens in the
>>>> function r600_ib_test. The interesting thing is that not the ib-command
>>>> itself is responsible but the fence that is emitted afterwards (proved
>>>> by removing the fence command, where the problem went away).
>>>> I don't know enough about the command semantics to make a guess what
>>>> goes wrong there. But maybe you GPU folks have an idea?
>>>>
>>>
>>> I can't think of anything off hand.  It might be worth disabling the
>>> call to r600_ib_test() in r600_init() and then seeing if you get any
>>> errors when the fences are used later on when X starts or just at that
>>> point in the module load sequence.  What's odd is that when you tested
>>> radeon.no_wb=1 you got the same behavior as that disables shadowing of
>>> fence writes to gpu gart mem, so it wouldn't be writing to memory in
>>> that case.
>>>
>>> Alex
>>>
>>
>> It might be the irq ring write that is faulty.
>
> That's disabled with no_wb=1 as well.
>
> Alex
>

I mean the irq interrupt ring, i don't see this being disabled when no_wb=1

Cheers,
Jerome
