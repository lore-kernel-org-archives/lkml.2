Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab1ETWB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 18:01:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752702Ab1ETWBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 18:01:51 -0400
MIME-Version: 1.0
In-Reply-To: <4DD5369B.1010601@teksavvy.com>
References: <BANLkTikB37AvEgh1MAFBbYvFaxsL6W11OQ@mail.gmail.com> <4DD5369B.1010601@teksavvy.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 20 May 2011 15:00:59 -0700
Message-ID: <BANLkTim-u1_ixT517dWd-p4zXgaU=LLg1A@mail.gmail.com>
Subject: Re: Linux 2.6.39 -- *ERROR* Attempting to mmap a purgeable buffer
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 8:26 AM, Mark Lord <kernel@teksavvy.com> wrote:
>
> Just got weird stuff in the syslog this morning from rc7-git12:
>
> [43190.824700] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
> [43190.827426] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
> [43190.827506] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
> [43190.827568] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
> [43190.828685] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
> [43190.830498] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
> [43190.830603] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
> [43190.831055] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
> [43190.832580] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
> [43190.832788] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer

Quoting from an earlier mail about this issue from the DRM people:

  "Userspace is attempting to write to/read from a buffer it has
marked as being no longer required, so some rendering is going amiss.
And it does not rule out the possibility that at some point it will
catch the error later and result in a SIGBUS being sent to the
application (probably X).

  However since it is not a kernel error nor is it fatal, that and a
lot of similar messages can be demoted to debug."

So it's basically user space trying to access something stale, but it
should be harmless.

                     Linus
