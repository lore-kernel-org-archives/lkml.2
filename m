Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab1CAXkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 18:40:13 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:52460 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab1CAXkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 18:40:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bymsS5w8qAn3IK6D+HbZgvvGGYzpBxwqH6q82Hp97hWyGfbNouM+mOtuiOkq6UZPsN
         h9nSSB9B6UUg9KFgamIP5HjZUyDCspS+K7TRAipC4IhBkJbBTijF9mT/bvT5JXNaPuj3
         +BFYzKyIIxM9VnN5JDB54Pr6Ht5D+2DHqd/xU=
MIME-Version: 1.0
In-Reply-To: <201103012207.22798.rjw@sisk.pl>
References: <cover.1298820825.git.tardyp@gmail.com>
	<Pine.LNX.4.44L0.1103011431400.2034-100000@iolanthe.rowland.org>
	<AANLkTi=ogThxB_2bxANV4hUsLGZs04gzHSCyH90Bm87U@mail.gmail.com>
	<201103012207.22798.rjw@sisk.pl>
Date: Wed, 2 Mar 2011 00:40:09 +0100
Message-ID: <AANLkTinNG9ecqSGk+zDjd0A+nLXmwHQkRot0WZ18amsv@mail.gmail.com>
Subject: Re: [linux-pm] [RFC,PATCHv3 0/3] sdhci runtime_pm implementation
From: Pierre Tardy <tardyp@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 1, 2011 at 10:07 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, March 01, 2011, Pierre Tardy wrote:
>> On Tue, Mar 1, 2011 at 8:33 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> > On Tue, 1 Mar 2011, Pierre Tardy wrote:
>> >
>> >> Please find sdhci runtime_pm implementation.
>> >>
>> >> It uses clock gating fw as a tip to know when our chip is idle.
>> >> It implements wake up from card insertion/removal.
>> >>
>> >> This is RFC, please dont merge yet. I really would like to have deep review
>> >> from PCI linux-pm guys.
>> >>
>> >> Opens are:
>> >>
>> >> 1/ Not sure if the pci configs in the driver in rpm_suspend/resume flow
>> >>  are not duplicate from what the core is doing.
>> >
>> > There may be one or two small errors.
>> >
>> >> 2/ Wakeup from D3hot: I cannot find any driver that is implementing it in current upstream,
>> >
>> > Other drivers do it, but they use PCI PME# instead of interrupts.
>> Could you please elaborate?
>> My understanding is that PCI PME will generate MSI, which translate in
>> interrupt.
>
> Your driver won't get those interrupts.
>
> How it works is, basically, that when the device signals wakeup, it either
> causes a PME# signal to be raised (parallel PCI), or a PME Message to be
> sent upstream (PCIe).  In the first case it will cause a platform event
> (eg. ACPI GPE) to occur and the handle of that event will resume your
> device (using pm_request_resume()).  In the second case it will cause the PCIe
> root port handling the PME Message to generate an interrupt and the handler of
> that interrupt will resume your device.
Thanks, that explain a lot how it works.
What I still dont understand is that the wake source I'll have (e.g.
sd card insert) is still an interrupt source.
So it is supposed to generate interrupt until the interrupt source is
acknowledged.
Are we supposed to mask that interrupt source while suspended to make
sure we have either wake or interrupt?

>
> In fact, there are a few drivers in the tree using this mechanism already
> (r8169, e1000e, i believe PCI HCDs too).
Hope there will be more and more.

thanks,
Pierre
