Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab1GZTMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 15:12:35 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:51968 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751361Ab1GZTMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 15:12:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ajTpZHG7pTYsdeenx3KhiBxlkXYpbXf4blCNVJ4i7aH2wydQIVLCEBtL6XWHrq9jf4sLTKJzjRvXWRR2QF2aRDsK/k+UjCCCx5PxzWgIwW0MNEaZYw0aOyW5azswfO7Y;
Date: Tue, 26 Jul 2011 12:12:25 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Dave Airlie <airlied@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Hold struct_mutex during hotplug
 processing
Message-ID: <20110726121225.3ae7acce@jbarnes-desktop>
In-Reply-To: <yunsjpt2hi6.fsf@aiko.keithp.com>
References: <1311613829-4990-1-git-send-email-keithp@keithp.com>
	<CAKMK7uHO1jqUNrnqC9sd=JJ9Vr=hmAjnJ06eDYxfeyTTFAMK1w@mail.gmail.com>
	<yunsjpt2hi6.fsf@aiko.keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jul 2011 08:23:13 -0700
Keith Packard <keithp@keithp.com> wrote:

> On Tue, 26 Jul 2011 09:24:39 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:
> > Two things I've noticed:
> 
> > - Why not dev->mode_config.mutex?
> 
> You're right, of course. I noticed that just after posting that version
> and updated it; the updated version is on my drm-intel-fixes branch
> already (having been reviewed by Jesse).
> 
> > - And a nitpick: Why the dev_priv->dev indirection, when dev is
> > already lying around?
> 
> All nicely cleaned up by using &mode_config->mutex instead :-)
> 
> Thanks for looking it over!

I'd like to amend my reviewed by and say the lock shouldn't be held
around the call to the drm helper function.  It queues some work that
also takes the mode config lock, which will break.  So you can drop it
before that...  Previously I had only checked our internal driver
callbacks but missed that the lock was held across the helper too.

-- 
Jesse Barnes, Intel Open Source Technology Center
