Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab0HPE1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 00:27:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824Ab0HPE1t convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 00:27:49 -0400
MIME-Version: 1.0
In-Reply-To: <4C68B92B.3080406@myrealbox.com>
References: <AANLkTi=NFpeyo7Q31yMfqKSP2c-2OS2ccqa=Q9CQ8bpk@mail.gmail.com> <4C68B92B.3080406@myrealbox.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 15 Aug 2010 21:27:28 -0700
Message-ID: <AANLkTinfYBC0=DOzWaGD0DrGH8+M_rFRtuzHrM4yjRxx@mail.gmail.com>
Subject: Re: Intel graphics CPU usage - SDVO detect bogosity?
To: Andy Lutomirski <luto@myrealbox.com>
Cc: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        Zhao Yakui <yakui.zhao@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Adam Jackson <ajax@redhat.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 15, 2010 at 9:06 PM, Andy Lutomirski <luto@myrealbox.com> wrote:
>
> You might be hitting the infamous hotplug storm [1].  The symptoms vary by
> kernel version.

Hmm. I don't think it's a storm. The drm.debug=4 thing shows things
just every 10 seconds. That seems pretty controlled.

Of course, it seems to be several milliseconds worth of work then, so
it's not _too_ controlled. I must be missing some detail.

> If I'm right, the outputs of intel_bios_dumper and intel_bios_reader could
> be instructive (both are in intel-gpu-tools).

My version of intel-gpu-tools must be old (fedora 12). It has
intel_gpu_dump and intel_reg_write and some other apps, but not the
bios-dumper/reader.

Not that I could read the output of them anyway, I bet ;)

> You could also try intel_reg_write 0x61110 0x0 and see if the problem stops
> (at least until a suspend/resume cycle).  That command turns off output
> hotplug on the card, which has the side effect that the kernel will stop
> acting on bogus interrupts.

  # intel_reg_write 0x61110 0x0
  Value before: 0x4000220
  Value after: 0x0

but it doesn't seem to change any behavior. Still that sdvo probe
every 10 s, and still 1% of CPU for kworker in top. But that kworker
thing definitely has to be separate from the 10-second sdvo probe,
because it shows up all the time (ie top updates every second).

But right now the wife is using that machine, so I can't check the "it
should be totally idle, what the heck is going on" behavior at the
moment.

                Linus


                          Linus
