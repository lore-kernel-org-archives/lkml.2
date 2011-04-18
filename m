Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab1DRBMx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 21:12:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41456 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab1DRBMr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 21:12:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YDQ5TGHWPMbGBoHbLeghkKfQ/YxsVk7P9cw8J1Fyr3SXuy5YgwgQH9E/1CyF1onp/o
         zBeLqKcqVSX8FILmImbFWBRfH6k60I3UWsPx4nRDI3tqPuYiVexfLRY6oc1goDNWnmvA
         zYHhpPjHG3WdaE8Kc0ihiTHXNUGJEXKwQYxxY=
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
Date: Sun, 17 Apr 2011 21:12:47 -0400
Message-ID: <BANLkTi=csRDS6DM+8dkG3_DmdU4VxX8sgg@mail.gmail.com>
Subject: Re: Linux 2.6.39-rc3
From: Jerome Glisse <j.glisse@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        alexandre.f.demers@gmail.com
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
>        Joerg
>
>

I can't think of any theory, at that point the wb, irq ring, cp buffer
& ib pool are all allocated and pinned into gtt so they all have valid
entry backed by a real page. Maybe the GART flush & update is
seriously buggy but i expect we would have been hurt sooner by such
things. Maybe there is a bug in the hw... wouldn't be surprised. Will
try to think to crazy theory.

Cheers,
Jerome
