Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030199Ab2CVGEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 02:04:13 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:36654 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab2CVGEM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 02:04:12 -0400
MIME-Version: 1.0
In-Reply-To: <1332198157-12307-1-git-send-email-daniel.vetter@ffwll.ch>
References: <CAF6AEGsXiJadKVeU+2z3zC8qLp+hmmY_6YYOL0XXYWV+p+h-+A@mail.gmail.com>
 <1332198157-12307-1-git-send-email-daniel.vetter@ffwll.ch>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Thu, 22 Mar 2012 11:33:50 +0530
Message-ID: <CAO_48GEpMUNOyTJbOQ0_Kwj8ym2O0iQrdk2E1McX5GeVCe8R2Q@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH] dma-buf: add support for kernel cpu access
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: linaro-mm-sig@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org, Rob Clark <rob.clark@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 March 2012 04:32, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> Big differences to other contenders in the field (like ion) is
> that this also supports highmem, so we have to split up the cpu
> access from the kernel side into a prepare and a kmap step.
>
> Prepare is allowed to fail and should do everything required so that
> the kmap calls can succeed (like swapin/backing storage allocation,
> flushing, ...).
>
> More in-depth explanations will follow in the follow-up documentation
> patch.
>
> Changes in v2:
>
> - Clear up begin_cpu_access confusion noticed by Sumit Semwal.
> - Don't automatically fallback from the _atomic variants to the
>  non-atomic variants. The _atomic callbacks are not allowed to
>  sleep, so we want exporters to make this decision explicit. The
>  function signatures are explicit, so simpler exporters can still
>  use the same function for both.
> - Make the unmap functions optional. Simpler exporters with permanent
>  mappings don't need to do anything at unmap time.
>
> Changes in v3:
>
> - Adjust the WARN_ON checks for the new ->ops functions as suggested
>  by Rob Clark and Sumit Semwal.
> - Rebased on top of latest dma-buf-next git.
>
> Changes in v4:
>
> - Fixup a missing - in a return -EINVAL; statement.
>
> Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Thanks; applied to for-next.
> ---
<snip>
BR,
~Sumit.
