Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab2DSQaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 12:30:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62445 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab2DSQaD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 12:30:03 -0400
MIME-Version: 1.0
In-Reply-To: <1334852525-14950-1-git-send-email-apw@canonical.com>
References: <1334852525-14950-1-git-send-email-apw@canonical.com>
Date: Thu, 19 Apr 2012 17:30:03 +0100
Message-ID: <CAPM=9tzWO46u5L1jnRvi_zhgOhmzH1df7cQTnP6+0Kh4Znpn7g@mail.gmail.com>
Subject: Re: [PATCH 0/1] [RFC] DRM locking issues during early open
From: Dave Airlie <airlied@gmail.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bryce Harrington <bryce@canonical.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 5:22 PM, Andy Whitcroft <apw@canonical.com> wrote:
> We have been carrying a (rather poor) patch for an issue we identified in
> the DRM driver.  This issue is triggered when a DRM device is initialising
> and userspace attempts to open it, typically in response to the sysfs
> device added event.  Basically we allocate the minor numbers making
> the device available, and then call the drm load callback.  Until this
> completes the device is really not ready and these early opens typically
> lead to oopses.
>
> We have been using the following patch to avoid this by marking the minors
> as in error until the load method has completed.  This avoids the early
> open by simply erroring out the opens with EAGAIN.  Obviously we should
> be delaying the open until the load method complete.
>
> I include the existing patch for completness (it is not really ready for
> merging) to illustrate the issue.  I think it is logical that the wait
> should simply be delayed until the load has completed.  I am proposing
> to include a wait queue associated with the idr cache for the drm minors
> which we can use to allow open callers to wait_event_interruptible() on.
> I'll be putting together a prototype shortly and will follow up with it.
>
> Thoughts?

Couldn't we just delay registering things until the driver is ready to
accept an open?

Granted the midlayer of drm doesn't make that easy,

thanks for sending this out, it keeps falling off my radar, I don't
think I've ever seen this reported on RHEL/Fedora, which makes me
wonder what we are doing that makes us lucky.

Dave.
