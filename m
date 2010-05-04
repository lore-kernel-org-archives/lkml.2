Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab0EDAnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 20:43:45 -0400
Received: from smtp-out.google.com ([74.125.121.35]:53441 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab0EDAno convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 20:43:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Py6Ux/ZEASvTHyPtSdwD01nKH0hMJ+QqyeW6qb9SKPKQlIzefj+wnY6dKMecz85uz
	V90TtqP6XzrBsVH+bkJqw==
MIME-Version: 1.0
In-Reply-To: <s2qd6200be21005031709r28420f0ezf3cf286517ee9114@mail.gmail.com>
References: <1272667021-21312-1-git-send-email-arve@android.com>
	 <87wrvl5479.fsf@deeprootsystems.com>
	 <20100503180741.GB2098@rakim.wolfsonmicro.main>
	 <201005032318.35383.rjw@sisk.pl> <87sk68r1zh.fsf@deeprootsystems.com>
	 <s2qd6200be21005031709r28420f0ezf3cf286517ee9114@mail.gmail.com>
Date: Mon, 3 May 2010 17:43:34 -0700
Message-ID: <w2pa55d774e1005031743x859e82fz401346fae7fe873a@mail.gmail.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
From: Brian Swetland <swetland@google.com>
To: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 3, 2010 at 5:09 PM, Arve Hjønnevåg <arve@android.com> wrote:
> On Mon, May 3, 2010 at 4:37 PM, Kevin Hilman
>>
>> In addition, it will likely cause duplicate work to be done in
>> drivers.  Presumably, PM aware drivers will want to know if the system
>> is in opportunistic mode.  For example, for many drivers, doing
>> runtime PM may not be worth the effort if the system is in
>> opportunistic mode.
>
> Why? If a device is not in use it should be off regardless of what
> state the rest of the system is in.
>
>> This last point is especially troubling.  I don't find it a comforting
>> path to go down if the drivers have to start caring about which PM
>> policy is currently in use.

I'll echo Arve here -- all drivers should seek to be in the lowest
power state possible at all times.  We've never suggested that
suspend_block is a substitute for that.

Suspend blockers give us some flexibility on systems where runtime pm
will not get us all the way there. If you can meet your power needs
without needing suspend blockers, awesome, you don't need them on that
platform.  The patchset Arve sent out makes this feature an
off-by-default kernel configuration option that compiles out to no-ops
when disabled.

In our experience, periodic timers and polling, both userspace side
and kernelside make suspend blockers a win even on platforms like OMAP
which have pretty flexible hardware power management.  Going to low
power states in idle results in higher average power consumption than
going to the same states in full suspend, at least on Android devices
shipping today.

Brian
