Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab1LaI4g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 03:56:36 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41158 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab1LaI4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 03:56:34 -0500
MIME-Version: 1.0
In-Reply-To: <1325130899.2029.18.camel@shrek.rexursive.com>
References: <CAGsJ_4yXU62GZ38fe7TCH8uKLHJvZ8jtFbJLywqv1kgC7y9V_A@mail.gmail.com>
 <1325115628.2029.1.camel@shrek.rexursive.com> <CAGsJ_4xH-9MXq8UJJFLW=upBqK+PXbWfDJhttBN=n2_M0PzMSw@mail.gmail.com>
 <1325127531.2029.13.camel@shrek.rexursive.com> <CAGsJ_4x2yCNf48xnVzBCZLJhdUaAOfoNHx5AFamZMXgLZ0PEKw@mail.gmail.com>
 <1325130899.2029.18.camel@shrek.rexursive.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 31 Dec 2011 16:56:12 +0800
Message-ID: <CAGsJ_4wMLnYmj_vNGm7gw8mT6A8RSymQ=G7ABHx9HXvzWa7ZaA@mail.gmail.com>
Subject: Re: [PATCH] PM / Hibernate: Improve performance of LZO/plain
 hibernation, checksum image
To: Bojan Smojver <bojan@rexursive.com>
Cc: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/29 Bojan Smojver <bojan@rexursive.com>:
> On Thu, 2011-12-29 at 11:20 +0800, Barry Song wrote:
>> the platform is ARM cortex-a9 single-core 1Ghz SoC and we save image
>> to a SD card or NAND.
>> a phenomenon we saw is that multi-BIOs is not merged into a request by
>> block level elevator. so the SD/NANDdisk driver handles many small
>> request one page by one page.
>
> Interesting, thanks.

we did see some visible IO performance improvement now. the main
reason we didn't see that before is because we enable on-demand
cpufreq in default status. while saving and resuming from snapshot,
cpu frequence is switched frequently due to IO sleep and
compression/uncompression CPU consume. then we enable Performance
policy while booting, and move to on-demand after system boot, we did
see a great performance improvement.
for our inand card, the speed to read/uncompress snapshot is improved
from 7.x MB to 11MB.

>
> --
> Bojan
>
-barry
