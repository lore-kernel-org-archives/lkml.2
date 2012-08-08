Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab2HHGgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 02:36:09 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60661 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab2HHGgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 02:36:07 -0400
MIME-Version: 1.0
In-Reply-To: <502162D7.9090809@canonical.com>
References: <20120807175330.18745.81293.stgit@patser.local> <502162D7.9090809@canonical.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Wed, 8 Aug 2012 12:05:45 +0530
Message-ID: <CAO_48GGmo65yT9UeJk69f-ASir3E+SWMsOJXgN4M_-UyO3XqUA@mail.gmail.com>
Subject: Re: [PATCH 1/3] dma-fence: dma-buf synchronization (v7)
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: rob.clark@linaro.org, linaro-mm-sig@lists.linaro.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maarten,

On 8 August 2012 00:17, Maarten Lankhorst
<maarten.lankhorst@canonical.com> wrote:
> Op 07-08-12 19:53, Maarten Lankhorst schreef:
>> A dma-fence can be attached to a buffer which is being filled or consumed
>> by hw, to allow userspace to pass the buffer without waiting to another
>> device.  For example, userspace can call page_flip ioctl to display the
>> next frame of graphics after kicking the GPU but while the GPU is still
>> rendering.  The display device sharing the buffer with the GPU would
>> attach a callback to get notified when the GPU's rendering-complete IRQ
>> fires, to update the scan-out address of the display, without having to
>> wake up userspace.

Thanks for this patchset; Could you please also fill up
Documentation/dma-buf-sharing.txt, to include the relevant bits?

We've tried to make sure the Documentation corresponding is kept
up-to-date as the framework has grown, and new features are added to
it - and I think features as important as dma-fence and dmabufmgr do
warrant a healthy update.
>
> I implemented this for intel and debugged it with intel <-> nouveau
> interaction. Unfortunately the nouveau patches aren't ready at this point,
> but the git repo I'm using is available at:
>
> http://cgit.freedesktop.org/~mlankhorst/linux/
>
> It has the patch series and a sample implementation for intel, based on
> drm-intel-next tree.
>
> I tried to keep it deadlock and race condition free as much as possible,
> but locking gets complicated enough that if I'm unlucky something might
> have slipped through regardless.
>
> Especially the locking in i915_gem_reset_requests, is screwed up.
> This shows what a real PITA it is to abort callbacks prematurely while
> keeping everything stable. As such, aborting requests should only be done
> in exceptional circumstances, in this case hardware died and things are
> already locked up anyhow..
>
> ~Maarten
>

-- 
Thanks and best regards,
Sumit Semwal
