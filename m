Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab1L2DUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 22:20:36 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51189 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab1L2DUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 22:20:34 -0500
MIME-Version: 1.0
In-Reply-To: <1325127531.2029.13.camel@shrek.rexursive.com>
References: <CAGsJ_4yXU62GZ38fe7TCH8uKLHJvZ8jtFbJLywqv1kgC7y9V_A@mail.gmail.com>
 <1325115628.2029.1.camel@shrek.rexursive.com> <CAGsJ_4xH-9MXq8UJJFLW=upBqK+PXbWfDJhttBN=n2_M0PzMSw@mail.gmail.com>
 <1325127531.2029.13.camel@shrek.rexursive.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 29 Dec 2011 11:20:12 +0800
Message-ID: <CAGsJ_4x2yCNf48xnVzBCZLJhdUaAOfoNHx5AFamZMXgLZ0PEKw@mail.gmail.com>
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
> On Thu, 2011-12-29 at 10:37 +0800, Barry Song wrote:
>> i mean we can load image and decompress them in different threads when
>> we reboot from hibernation. after i read codes more carefully, that
>> has actually been done by lzo_decompress_threadfn().
>
> Correct. Both hibernation and thaw are multi-threaded.
>
>> here the problem is we didn't seem to get any faster after applying
>> your compression patch when doing hibernation on SD/NAND.
>> we are trying to figure out the reason.
>
> This may depend on many factors:
>
> - how much CPU power you have
> - how many CPUs you have
> - how much I/O can your disk do
>
> Remember, there is one thread that does CRC32 as well and other threads
> will have to sync with that thread.
>
> Anyhow, it would be interesting to know where the bottleneck is on your
> particular system. If you system has lots of CPU power and fast I/O, the
> patch indeed may not do anything at all.
>
> PS. I did my testing on a ThinkPad T510 laptop. It has a Core i5 M520
> 2.4 GHz mobile CPU (this appears to the system as 4 CPUs - it's two
> physical cores with hyper-threading enabled). The disk is classic
> platter based disk (Seagate ST9500420AS). There is 8 GB of RAM on this
> system.

well. our guys are still debugging.
the platform is ARM cortex-a9 single-core 1Ghz SoC and we save image
to a SD card or NAND.
a phenomenon we saw is that multi-BIOs is not merged into a request by
block level elevator. so the SD/NANDdisk driver handles many small
request one page by one page.

>
> --
> Bojan
>
-barry
