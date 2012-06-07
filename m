Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab2FGTwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 15:52:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112Ab2FGTwN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 15:52:13 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: mihailov ivan <mihailov.iaa@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] change lock model in aio_put_req
References: <CA+Z7AcYDcZiAxPr+Au8PKoNzoT6G_0F0dAn75nb9ktXp9kBf9g@mail.gmail.com>
	<x497gvjb3dn.fsf@segfault.boston.devel.redhat.com>
	<CA+Z7AcZ=Qf7d6iCziTsi=AH+CjWkhkWeGzhOAY0VqVX3Ni_fXw@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 07 Jun 2012 15:52:11 -0400
In-Reply-To: <CA+Z7AcZ=Qf7d6iCziTsi=AH+CjWkhkWeGzhOAY0VqVX3Ni_fXw@mail.gmail.com>
	(mihailov ivan's message of "Thu, 7 Jun 2012 22:41:22 +0300")
Message-ID: <x4962b2aoic.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mihailov ivan <mihailov.iaa@gmail.com> writes:

> 2012/6/7 Jeff Moyer <jmoyer@redhat.com>:
>> mihailov ivan <mihailov.iaa@gmail.com> writes:
>>
>>> Why used spin_lock/unlock_irq instead of
>>> spin_lock_irqsave/spin_unlock_irqrestore?
>>
>> Because the function is never called from interrupt context.
>>
>>> __aio_put_req it's interrupt safe call but why aio_put_req not?
>>
>> __aio_put_req is called with the ctx lock already taken.  This (the __
>> routine being called with the lock held) is a fairly common convention
>> in the kernel.
>>
>> Nack.  Your patch doesn't fix anything.
>
> Yes, my patch doesn't fix anything but it's allows this call inside of
> interrupt context.

But it doesn't need to be called from interrupt context, so there's
really no point in changing it.

> And curios why it can't be possible inside of interrupt context?

If ever a caller needs the functionality, we can change it.

> From side - never changed, only we will can execute this call in
> interrupt context.  I understood what is works as designed but don't
> understood why we can't imporve this call, it's 'fairly convention in
> the kernel'?

Changing this is simply not an improvement, it's just a change with no
benefit.  There's really no point.

Now, are you going to tell me that you want to call this function from
interrupt context in some third party driver?  What's the real
motivation for this patch?

Cheers,
Jeff
