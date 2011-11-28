Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab1K1PAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:00:05 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47230 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab1K1PAD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:00:03 -0500
MIME-Version: 1.0
In-Reply-To: <20111127093321.GC31086@kroah.com>
References: <cover.1322328073.git.rubini@gnudd.com> <51ba376321edbd0bcbd206cb28abb14a68a05a2b.1322328075.git.rubini@gnudd.com>
 <20111126200341.GD11421@kroah.com> <7431481.TL8TOhprdN@harkonnen> <20111127093321.GC31086@kroah.com>
From: Federico Vaga <federico.vaga@gmail.com>
Date: Mon, 28 Nov 2011 15:59:41 +0100
Message-ID: <CAH5GJ0rwJj9m7Hx1o_1N-Hb7CmDU9hRfp3oPXET9ecD4+TQDYA@mail.gmail.com>
Subject: Re: [RFC PATCH 3/7] drivers/zio: core files for the ZIO input/output
To: Greg KH <greg@kroah.com>
Cc: Alessandro Rubini <rubini@gnudd.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, dcobas@cern.ch, siglesia@cern.ch,
        manohar.vanga@cern.ch
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/27 Greg KH <greg@kroah.com>:
> On Sat, Nov 26, 2011 at 11:58:41PM +0100, Federico Vaga wrote:
>> In data sabato 26 novembre 2011 12:03:41, Greg KH ha scritto:
>> > On Sat, Nov 26, 2011 at 06:30:42PM +0100, Alessandro Rubini wrote:
>> > > +static struct kobj_type zdktype = { /* For standard and extended
>> > > attribute */ +    .release   = NULL,
>> >
>> > Sweet!
>> >
>> > As-per the in-kernel documentation, I now get to mock you for doing
>> > this :)
>> >
>> > Please NEVER DO THIS, you are ignoring the messages that the kernel
>> > sends you when you remove one of these devices, and causing a memory
>> > leak.
>>
>> Honestly we never see any messages about this.
>
> Really?  Then you never removed that kobject from memory.  Please go
> read the kobject documentation for more details.

Yes. All the kobjects are correctly removed and no memory leak was found.

I took a look into kobject.c and I found (I suppose) the message but
it is a pr_debug(); if it is so important we can think to "promote" it
to pr_warning()

>> > Not nice at all, yet another reason to use a 'struct device'.
>>
>> I don't think is a valid reason, because device_release implementation require
>> us to implement a release method within device, or device_type or class; so we
>> can use kobj_type as well.
>
> True, but it tries to make things easier to not get wrong, like you are
> here.
>
> Please fix this.

I'll fix it

> greg k-h
>



-- 
Federico Vaga
