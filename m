Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab0HCUhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 16:37:14 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60487 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757674Ab0HCUhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 16:37:12 -0400
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: Avi Kivity <avi@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: 2.6.35 hangs on early boot in KVM
References: <201008031028.57263.tvrtko.ursulin@sophos.com>
	<201008031557.04613.tvrtko.ursulin@sophos.com>
	<201008031617.21418.tvrtko.ursulin@sophos.com>
	<201008031659.58736.tvrtko.ursulin@sophos.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 03 Aug 2010 13:37:06 -0700
In-Reply-To: <201008031659.58736.tvrtko.ursulin@sophos.com> (Tvrtko Ursulin's message of "Tue\, 3 Aug 2010 16\:59\:58 +0100")
Message-ID: <m1k4o7l9fx.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tvrtko Ursulin <tvrtko.ursulin@sophos.com> writes:

> On Tuesday 03 Aug 2010 16:17:20 Tvrtko Ursulin wrote:
>> On Tuesday 03 Aug 2010 15:57:03 Tvrtko Ursulin wrote:
>> > On Tuesday 03 Aug 2010 15:51:08 Avi Kivity wrote:
>> > >   On 08/03/2010 12:28 PM, Tvrtko Ursulin wrote:
>> > > > I have basically built 2.6.35 with make oldconfig from a working
>> > > > 2.6.34. Latter works fine in kvm while 2.6.35 hangs very early. I see
>> > > > nothing after grub (have early printk and verbose bootup enabled),
>> > > > just a blinking VGA cursor and CPU at 100%.
>> > >
>> > > Please copy kvm@vger.kernel.org on kvm issues.
>> > >
>> > > > CONFIG_PRINTK_TIME=y
>> > >
>> > > Try disabling this as a workaround.
>> >
>> > I am in the middle of a bisect run with five builds left to go, currently
>> > I have:
>> >
>> > bad 537b60d17894b7c19a6060feae40299d7109d6e7
>> > good 93c9d7f60c0cb7715890b1f9e159da6f4d1f5a65
>>
>> Bisect is looking good, narrowed it to ten revisions, but I am not sure to
>> make it to the end today:
>>
>> bad cb41838bbc4403f7270a94b93a9a0d9fc9c2e7ea
>> good 41d59102e146a4423a490b8eca68a5860af4fe1c
>
> Bisect points the finger to "x86, ioapic: In mpparse use mp_register_ioapic"
> (cf7500c0ea133d66f8449d86392d83f840102632), so I am copying Eric. No idea
> whether this commit is solely to blame or it is a combined interaction with
> KVM, but I am sure you guys will know.
>
> If you want me to test something else please shout.

Interesting.  This is the second report I have heard of no VGA output
and a hang early in boot, that was bisected to this commit.  Since I
could not reproduce it I was hoping it was a fluke with a single piece
of hardware, but it appears not.

There was in fact an off by one bug in that commit, but if that had
been the issue 2.6.35 would have booted ok.  There was nothing in that
commit that should have prevented early output, and in fact I can boot
with a very similar configuration. So I am trying to figure out what
pieces are interacting to cause this failure mode to happen.

What version of kvm are you running on your host (in case that matters)?

I want to reproduce this myself so I can start guessing what weird
interactions are going on.

Eric
