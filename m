Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab1CHPVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 10:21:49 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46455 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab1CHPVr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 10:21:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FnvxZL3w2M25IEg60n1TbeklUeVo2SulWImWNQFLqJ1eZzYPXH+Vh5KSgZCN7XzRA5
         ZdJsAhqWky2Oy+hbWO3FQBUky0RJ0FAji8M5r1/ZCcAOusMZKOHrCjni7T/ixkblaMd3
         qJjStFMDgHHAsqqPTQ/pV8HIywVbFgP6OtZiA=
MIME-Version: 1.0
In-Reply-To: <20110308140549.GA1837@nowhere>
References: <201011181650.00152.roucaries.bastien@gmail.com>
	<AANLkTik=+smaiGNwVw0pDBXexVd=trsz9aSawuqLZP6k@mail.gmail.com>
	<20101223034229.GF1739@nowhere>
	<201101300108.32383.roucaries.bastien@gmail.com>
	<20110307190040.GI1873@nowhere>
	<AANLkTikMNw5yMxcUV3a-temcOdWa5gySZ+vTtfuBEAiD@mail.gmail.com>
	<20110308140549.GA1837@nowhere>
Date: Tue, 8 Mar 2011 16:21:45 +0100
Message-ID: <AANLkTik4Cj1Ax+LJ+MiLFPN1gEJa5UvF3=NqAK5-nqp+@mail.gmail.com>
Subject: Re: Reiserfs deadlock in 2.6.36
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> Doing a while true;do  sync && sleep1; done; help a lot
>
> Which kernel are you running by the way?

2.6.37 now

>
>> >
>> > I don't know what to do yet. I need to think more about it.
>> >
>>
>> Could we do the stuff I have sugested at first ? use lockdep to track
>> journal open,/close using fake lock ?
>
> I don't think it's not an adapted test. Lockdep is useful to detect lock inversion
> scenarios but that's not very useful to detect a lock that takes too much time
> to be released. For that we have the hung task detector, whose report we already
> have.
>
>> BTW it seems that someone experiment this confition on ext3. I could
>> do more testing if you want, and I will run xfstests in order to see
>> if I could reproduce more quickly
>
> I'm not sure the file corruption and the deadlock are linked. But
> may be xfstest can provoke the deadlock (or the file corruption)
> more quickly. It's pretty good at stressing file systems.
>
Do you know a test number to try ?

Bastien
