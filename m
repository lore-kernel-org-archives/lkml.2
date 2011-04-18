Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab1DRSdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 14:33:06 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53756 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab1DRSdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 14:33:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=F17MGJRzAHf4bk8+p/3Je8i9PI3L45BCONo+m09AvsUMaVxGObO0w7LnqR8T0K02o2
         BJi842aQr3tM8pid5AwBvJLQD5SisWK5CrFLdFJ1kUOghD24bTKuXewnW3xC7jCDKsj8
         K8YMLS9CrHqd1MjWh6JTgxNmflDXOrIKfk8fk=
MIME-Version: 1.0
In-Reply-To: <4DAC82E6.3020809@fusionio.com>
References: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera> <_H4l51C1wXN.A.yDC.yGuqNB@chimera>
 <BANLkTimeaHwBiZoz=isCM=qtBxoxaBqDUw@mail.gmail.com> <BANLkTi=1jO73DXDTD50bVpU82qphVKmRCw@mail.gmail.com>
 <4DAC2429.5000105@fusionio.com> <BANLkTinCWWYqnksxevho9TN3u6ZC_Rjzwg@mail.gmail.com>
 <4DAC82E6.3020809@fusionio.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 18 Apr 2011 20:32:43 +0200
X-Google-Sender-Auth: QXhEM1D3npnwDixFYI9fG8nlfAM
Message-ID: <BANLkTimaekpwmK+z=ePE+XSP6GUteidwfw@mail.gmail.com>
Subject: Re: [Bug #32982] Kernel locks up a few minutes after boot
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Neil Brown <neilb@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 8:28 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
> On 2011-04-18 20:21, Bart Van Assche wrote:
>> a performance regression in the block layer not related to the md
>> issue. If I run a small block IOPS test on a block device created by
>> ib_srp (NOOP scheduler) I see about 11% less IOPS than with 2.6.38.3
>> (155.000 IOPS with 2.6.38.3 and 140.000 IOPS with 2.6.39-rc3+).
>
> That's not good. What's the test case?

Nothing more than a fio IOPS test:

fio --bs=512 --ioengine=libaio --buffered=0 --rw=read --thread
--iodepth=64 --numjobs=2 --loops=10000 --group_reporting --size=1G
    --gtod_reduce=1 --name=iops-test --filename=/dev/${dev} --invalidate=1

Bart.
