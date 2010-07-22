Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab0GVWhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 18:37:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37082 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab0GVWhs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 18:37:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PRQC6RDlX0AO/dqM1TflnFAoTUnmBsojQIYAqu/Vm/Ppbfdnc6dSKGdFjVkTRkGjOQ
         Eh8186S7TOuBNeKq4cTZFkoiffJux3OLvzZ8DwoVv2uJuwU1D1TGOLmyZQgl05Av+wj0
         DJPDWOXOqvzzWaqGjEMY0GGrvgIWQAsFtiiKc=
MIME-Version: 1.0
In-Reply-To: <20100721091200.40c43158@schatten.dmk.lab>
References: <201007200007.o6K07Xbg028863@imap1.linux-foundation.org>
	<6182.1279658125@localhost>
	<20100720140751.71ee83a8.akpm@linux-foundation.org>
	<20100721091200.40c43158@schatten.dmk.lab>
Date: Thu, 22 Jul 2010 15:37:47 -0700
X-Google-Sender-Auth: iNs22MlKseQ1ldl9gFM6KNGg6sM
Message-ID: <AANLkTinc3=fd7j0v+6iCpLuvpskW5jbxKCDcScuX_EQy@mail.gmail.com>
Subject: Re: [PATCH] Re: mmotm 2010-07-19 - e1000e vs. pm_qos_update_request 
	issues
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Florian Mickler <florian@mickler.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        "Rafael J. Wysocki" <rjw@sisk.pl>, mark gross <markgross@thegnar.org>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 00:12, Florian Mickler <florian@mickler.org> wrote:
> On Tue, 20 Jul 2010 14:07:51 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> On Tue, 20 Jul 2010 16:35:25 -0400
>> Valdis.Kletnieks@vt.edu wrote:
>>
>> > On Mon, 19 Jul 2010 16:38:09 PDT, akpm@linux-foundation.org said:
>> > > The mm-of-the-moment snapshot 2010-07-19-16-37 has been uploaded to
>> > >
>> > >    http://userweb.kernel.org/~akpm/mmotm/
>> >
>> > Throws a warning at boot:
>> >
>> > [    1.786060] WARNING: at kernel/pm_qos_params.c:264 pm_qos_update_request+0x28/0x54()
>> > [    1.786088] Hardware name: Latitude E6500
>> > [    1.787045] pm_qos_update_request() called for unknown object
>> > [    1.787966] Modules linked in:
>> > [    1.788940] Pid: 1, comm: swapper Not tainted 2.6.35-rc5-mmotm0719 #1
>> > [    1.790035] Call Trace:
>> > [    1.791121]  [<ffffffff81037335>] warn_slowpath_common+0x80/0x98
>> > [    1.792205]  [<ffffffff810373e1>] warn_slowpath_fmt+0x41/0x43
>> > [    1.793279]  [<ffffffff81057c14>] pm_qos_update_request+0x28/0x54
>> > [    1.794347]  [<ffffffff8134889e>] e1000_configure+0x421/0x459
>> > [    1.795393]  [<ffffffff8134afbd>] e1000_open+0xbd/0x37c
>> > [    1.796436]  [<ffffffff8105743a>] ? raw_notifier_call_chain+0xf/0x11
>> > [    1.797491]  [<ffffffff8145f948>] __dev_open+0xae/0xe2
>> > [    1.798547]  [<ffffffff8145f997>] dev_open+0x1b/0x49
>> > [    1.799612]  [<ffffffff8146e36e>] netpoll_setup+0x84/0x259
>> > [    1.800685]  [<ffffffff81b5037c>] init_netconsole+0xbc/0x21f
>> > [    1.801744]  [<ffffffff81b5026c>] ? sir_wq_init+0x0/0x35
>> > [    1.802793]  [<ffffffff81b502c0>] ? init_netconsole+0x0/0x21f
>> > [    1.803845]  [<ffffffff810002ff>] do_one_initcall+0x7a/0x12f
>> > [    1.804885]  [<ffffffff81b2ccae>] kernel_init+0x138/0x1c2
>> > [    1.805915]  [<ffffffff81003554>] kernel_thread_helper+0x4/0x10
>> > [    1.806937]  [<ffffffff81590e00>] ? restore_args+0x0/0x30
>> > [    1.807955]  [<ffffffff81b2cb76>] ? kernel_init+0x0/0x1c2
>> > [    1.808958]  [<ffffffff81003550>] ? kernel_thread_helper+0x0/0x10
>> > [    1.809958] ---[ end trace 84b562a00a60539e ]---
>> >
>> > Looks like a repeat of something I reported against -mmotm 2010-05-11, though a
>> > WARNING rather than an outright crash - the traceback is pretty much identical.
>> >  I have *no* idea why -rc3-mmotm0701 doesn't whinge similarly.
>> >
>>
>> I don't recall you reporting that, sorry.
>>
>> The warning was added by
>>
>> : commit 82f682514a5df89ffb3890627eebf0897b7a84ec
>> : Author:     James Bottomley <James.Bottomley@suse.de>
>> : AuthorDate: Mon Jul 5 22:53:06 2010 +0200
>> : Commit:     Rafael J. Wysocki <rjw@sisk.pl>
>> : CommitDate: Mon Jul 19 02:00:34 2010 +0200
>> :
>> :     pm_qos: Get rid of the allocation in pm_qos_add_request()
>>
>>
>> It's a pretty crappy warning too.  Neither the warning nor the code
>> comments provide developers with any hint as to what they have done
>> wrong, nor what they must do to fix things.  And the patch changelog
>> doesn't mention the new warnings *at all*.
>>
>> So one must assume that the people who stuck this thing in the tree
>> have volunteered to fix e1000e.  Let's cc 'em.
>>
>
> e1000 calls update_request before registering said request with pm_qos.
> This was silently ignored before but now emits a warning. The warning
> is sound, because it means, that the constraint-request didn't take
> effect.
>
> The right thing is probably to register the request before
> calling update_request.
>
> Attached patch moves the registering from e1000_up to e1000_open and
> the unregistering from e1000_down to e1000_close.
> It is only compile-tested as I don't have the hardware.
>
> Cheers,
> Flo
>
> p.s.: sorry if this get's mangled or is wrongly formatted, i'm just using
>  the "insert file" option of my mailclient and crossing my fingers...
>
>
> From 693c71b911ff0845c872261d5704a1d40960722d Mon Sep 17 00:00:00 2001
> From: Florian Mickler <florian@mickler.org>
> Date: Wed, 21 Jul 2010 08:44:21 +0200
> Subject: [PATCH] e1000e: register pm_qos request on hardware activation
>
> The pm_qos_add_request call has to register the pm_qos request with the pm_qos
> susbsystem before first use of the pm_qos request via
> pm_qos_update_request.
>
> As pm_qos changed to use plists there is no benefit in registering and
> unregistering the pm_qos request on ifup/ifdown and thus we move the
> registering into e1000_open and the unregistering in e1000_close.
>
> This fixes the following warning:
>
> [    1.786060] WARNING: at kernel/pm_qos_params.c:264
> pm_qos_update_request+0x28/0x54()
> [    1.786088] Hardware name: Latitude E6500
> [    1.787045] pm_qos_update_request() called for unknown object
> [    1.787966] Modules linked in:
> [    1.788940] Pid: 1, comm: swapper Not tainted 2.6.35-rc5-mmotm0719 #1
> [    1.790035] Call Trace:
> [    1.791121]  [<ffffffff81037335>] warn_slowpath_common+0x80/0x98
> [    1.792205]  [<ffffffff810373e1>] warn_slowpath_fmt+0x41/0x43
> [    1.793279]  [<ffffffff81057c14>] pm_qos_update_request+0x28/0x54
> [    1.794347]  [<ffffffff8134889e>] e1000_configure+0x421/0x459
> [    1.795393]  [<ffffffff8134afbd>] e1000_open+0xbd/0x37c
> [    1.796436]  [<ffffffff8105743a>] ? raw_notifier_call_chain+0xf/0x11
> [    1.797491]  [<ffffffff8145f948>] __dev_open+0xae/0xe2
> [    1.798547]  [<ffffffff8145f997>] dev_open+0x1b/0x49
> [    1.799612]  [<ffffffff8146e36e>] netpoll_setup+0x84/0x259
> [    1.800685]  [<ffffffff81b5037c>] init_netconsole+0xbc/0x21f
> [    1.801744]  [<ffffffff81b5026c>] ? sir_wq_init+0x0/0x35
> [    1.802793]  [<ffffffff81b502c0>] ? init_netconsole+0x0/0x21f
> [    1.803845]  [<ffffffff810002ff>] do_one_initcall+0x7a/0x12f
> [    1.804885]  [<ffffffff81b2ccae>] kernel_init+0x138/0x1c2
> [    1.805915]  [<ffffffff81003554>] kernel_thread_helper+0x4/0x10
> [    1.806937]  [<ffffffff81590e00>] ? restore_args+0x0/0x30
> [    1.807955]  [<ffffffff81b2cb76>] ? kernel_init+0x0/0x1c2
> [    1.808958]  [<ffffffff81003550>] ? kernel_thread_helper+0x0/0x10
> [    1.809958] ---[ end trace 84b562a00a60539e ]---
>
> Signed-off-by: Florian Mickler <florian@mickler.org>
> ---
>  drivers/net/e1000e/netdev.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)
>

Thanks I have added the patch to my queue.

-- 
Cheers,
Jeff
