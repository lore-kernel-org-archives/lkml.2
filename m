Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab2AER6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 12:58:47 -0500
Received: from 184-106-247-128.static.cloud-ips.com ([184.106.247.128]:60482
	"EHLO cloud01.chad-versace.us" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754282Ab2AER6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 12:58:46 -0500
X-Spam-Flag: NO
X-Spam-Score: -1
Message-ID: <4F05E4CC.1040705@bwidawsk.net>
Date: Thu, 05 Jan 2012 09:58:36 -0800
From: Ben Widawsky <ben@bwidawsk.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111224 Thunderbird/9.0.1
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>, "Airlie, Dave" <airlied@linux.ie>,
        Intel drivers <Intel-gfx@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PULL] drm-intel-next
References: <86y5tmkeia.fsf@sumi.keithp.com> <20120105152408.GD3831@phenom.ffwll.local>
In-Reply-To: <20120105152408.GD3831@phenom.ffwll.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2012 07:24 AM, Daniel Vetter wrote:
> On Wed, Jan 04, 2012 at 07:35:41PM -0800, Keith Packard wrote:
>>
>> Here are the rest of the 3.3 pending changes.
>>
>> This has a bunch of small bug fixes and overlay plane support for i915.
>>
>> The following changes since commit 7a7e8734ac3235efafd34819b27fbdf5417e6d60:
>>
>>    Merge branch 'drm-radeon-testing' of ../drm-radeon-next into drm-core-next (2012-01-03 09:45:12 +0000)
>>
>> are available in the git repository at:
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/keithp/linux drm-intel-next
>
> I'm not happy with Eric's missed IRQ workaround because
> - it's incomplete, the BSD ring is similarly affected by these issues like
>    the blitter ring, but not handled by his patches.
> - it does a busy-loop wait until the gpu signals completion - in normal
>    useage this can easily be a few msecs, especially since now semaphores
>    are enabled by defailt on Ivybridge. With offscreen benchmarking it can
>    easily reach seconds. This is imo unacceptable.
>
> Furthermore
> - Chris Wilson proposed an alternative approach quite a bit before these
>    patches have been created that combines the irq signalling path with a
>    short timer as a backup. This works really well because we only rarely
>    miss irqs. See
>    Message-Id:<1323978198-3501-1-git-send-email-chris@chris-wilson.co.uk>
> - Meanwhile I've discovered a magic set of tricks that seem to completely
>    solve missed irq issues on both ivb and snb. This would render all this
>    ducttape irrelevant.
>
> Imo the minimal right thing to do is to revert the patch "drm/i915: Make
> the fallback IRQ wait not sleep". This will regress piglit throughput (and
> anything else stupid enough to crazily ping-pong between the gpu and cpu)
> quite a bit, but honestly that's not something our userbase cares about.
>
> I'd also like to express my frustration with the general -next process for
> drm/i915:
> - This drm-intel-next tree is less than 24h ours old (if you look at when
>    it showed up at an official place where both our QA and the community
>    can pick it up and test it). I fear we'll ship yet another disaster like
>    the stack eating bug the vt-d/ilk w/a patch caused with an unbounded
>    recursion. Our QA actually caught it in testing, but there was simply
>    not enough time to fix things up before the buggy code landed in -linus.
> - Because the drm-intel-next merge cycle started so late there has simply
>    not been enough time to include quite a few bugfixes for serious issues
>    like 20s delays in intial modeset, userspace-triggerable kernel OOPSes
>    and deadlocks and reproducible hard hw hangs. For most of these there
>    are testcases in intel-gpu-tools, and these issues span the entire set
>    of hw generations drm/i915 currently supports. But this late it's imo
>    no longer advisible to merge them, so we'll ship 3.3 with a bunch of
>    known (and sometimes longstanding) serious issues that have fixes.
>
> Yours, Daniel

I'd like to echo my concerns regarding late merging and therefore lack 
of QA testing. I ended up looking like quite the fool last time around, 
and that would have been prevented with QA testing of intel-gpu-tools.

