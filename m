Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab1AUIfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 03:35:45 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50377 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab1AUIfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 03:35:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=lDSiF/ACZ5VfmciIhPefuOdsLwYNcoIwY0RNrq1OLHM/7atvnFZlU3FVgO5eMV7HgA
         B2r/Wv2yN7gp5ortCB0UdwbwXcbs2uHbbpHGsR0QtBWgyuMR4qO+8jO3pjTsZ3AEFCtf
         jPPUn12kIXl7Yy+qUBR3exvvpONnoDpEelc5M=
Message-ID: <4D39455D.4070808@gmail.com>
Date: Fri, 21 Jan 2011 09:35:41 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: Dave Airlie <airlied@linux.ie>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915/ringbuffer: Fix use of stale HEAD position whilst
 polling for space
References: <AANLkTi=AEhztUp30A0o5YxHCqqLg38+f5s+mXfbZTX8Y@mail.gmail.com> <1295545279-21335-1-git-send-email-chris@chris-wilson.co.uk>
In-Reply-To: <1295545279-21335-1-git-send-email-chris@chris-wilson.co.uk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2011 06:41 PM, Chris Wilson wrote:
> During suspend, Linus found that his machine would hang for 3 seconds,
> and identified that intel_ring_buffer_wait() was the culprit:

FWIW works for me. From 4s I'm back to:
PM: suspend of devices complete after 1087.670 msecs

BTW I did this change as there are loops running out of bounds of this
array added in 1ec14ad3.
--- a/drivers/gpu/drm/i915/intel_ringbuffer.h
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.h
@@ -52,7 +52,7 @@ struct  intel_ring_buffer {

        u32             irq_seqno;              /* last seq seem at irq
time */
        u32             waiting_seqno;
-       u32             sync_seqno[I915_NUM_RINGS-1];
+       u32             sync_seqno[I915_NUM_RINGS];
        atomic_t        irq_refcount;
        bool __must_check (*irq_get)(struct intel_ring_buffer *ring);
        void            (*irq_put)(struct intel_ring_buffer *ring);

thanks,
-- 
js
