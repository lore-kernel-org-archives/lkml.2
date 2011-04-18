Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab1DRPX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 11:23:59 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63271 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab1DRPXw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 11:23:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ihNAvng/IBhsWgUc0uuxI/6bFYxrvOK3Hv4G5mfgxfkTRPHW9eBGndrTjbCWeH24dY
         wVywcrQc9KQ+MAc1Gdz266UaTvxhOrxKFZUeKfWSJbMzR9OxDJAHLIMKR0VRv1pngphx
         ovFR4AQXGRLEavlJDQXoN9x/+2dHxHtcIF2uc=
MIME-Version: 1.0
In-Reply-To: <20110417140924.GU18463@8bytes.org>
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
Date: Mon, 18 Apr 2011 11:23:51 -0400
Message-ID: <BANLkTikEsZHjqzT6Ur+XgJhkzJDpSy-FDA@mail.gmail.com>
Subject: Re: Linux 2.6.39-rc3
From: Alex Deucher <alexdeucher@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Jerome Glisse <j.glisse@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
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

On Sun, Apr 17, 2011 at 10:09 AM, Joerg Roedel <joro@8bytes.org> wrote:
> On Sat, Apr 16, 2011 at 02:54:04PM -0400, Jerome Glisse wrote:
>
>> If you want to go the printk way you can add printk before each test
>> ring_test, ib_test in r600.c this 2 functions are the own that might
>> trigger the first GPU gart activities.
>
> Okay, I found the place in source that triggers this. It happens in the
> function r600_ib_test. The interesting thing is that not the ib-command
> itself is responsible but the fence that is emitted afterwards (proved
> by removing the fence command, where the problem went away).
> I don't know enough about the command semantics to make a guess what
> goes wrong there. But maybe you GPU folks have an idea?
>

I can't think of anything off hand.  It might be worth disabling the
call to r600_ib_test() in r600_init() and then seeing if you get any
errors when the fences are used later on when X starts or just at that
point in the module load sequence.  What's odd is that when you tested
radeon.no_wb=1 you got the same behavior as that disables shadowing of
fence writes to gpu gart mem, so it wouldn't be writing to memory in
that case.

Alex

>        Joerg
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
