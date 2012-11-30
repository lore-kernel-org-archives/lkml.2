Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699Ab2K3Usk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 15:48:40 -0500
Received: from mail-ia0-f179.google.com ([209.85.210.179]:39139 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab2K3Usi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 15:48:38 -0500
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2012 15:48:38 EST
MIME-Version: 1.0
In-Reply-To: <1354273697.30168.87.camel@sauron.fi.intel.com>
References: <CALF0-+WuaUn5b=2XrzqW7pvM=N1MfQf=sFwLFOrokTkHbOXh3w@mail.gmail.com>
	<1354273697.30168.87.camel@sauron.fi.intel.com>
Date: Fri, 30 Nov 2012 17:43:07 -0300
Message-ID: <CALF0-+UCS+9ypoh+_sFzFcAB2b7Gc=Dj-USJvU=LWa7AdJo3ng@mail.gmail.com>
Subject: Re: [RFC/PATCH 0/1] ubi: Add ubiblock driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: dedekind1@gmail.com,
        richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

Thanks for the taking the time to answer.

On Fri, Nov 30, 2012 at 8:08 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
>
>> I don't know how many ubi volumes a user typically creates, but I
>> expect not to be too many.
>
> I think I saw something like 8-10 in some peoples' reports.
>

Mmm, that's more than I've expected.

[...]
>
>> This cache is 1-LEB bytes, vmalloced at open() and freed at release().
>
> Is it per-block device?

Yes. But notice the vmalloced cache is freed on release().
So, an unused ubiblock won't allocate it.

>Then I am not sure it is a good idea to
> automatically create them for every volume...
>

Given that ubiblock is workqueue based I believe there isn't any
performance penalty in creating many instances.

Regarding memory footprint: we should consider how much
does it cost to create an ubiblock device, plus the underlying
gendisk, request queue, etc.

If people is partitioning its ubi devices in 8-10 volumes,
then I'm not too sure if we want to create a block device
per-volume automatically. Not because of the cache -again, if an
ubiblock is unused it won't allocate any- but because of overall
unnecessary bloatness.

The main idea behind auto-creation is that, IMHO,
ubi ecosystem already has its own rather large set of
userspace tools, I'm against adding yet another one.

I'm gonna keep playing with this and come up with
the long promise numbers.

    Ezequiel
