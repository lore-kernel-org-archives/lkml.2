Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab2FGTlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 15:41:24 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50075 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2FGTlX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 15:41:23 -0400
MIME-Version: 1.0
In-Reply-To: <x497gvjb3dn.fsf@segfault.boston.devel.redhat.com>
References: <CA+Z7AcYDcZiAxPr+Au8PKoNzoT6G_0F0dAn75nb9ktXp9kBf9g@mail.gmail.com>
	<x497gvjb3dn.fsf@segfault.boston.devel.redhat.com>
Date: Thu, 7 Jun 2012 22:41:22 +0300
Message-ID: <CA+Z7AcZ=Qf7d6iCziTsi=AH+CjWkhkWeGzhOAY0VqVX3Ni_fXw@mail.gmail.com>
Subject: Re: [PATCH] change lock model in aio_put_req
From: mihailov ivan <mihailov.iaa@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/7 Jeff Moyer <jmoyer@redhat.com>:
> mihailov ivan <mihailov.iaa@gmail.com> writes:
>
>> Why used spin_lock/unlock_irq instead of
>> spin_lock_irqsave/spin_unlock_irqrestore?
>
> Because the function is never called from interrupt context.
>
>> __aio_put_req it's interrupt safe call but why aio_put_req not?
>
> __aio_put_req is called with the ctx lock already taken.  This (the __
> routine being called with the lock held) is a fairly common convention
> in the kernel.
>
> Nack.  Your patch doesn't fix anything.

Yes, my patch doesn't fix anything but it's allows this call inside of
interrupt context.
And curios why it can't be possible inside of interrupt context? From
side - never changed,
only we will can execute this call in interrupt context.
I understood what is works as designed but don't understood why we
can't imporve this call,
it's 'fairly convention in the kernel'?
