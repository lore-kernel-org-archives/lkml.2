Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab1G0QDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:03:44 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:42134 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753452Ab1G0QDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:03:42 -0400
Date: Wed, 27 Jul 2011 09:03:31 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Dave Airlie <airlied@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Hold struct_mutex during hotplug
 processing
Message-ID: <20110727090331.60e0c5be@jbarnes-desktop>
In-Reply-To: <yunk4b43wq3.fsf@aiko.keithp.com>
References: <1311613829-4990-1-git-send-email-keithp@keithp.com>
	<CAKMK7uHO1jqUNrnqC9sd=JJ9Vr=hmAjnJ06eDYxfeyTTFAMK1w@mail.gmail.com>
	<yunsjpt2hi6.fsf@aiko.keithp.com>
	<20110726121225.3ae7acce@jbarnes-desktop>
	<yunk4b43wq3.fsf@aiko.keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jul 2011 02:21:24 -0700
Keith Packard <keithp@keithp.com> wrote:

> On Tue, 26 Jul 2011 12:12:25 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> > I'd like to amend my reviewed by and say the lock shouldn't be held
> > around the call to the drm helper function.  It queues some work that
> > also takes the mode config lock, which will break.  So you can drop it
> > before that...  Previously I had only checked our internal driver
> > callbacks but missed that the lock was held across the helper too.
> 
> So the work may get executed immediately rather than being run later at
> some point?

It sure looks that way... but I don't remember any rule about work
queue items having inter dependencies like this.

-- 
Jesse Barnes, Intel Open Source Technology Center
