Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195Ab1IUETl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 00:19:41 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:38151 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751098Ab1IUETk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 00:19:40 -0400
Date: Wed, 21 Sep 2011 09:47:59 +0530
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 9/9] drm/i915: Disable eDP VDD in a delayed
 work proc instead of synchronously
Message-ID: <20110921094759.22423597@jbarnes-x220>
In-Reply-To: <1316470923-27832-10-git-send-email-keithp@keithp.com>
References: <1316470923-27832-1-git-send-email-keithp@keithp.com>
	<1316470923-27832-10-git-send-email-keithp@keithp.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 192.55.60.111 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Sep 2011 15:22:03 -0700
Keith Packard <keithp@keithp.com> wrote:

> There's no good reason to turn off the eDP force VDD bit synchronously
> while probing devices; that just sticks a huge delay into all mode
> setting paths. Instead, queue a delayed work proc to disable the VDD
> force bit and then remember when that fires to ensure that the
> appropriate delay is respected before trying to turn it back on.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---

I'm worried this makes our PPS even more complex and hard to follow.
I'd rather see VDD AUX applied only when we need it (dpms, mode set and
detect; for hotplug we can assume the panel is alive) and that we
carefully disable it after waiting for a time after a full PPS on
sequence when doing a mode set or dpms on command.

Having all the power stuff at the highest levels would be clearest I
think.

Jesse
