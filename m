Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449Ab0EEMAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 08:00:39 -0400
Received: from smtp-out.google.com ([74.125.121.35]:37555 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234Ab0EEMAi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 08:00:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=echWs7NrfMgnqLTpPyeX0qSk0R7fB6nvQ4co4i49skJxxcNXf5n6oHDpItdzPcZS9
	QFt9HUh+L1K2F+eXyjx3w==
MIME-Version: 1.0
In-Reply-To: <20100505110630.GA5754@opensource.wolfsonmicro.com>
References: <1272667021-21312-1-git-send-email-arve@android.com>
	 <201005042223.41370.rjw@sisk.pl>
	 <20100504235644.GA5231@opensource.wolfsonmicro.com>
	 <201005050222.31038.rjw@sisk.pl>
	 <20100505110630.GA5754@opensource.wolfsonmicro.com>
Date: Wed, 5 May 2010 05:00:33 -0700
Message-ID: <j2xa55d774e1005050500ocaa77b0di8e9eb58ce9c82d58@mail.gmail.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
From: Brian Swetland <swetland@google.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
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

On Wed, May 5, 2010 at 4:06 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, May 05, 2010 at 02:22:30AM +0200, Rafael J. Wysocki wrote:
>> On Wednesday 05 May 2010, Mark Brown wrote:
>
>> > On a mobile phone when the system is in a voice call the data flow for
>> > the call is entirely handled outside the CPU (normally referred to as
>> > Applications Processor or AP here) by the baseband and audio CODEC,
>
>> In that case someone (either a driver or, most likely, user space) will need to
>> keep a suspend blocker active.
>
> That is not actually what Android systems are doing, and if it is what's
> supposed to happen then I'd really expect to see a patch to ASoC as part
> of this series which shows how this is supposed to be integrated - it's
> the sort of thing I'd expect to see some kernel space management for.
>
> Honestly I don't think that's a very good solution for actual systems,
> though.  A part of the reasoning behind designing systems in this way is
> allowing the AP to go into the lowest possible power state while on a
> voice call so it doesn't seem at all unreasonable for the system
> integrator to expect that the AP will be driven into the standard low
> power state the system uses for it during a call and in a system using
> opportunistic suspend that's suspend mode.

Yup.  And that's exactly what happens on the platforms we've shipped
on so far -- the apps side of the world fully suspends while in a
voice call.  Some events (prox sensor, buttons, modem sending a state
notification) will wake it up, of course.

I haven't spent much time looking at alsa/asoc yet, but it's on my
list for 2010 -- I'm hoping to migrate the very simple audio drivers I
wrote for the msm platform originally to actually be alsa drivers as
part of the general "try to use existing interfaces if they fit" plan
we've been working toward.

The suspend_block system gets us what we need today (well what we
needed three years ago too!) to ship and hit reasonable power targets
on a number of platforms.  There's been a lot of various handwaving
about "android kernel forks" and what have you, but here we are again,
trying to work out perhaps the only "new subsystem" type change that
our driver code depends on (almost all other contentious stuff is self
contained and you can take or leave it).

Our hope here is to get something out there in the near term so that
the various drivers we maintain would "just work" in mainline (your
choice of if you use suspend_block or not -- it's designed to be an
option) and we can move forward.  If in the future runtime power
management or other systems completely obsolete suspend_blockers,
awesome, we remove 'em.

Brian
