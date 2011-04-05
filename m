Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab1DEOMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 10:12:00 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38376 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab1DEOL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:11:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=CbAgSkJNByeX2apOfyzlZCkovaywplrvBo3mhaT9/n4v0Cd7N+mWrpRDZ/qD4Ds42i
         6Frb5R1IQp7eS+ETwlnGlwNaLJ+SihwAg8i0zS0VBDq9FVbkqHZwJznK+yHAZif71vj/
         0ypqXWEyzWT0HU49us/1CtscarltVEnjSINUg=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=kXod21RUukrTuMzP5TFqgo4NxRw@mail.gmail.com>
References: <AANLkTi=VqkYjdiDLJvM-OfmBSGx-EkRkt=4XCDEnvZsU@mail.gmail.com>
	<1301395589-8121-1-git-send-email-chris@chris-wilson.co.uk>
	<20110401114429.GA3526@viiv.ffwll.ch>
	<AANLkTik6njOQTLGsB4KzPP-J=fE=p4CHopAyvsDzdDSF@mail.gmail.com>
	<BANLkTimUZY+2E=kXG-as8-moAAS4+F5bTg@mail.gmail.com>
	<b7da2f$qvoau5@fmsmga001.fm.intel.com>
	<BANLkTi=kXod21RUukrTuMzP5TFqgo4NxRw@mail.gmail.com>
Date: Tue, 5 Apr 2011 17:11:56 +0300
X-Google-Sender-Auth: NA2PZTWj8WIdflOJL_d3uYL7X6I
Message-ID: <BANLkTins76X1mOFepqXEQjMEh_hd4Vgw1Q@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Disable all outputs early, before
 KMS takeover
From: Pekka Enberg <penberg@kernel.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tomas Winkler <tomasw@gmail.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 5, 2011 at 1:37 PM, Pekka Enberg <penberg@kernel.org> wrote:
> Hi Chris!
>
> On Tue, Apr 5, 2011 at 1:30 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> On Tue, 5 Apr 2011 13:21:08 +0300, Tomas Winkler <tomasw@gmail.com> wrote:
>>> On Fri, Apr 1, 2011 at 2:51 PM, Pekka Enberg <penberg@kernel.org> wrote:
>>> > Unfortunately I get a blank screen with after boot:
>>> > Nacked-by: Pekka Enberg <penberg@kernel.org>
>>
>> But until you can tell me where it explodes on your system, we fix
>> issues on several other machines...
>
> Oh, that's nice, you first made the damn thing flicker in 2.6.39-rc1
> and now you're fixing it for others by giving me a blank screen after
> boot?

I compiled i195 drm as module and I now see this with netconsole:

[    4.861272] i8042: No controller found
[    5.260688] Unable to load isight firmware
[    7.120150] usbhid 5-1:1.0: couldn't find an input interrupt endpoint

[    9.310010]
[    9.310010] Pid: 3757, comm: sh Not tainted 2.6.38+ #18 Apple Inc.
MacBook2,1/Mac-F4208CAA
[    9.310010] RIP: 0010:[<0000000000000000>]  [<          (null)>]
       (null)
[    9.310010] RSP: 0018:ffff88003de03d80  EFLAGS: 00010096
[    9.310010] RAX: 000000000000006d RBX: ffff88002e6be000 RCX: 000000000003ffff
[    9.310010] RDX: 0000000000000000 RSI: 0000000000000046 RDI: ffff88002e6be030
[    9.310010] RBP: ffff88003de03de8 R08: 0000000000000000 R09: 0000000000000000
[    9.310010] R10: 0000000000000006 R11: 0000000000000003 R12: ffff88002e5db800
[    9.310010] R13: ffff88002e6be82c R14: ffff88003ad24200 R15: 0000000000000000
[    9.310010] FS:  00007f60f21aa700(0000) GS:ffff88003de00000(0000)
knlGS:0000000000000000
[    9.310010]  [<ffffffffa0061628>] ? i915_handle_error+0x198/0xed0 [i915]
[    9.310010]  [<ffffffff8137d04a>] ? scsi_next_command+0x4a/0x60
[    9.310010]  [<ffffffff8137ddd6>] ? scsi_io_completion+0x2f6/0x630
[    9.310010]  [<ffffffffa0064c62>] i915_driver_irq_handler+0x472/0x17f0 [i915]
[    9.310010]  [<ffffffff810e150d>] handle_irq_event_percpu+0x5d/0x210
[    9.310010]  [<ffffffff8108c56c>] ? __do_softirq+0x11c/0x200
[    9.310010]  [<ffffffff8108c56c>] ? __do_softirq+0x11c/0x200
[    9.310010]  [<ffffffff810e173a>] handle_irq_event+0x4a/0x80
[    9.310010]  [<ffffffff810e42c1>] handle_fasteoi_irq+0x51/0xc0
[    9.310010]  [<ffffffff8103e3a2>] handle_irq+0x22/0x30
[    9.310010]  [<ffffffff81698e0d>] do_IRQ+0x5d/0xe0
[    9.310010]  [<ffffffff8168fad3>] common_interrupt+0x13/0x13
[    9.310010]  <EOI> [    9.310010] Call Trace:
[    9.310010]  <IRQ>  [<ffffffff8168cd0c>] panic+0x91/0x19e
[    9.310010]  [<ffffffff816909ea>] oops_end+0xea/0xf0
[    9.310010]  [<ffffffff8106afbb>] no_context+0xfb/0x260
[    9.310010]  [<ffffffff8106b245>] __bad_area_nosemaphore+0x125/0x1e0
[    9.310010]  [<ffffffff8106b313>] bad_area_nosemaphore+0x13/0x20
[    9.310010]  [<ffffffff816930c0>] do_page_fault+0x310/0x4c0
[    9.310010]  [<ffffffff810ac06f>] ? up+0x2f/0x50
[    9.310010]  [<ffffffff8108652f>] ? console_unlock+0x17f/0x1d0
[    9.310010]  [<ffffffff8168fd25>] page_fault+0x25/0x30
[    9.310010]  [<ffffffffa0061628>] ? i915_handle_error+0x198/0xed0 [i915]
[    9.310010]  [<ffffffff8137d04a>] ? scsi_next_command+0x4a/0x60
[    9.310010]  [<ffffffff8137ddd6>] ? scsi_io_completion+0x2f6/0x630
[    9.310010]  [<ffffffffa0064c62>] i915_driver_irq_handler+0x472/0x17f0 [i915]

This is the same pre-2.6.39-rc1 kernel with the two patches applied.
I'll try latest Linus master next to see if the same problem triggers.

                        Pekka
