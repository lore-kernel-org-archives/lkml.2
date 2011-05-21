Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab1EUB5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 21:57:14 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:17489 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755850Ab1EUB5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 21:57:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAOAa101Ld/sX/2dsb2JhbAAMhFDVFpB5gSuDZ4EHBJ8i
X-IronPort-AV: E=Sophos;i="4.65,245,1304308800"; 
   d="scan'208";a="114381760"
Message-ID: <4DD71BF3.5030906@teksavvy.com>
Date: Fri, 20 May 2011 21:57:07 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: Linux 2.6.39 -- *ERROR* Attempting to mmap a purgeable buffer
References: <BANLkTikB37AvEgh1MAFBbYvFaxsL6W11OQ@mail.gmail.com> <4DD5369B.1010601@teksavvy.com> <BANLkTim-u1_ixT517dWd-p4zXgaU=LLg1A@mail.gmail.com>
In-Reply-To: <BANLkTim-u1_ixT517dWd-p4zXgaU=LLg1A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-05-20 06:00 PM, Linus Torvalds wrote:
> On Thu, May 19, 2011 at 8:26 AM, Mark Lord <kernel@teksavvy.com> wrote:
>>
>> Just got weird stuff in the syslog this morning from rc7-git12:
>>
>> [43190.824700] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
>> [43190.827426] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
>> [43190.827506] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
>> [43190.827568] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
>> [43190.828685] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
>> [43190.830498] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
>> [43190.830603] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
>> [43190.831055] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
>> [43190.832580] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
>> [43190.832788] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
> 
> Quoting from an earlier mail about this issue from the DRM people:
> 
>   "Userspace is attempting to write to/read from a buffer it has
> marked as being no longer required, so some rendering is going amiss.
> And it does not rule out the possibility that at some point it will
> catch the error later and result in a SIGBUS being sent to the
> application (probably X).
> 
>   However since it is not a kernel error nor is it fatal, that and a
> lot of similar messages can be demoted to debug."
> 
> So it's basically user space trying to access something stale, but it
> should be harmless.

Peachy.  I suspect the messages get generated when I run gmplayer or vlc
(not sure which, don't really care much either).

Thanks.
