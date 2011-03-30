Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab1C3CQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 22:16:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61786 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab1C3CQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 22:16:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LN2K8KA2y84yrVkqRXVK8wTzmLEHIxW73BopbFVJ0gppL/RhsOdXDMSit2p/jrFiE8
         vh8es/wElPukCHNxf/3q2V5fNCP0aUnh/ofst3vQCIRv32wVwhAr1ZwZMng1rK6KbIyU
         YXdg6bpX6wrXauhIiA+znhjJ/+5wdHH/Y71hg=
MIME-Version: 1.0
In-Reply-To: <AANLkTikXdFc2dkiaakQERaa6cV7Z-VoEZ5bgRptvCc_w@mail.gmail.com>
References: <AANLkTikXdFc2dkiaakQERaa6cV7Z-VoEZ5bgRptvCc_w@mail.gmail.com>
Date: Wed, 30 Mar 2011 02:16:24 +0000
Message-ID: <AANLkTinQ+mQ5rsS473TTggYs5jzWe-SXHj48jQqvb0wS@mail.gmail.com>
Subject: Re: ioprio_set: IDLE_CLASS doesn't work as its name suggests
From: "fykcee1@gmail.com" <fykcee1@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Heihaier <admin@heiher.info>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I/O activity of IOPRIO_CLASS_IDLE processes can reduce other's I/O
performance by nearly half, according to
http://dev.lemote.com/files/upload/people/~chenj/effect_of_IO_IDLE.png.

It seems "IDLE" in "IOPRIO_CLASS_IDLE" is not analogized to "IDLE" in
"SCHED_IDLE", is it the normal behavior?

2011/3/26 fykcee1@gmail.com <fykcee1@gmail.com>
>
> Hi all,
>
> I've tried to make a fast boot according to "Booting Linux in five
> seconds"[1]. One method of boot fast is using readahead -- a process
> "replay" read actions in IDLE IO class via readahead syscall. Sadly
> observed negative results -- according to bootchat diagram, readahead
> process actually uses more IO bandwidth that slows down all IO
> operations of other ones.
>
> Then I did some tests -- two I/O hog processes, the IDLE IO class one
> largely degrades I/O performance of the other one.
>
> The tests were performed on a machine with dual-core cpu (intel
> E5400@2.7GHz), G33 and ICH7, 2G mem, running Ubuntu 10.04. The kernel
> version was 2.6.35-25-generic with CFQ as default I/O scheduler.
> We ran test programs which time "find $2 -type f -exec cat {} \;" on
> ~1.9G directory with Normal and IDLE IO class. Before each test, we
> reboot the system. Here are the results:
>
> 1. Only ran one instance of the test program in Normal IO class:
> Job finished in 4m2.365s
>
> 2. Ran two instances of the test program, one Normal IO class, the
> other Idle IO class:
> [Normal]: 7m0.999s
> [Idle]: 7m43.180s
>
> 3. Ran two instances of the test program, both Normal IO class:
> [Normal1]: 8m39.366s
> [Normal2]: 8m39.377s
>
> BTW, for those interested in the detail, try the attachment:
> 1. mkdir ioprio_test
> 2. cp ioprio_test.c run_test.sh ioprio_test
> 3. tar xf <system_image.tar.gz> -C ioprio_test/tdir1
> 4. tar xf <system_image.tar.gz> -C ioprio_test/tdir2
> 5. reboot; cd ioprio_test && ./run_test.sh 1 => result stored in F.txt
> 6. reboot; cd ioprio_test && ./run_test.sh 2 => result stored in
> F[B0].txt B0[F].txt
> 7. reboot; cd ioprio_test && ./run_test.sh 3 => result stored in
> F[B1].txt B1[F].txt
>
>
>
> Regards,
> cee1
> -------
> [1] http://lwn.net/Articles/299483/



--
Regards,
- cee1
