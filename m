Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab1CHIlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 03:41:18 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62874 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab1CHIlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 03:41:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=imtGQoTO1e2FP7KP+HK34v++pWQWaZ8CELSdEXQTjU0k+V/hojjHxJijGdUF5yS/RJ
         KhpCifmUjhVPOCMvEqJG9WAiAKSeJIWOP/IKTSbpvfvyjMmSYRdGG389PmTkaExYL8k6
         69r08SuJQ5v3dGVSu3zPM4soTl0575X5JRyqo=
MIME-Version: 1.0
In-Reply-To: <20110307190040.GI1873@nowhere>
References: <201011181650.00152.roucaries.bastien@gmail.com>
	<AANLkTik=+smaiGNwVw0pDBXexVd=trsz9aSawuqLZP6k@mail.gmail.com>
	<20101223034229.GF1739@nowhere>
	<201101300108.32383.roucaries.bastien@gmail.com>
	<20110307190040.GI1873@nowhere>
Date: Tue, 8 Mar 2011 09:41:15 +0100
Message-ID: <AANLkTikMNw5yMxcUV3a-temcOdWa5gySZ+vTtfuBEAiD@mail.gmail.com>
Subject: Re: Reiserfs deadlock in 2.6.36
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 7, 2011 at 8:00 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> Hi Bastien,

Cc: Ingo Molnar because he work a lot on soft lockup, and could have
an idea to debug
cc: andrew morton that trakc also "File/memory corruption in 2.6.37"

>> I take me more than two days of testing to reporduce this bugs with trace enabled. My filesystem was quite slow and this bugs seems
>> to be timing related.
>>
>> One patern that trigger this bug is git. Doing a lot of git work of my desktop crash my machine.
>>
>> Moreover, trying to reproduce this bug lead to data loss. I have rebuilded twice my / partition using --rebuild-tree, and restored
>> my home partition three times using backups.
>>
>> My log is here.
>>
>> Do you need more information?
>
> Yeah do you have CONFIG_REISERFS_CHECK? I just would
> like to ensure we are not missing this important source of
> information.

Yes I have it
> I'm puzzled because, given the traces, your opening and closing of the journal are
> well balanced.
>
> You have a writer queued and stuck but I see no trace of it in the traces stream.
> I only see well balanced journal operations, including journal closing that would have
> woken your queued writer.
>
> A theory could be that your queued writer was waiting for someone to close the journal,
> which finally happen but actually several minutes later, after there was many
> journal opening/closing that overwrote the old trace containing the queueing of
> the stuck writer.

Doing a while true;do  sync && sleep1; done; help a lot

>
> I don't know what to do yet. I need to think more about it.
>

Could we do the stuff I have sugested at first ? use lockdep to track
journal open,/close using fake lock ?

BTW it seems that someone experiment this confition on ext3. I could
do more testing if you want, and I will run xfstests in order to see
if I could reproduce more quickly

Bastien
