Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965297Ab2CFW7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 17:59:42 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35040 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965280Ab2CFW7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 17:59:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of anton.vorontsov@linaro.org designates 10.204.152.27 as permitted sender) smtp.mail=anton.vorontsov@linaro.org
Date: Wed, 7 Mar 2012 02:59:37 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, leonid.moiseichuk@nokia.com,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] vmevent: Use 'struct vmevent_attr' for vmevent_fd() ABI
Message-ID: <20120306225937.GA24931@oksana.dev.rtsoft.ru>
References: <1331067079-2163-1-git-send-email-penberg@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1331067079-2163-1-git-send-email-penberg@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 10:51:19PM +0200, Pekka Enberg wrote:
> This patch introduces 'struct vmevent_attr' and converts the vmevent_fd() ABI
> to use it which makes the ABI much more flexible.
> 
> Originally-by: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
> Signed-off-by: Pekka Enberg <penberg@kernel.org>
> ---

Sorry for hijacking this thread, but speaking of big
changes. Are there any plans or ideas to add other methods
of sampling, i.e. something not timer-based?

I like how it's done for cgroups, i.e. via rate-limited events
(and the events are "page alloc/free").

But doing this cgroup-way would probably dismiss the point of
"lightweight" notifications.

Though, current vmevent seems not so lightweigh in sense of
battery usage and accuracy (i.e. how quick we're able to
detect the crossed threshold). To get better accuracy we
would need to run timer at higher frequencies, but then we
would waste more battery.

Sure, vmevent is still lightweight in sense that it does not
cause much runtime overhead or memory wastage (unlike cgroups).

The only idea I have for vmevent is to make some hybrid: timer
plus shrinker API. That way we would detect "low memory" events
fast enough via shrinker API, and thus run timer at low freq.

But we would still have a running timer, which would wake up
a system periodically, which is still quite bad. :-/

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
