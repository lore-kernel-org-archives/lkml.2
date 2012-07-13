Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030872Ab2GMSwD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 14:52:03 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55144 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932362Ab2GMSwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 14:52:00 -0400
MIME-Version: 1.0
In-Reply-To: <50005dfd.25f2440a.6e6b.ffffbcd9SMTPIN_ADDED@mx.google.com>
References: <1342193911-16157-1-git-send-email-rob.clark@linaro.org>
	<50005dfd.25f2440a.6e6b.ffffbcd9SMTPIN_ADDED@mx.google.com>
Date: Fri, 13 Jul 2012 13:52:00 -0500
X-Google-Sender-Auth: __iTEdu_yfkjT3YV_LgCxozIPiE
Message-ID: <CAF6AEGvP1+7BKo7+oCj4XBBw32NPjrH5EAZuodu2zb8oiyVP_Q@mail.gmail.com>
Subject: Re: [RFC] dma-fence: dma-buf synchronization (v2)
From: Rob Clark <rob.clark@linaro.org>
To: Tom Cooksey <tom.cooksey@arm.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, patches@linaro.org,
        daniel.vetter@ffwll.ch, linux-kernel@vger.kernel.org,
        maarten.lankhorst@canonical.com, sumit.semwal@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 12:35 PM, Tom Cooksey <tom.cooksey@arm.com> wrote:
> My other thought is around atomicity. Could this be extended to
> (safely) allow for hardware devices which might want to access
> multiple buffers simultaneously? I think it probably can with
> some tweaks to the interface? An atomic function which does
> something like "give me all the fences for all these buffers
> and add this fence to each instead/as-well-as"?

fwiw, what I'm leaning towards right now is combining dma-fence w/
Maarten's idea of dma-buf-mgr (not sure if you saw his patches?).  And
let dmabufmgr handle the multi-buffer reservation stuff.  And possibly
the read vs write access, although this I'm not 100% sure on... the
other option being the concept of read vs write (or
exclusive/non-exclusive) fences.

In the current state, the fence is quite simple, and doesn't care
*what* it is fencing, which seems advantageous when you get into
trying to deal with combinations of devices sharing buffers, some of
whom can do hw sync, and some who can't.  So having a bit of
partitioning from the code dealing w/ sequencing who can access the
buffers when and for what purpose seems like it might not be a bad
idea.  Although I'm still working through the different alternatives.

BR,
-R
