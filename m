Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab0IBOG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 10:06:56 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46554 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab0IBOGu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:06:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=mvMgM5DLjchXrBMKiJS8v16q1UV76P03riFopn/e+cGeu+OdHQVvwAh98HwWgifH4u
         dU4wUDIH++tp1Ef9fXlcpJG8q0cBKK5q9a9QxJkHXysakDseyLo88mJfkY1viy2QStyG
         bRruca/B53e1SfEOX2fW1lzhp+JBR2uLkPQYw=
MIME-Version: 1.0
In-Reply-To: <x49bp8gfeax.fsf@segfault.boston.devel.redhat.com>
References: <AANLkTi=O6Tpiz8TRFFknEpW7MMTGBAtqCpr7zH3abO67@mail.gmail.com>
	<x49fwxtqsh8.fsf@segfault.boston.devel.redhat.com>
	<AANLkTikGYEuCE2-TaKwANwoCFEjVNL4KZa1AhJ2woGud@mail.gmail.com>
	<x49bp8gfeax.fsf@segfault.boston.devel.redhat.com>
Date: Thu, 2 Sep 2010 15:06:48 +0100
Message-ID: <AANLkTimjuyHMkVPrjpPAe2sMwCAVnQjDigQkHmV4ZhAc@mail.gmail.com>
Subject: Re: I/O scheduler deadlocks on Xen virtual block devices
From: Doug Neal <dneallkml@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>
>>> Did you try these different I/O schedulers in the domU or on the dom0?
>>> Does switching I/O schedulers in either place make the problem go away
>>> when it happens?
>>>
>>
>> In the domU, and the bug was present in all cases. The dom0 was using
>> cfq. I'll run the tests again using each scheduler in the dom0 with
>> domU set to noop and report back.
>
> While I think this is an interesting test, you need only test one I/O
> scheduler in the dom0.  Also, I think you misunderstood the second
> question.  I'd like to know if switching I/O schedulers while the system
> is in this bad state helps get I/O going again.
>
Jeff,

Issue confirmed in the following cases:

dom0:domU
noop:noop
noop:deadline
noop:anticipatory
cfq:noop
cfq:deadline
cfq:anticipatory
cfq:cfq

I try switching schedulers in the domU during the lockup, the echo x >
/sys/block/xvda/queue/scheduler command also hangs. In the dom0, no
effect.

Cheers,

Doug
