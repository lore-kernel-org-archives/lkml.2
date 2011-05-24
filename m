Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab1EXTKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 15:10:00 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60306 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab1EXTJ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 15:09:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oz7OB4VbruSyGUsniKwuu++w7oo0WOWwUXC3Zv1twdda6kt8M3Ruep+BicTpLMz0FB
         qoCGuSCRewesemeCyalNk4HNiUSYbK2KwC69LtIYzVrhATAJpnWAABS3fxEqykLm6HWB
         B8DG7QB2M0VDnUf7mddCjWKWMR3b45w7InuJE=
MIME-Version: 1.0
In-Reply-To: <201105242059.59770.rjw@sisk.pl>
References: <1306247112.2066.8.camel@Tux>
	<201105242059.59770.rjw@sisk.pl>
Date: Tue, 24 May 2011 21:09:58 +0200
Message-ID: <BANLkTimYuJiiCbqO9QxgaAKHAZWe04vhgA@mail.gmail.com>
Subject: Re: [PATCH] MIPS:i8259.c remove resume and shutdown to syscore_ops
From: Manuel Lauss <manuel.lauss@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: wanlong.gao@gmail.com, Ralf Baechle <ralf@linux-mips.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Pengfei Zhang <zoppof.zhang@gmail.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 8:59 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, May 24, 2011, Wanlong Gao wrote:
>>
>> > On Tue, May 24, 2011 at 08:19:18PM +0800, Pengfei Zhang wrote:
>> >
>> > > Remove the resume and shutdown of i8259A from the sysdev_class
>> > > to the syscore_ops since these members had removed from the
>> > > structure sysdev_class.
>> >
>> > I don't see why one would want to want to first call
>> > register_syscore_ops
>> > then sysdev_class_register and sysdev_register?
>> >
>> Hi Ralf:
>> If these not moved to syscore_ops, building will get error.
>>
>> Hi Thomas:
>> Does you mean that we can just remove the sysfs entry now ?
>
> I had the appended patch in my tree before the merge window started,
> but it conflicted with analogous changes in the MIPS tree, so I had
> dropped it.  Was it a mistake?
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> Acked-and-tested-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  arch/mips/alchemy/common/dbdma.c |   92 +++++++++++----------------------------
>  arch/mips/alchemy/common/irq.c   |   62 +++++++++-----------------

I took care of these two, they were the reason for the conflict in -next.

Manuel
