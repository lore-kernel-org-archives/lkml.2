Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab1DDPD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 11:03:26 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56339 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab1DDPDY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 11:03:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ginkel.com; s=google;
        h=mime-version:x-originating-ip:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-type:content-transfer-encoding;
        b=qWWmePTMe3+4ALaB0U46Pd/tiCILPmz411mfNdWbAVQDhURRm8xBAfbAzryfXj73NR
         tY1yjkYZkz+6+rxMhu6gnUCpbWL5P0lQJmxw/jFu6pw2L05gSOhNXyQ1pd0csDpWEyLW
         YF5mU8sih8NMsu0Wb9wTViAGa6Zz11jWgWFkA=
MIME-Version: 1.0
X-Originating-IP: [46.115.4.186]
In-Reply-To: <201104041640.15578.arnd@arndb.de>
References: <AANLkTim5ctAoaB4+BS7Z-+ARUgTEBO22bkYMUvFtGmoN@mail.gmail.com>
 <201104040502.52526.arnd@arndb.de> <BANLkTi=n4jLsjOYCd0L3hYb30sgPmdv_WA@mail.gmail.com>
 <201104041640.15578.arnd@arndb.de>
From: Thilo-Alexander Ginkel <thilo@ginkel.com>
Date: Mon, 4 Apr 2011 17:02:54 +0200
Message-ID: <BANLkTim4Ro+u-9jfLPV1-+tM88xtvN-VTg@mail.gmail.com>
Subject: Re: Soft lockup during suspend since ~2.6.36
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 4, 2011 at 16:40, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 04 April 2011, Thilo-Alexander Ginkel wrote:
>> The result is available in these pictures:
>>   https://secure.tgbyte.de/dropbox/IeZalo4t-1.jpg
>>   https://secure.tgbyte.de/dropbox/IeZalo4t-2.jpg
>>
>> For both traces, the printed error message reads: "BUG: soft lockup -
>> CPU#3 stuck for 67s! [kblockd:28]"
>>
>> (After a bit of Googling I understand that a soft lockup is probably
>> different from a deadlock - please correct me if that assumption is
>> wrong)
>
> My interpretation is that some process tries to use
> kblockd_schedule_work() after the CPU for that workqueue has been
> disabled. The work queue functions (worker_maybe_bind_and_lock)
> is waiting for the CPU to become available, which it doesn't do.

Thanks for your help so far!

Is there a way to figure out which process that may be?

> You see different outputs every time the softlockup detection finds
> this because the loop is in different states here. The reason why
> the spin_unlock shows up here is because that is when the interrupts
> get enabled and the softlockup detection notices the timeout.

OK, that make sense.

> I'm pretty sure that this has nothing to do with the bisected bug
> that you initially found, but maybe somebody else can try analysing
> this better.

ACK. I see two possibilities:
a) The bug was introduced after the bisected bug was fixed
b) The bug was already present earlier, but was masked by the bug from
the bisected change

I hope for a) as that would open the possibility to bisect this new bug.

Regards,
Thilo
