Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857Ab0JUWNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 18:13:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42108 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab0JUWNu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 18:13:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FsRiWysaoOmAkggtQffAIMKdYMSU22sYO27Njw5pQow6JiIyu8KsKw/Q+NpZeNVZrk
         KPGSUnSGGuIz/PvdwTpZriCdWyE8b3MokMbdDSr9KywpxPAY63JCxT7NiZYHj7eXWa9d
         bOHJhpYm4tc62V5Nq7JsxXTResx8yVQINvoys=
MIME-Version: 1.0
In-Reply-To: <AANLkTin4A61K9uW1Cns3rr3eDkWQ+KCBP8jt4M4tFQHP@mail.gmail.com>
References: <AANLkTin4A61K9uW1Cns3rr3eDkWQ+KCBP8jt4M4tFQHP@mail.gmail.com>
Date: Fri, 22 Oct 2010 00:13:49 +0200
Message-ID: <AANLkTi=Ju8KFDaeizbvZbDTX9gSi_hKU04RcJ4yms2gQ@mail.gmail.com>
Subject: Re: Re: [RFC/RFT PATCH] sched: automated per tty task groups
From: Marco <mpiazza@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've made some tests to give a try to tty grouping patches.

Kernel 2.6.36+CONFIG_SCHED_AUTOGROUP+Improve_tick_preemption.patch

These are the result of :
taskset -c 0 ./wakeup-latency& sleep 30;killall wakeup-latency (owner marco)
vs
taskset -c 0 make -j 10 bzImage


Vanilla 2.6.36
maximum latency: 52879.7 탎
average latency: 4217.5 탎
missed timer events: 0

Kernel 2.6.36+autogroup enabled
maximum latency: 2840.8 탎
average latency: 15.5 탎
missed timer events: 0

Kernel 2.6.36+libpam-systemd enabled
maximum latency: 26361.6 탎
average latency: 4548.6 탎
missed timer events: 0

Kernel 2.6.36+START-NICE sched feature(v3)
maximum latency: 76182.8 탎
average latency: 4930.1 탎
missed timer events: 0

Quite impressive.....
Now, i can play supertuxkart while make'ing -j 10 and stellarium shows
the highest fps i've seen so far.
Very good job, guys.

Marco


On Thu, Oct 21, 2010 at 11:17 AM, Marco <mpiazza@gmail.com> wrote:
> Hello, i'm a little confused about tty grouping.
> The benefit in terms of latency is only due to the grouping of task
> under the appropriate cgroup hierarchy?
>
> Can this issue be solved by userspace daemon (think of libpam-systemd,
> libpam-cgroup)? Perhaps tty grouping in kernel space is more
> efficient.
>
> I'm missing something?
>
> Marco
>
