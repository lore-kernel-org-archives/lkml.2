Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab2HIFPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 01:15:03 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43843 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab2HIFPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 01:15:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120809132459.6ed7fc7e@notabene.brown>
References: <alpine.LRH.2.02.1208081308380.30954@praktifix.dwd.de>
	<20120809132459.6ed7fc7e@notabene.brown>
Date: Thu, 9 Aug 2012 13:14:59 +0800
X-Google-Sender-Auth: wHZD8sc3Mo5ReB3bM55j6Jzlt7I
Message-ID: <CANejiEUJ=kMMUdogEDsw=-ni1GrFu+QbewTOUbquyg8uVZ-N0w@mail.gmail.com>
Subject: Re: What happened to TRIM support for raid linear/0/1/10?
From: Shaohua Li <shli@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Holger Kiehl <Holger.Kiehl@dwd.de>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/9 NeilBrown <neilb@suse.de>:
> On Wed, 8 Aug 2012 13:10:51 +0000 (GMT) Holger Kiehl <Holger.Kiehl@dwd.de>
> wrote:
>
>> Hello,
>>
>> I have been using the patches posted by Shaohua Li on 16th March 2012:
>>
>>     http://lkml.indiana.edu/hypermail/linux/kernel/1203.2/00048.html
>>
>> for several month on a very busy file server (serving 9 million files
>> with 5.3 TiB daily) without any problems.
>>
>> Is there any chance that these patches will go into the official kernel?
>> Or what is the reason that these patches are no applied?
>
> I'm trying to appear to be an incompetent maintainer so that someone will
> offer to take over.  It isn't working yet.  I'm probably scuttling the
> attempt just by replying to this email - drat.
>
>>
>> I have attached the patch set in one big patch for 3.5. Please do not
>> use it since I am not sure if it is correct. Shaohua could you please
>> take a look if it is correct and maybe post a new one?
>>
>> Personally, I would think that TRIM support MD would be a very good thing.
>
> Probably.  Maybe if they get posted again I'll feel guilty and do something
> about them.
>
> One issue that needs to be fixed is that a few places assumed that the
> "discard_zeros_data" flag is always set, which is not the case (else we
> wouldn't have that flag).  That was only a couple of places though, not a
> wide spread problem.

The big problem is SATA discard request merge is broken, while doing
MD discard will trigger discard request merge. In this form, I bet Neil will
not accept the patches. So not the problem MD discard patch itself.

Last time Martin said he is working on SCSI discard request merge
patches. That isn't happened yet. Maybe I should ping Jens
to disable discard request merge currently, it's broken for a long
time anyway.
