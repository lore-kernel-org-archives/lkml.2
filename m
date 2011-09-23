Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357Ab1IWDW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 23:22:59 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:54632 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750980Ab1IWDW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 23:22:56 -0400
Date: Fri, 23 Sep 2011 08:52:43 +0530
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 9/9] drm/i915: Disable eDP VDD in a delayed
 work proc instead of synchronously
Message-ID: <20110923085243.6e4b7b4c@jbarnes-x220>
In-Reply-To: <yunsjnqfqga.fsf@aiko.keithp.com>
References: <1316470923-27832-1-git-send-email-keithp@keithp.com>
	<1316470923-27832-10-git-send-email-keithp@keithp.com>
	<20110921094759.22423597@jbarnes-x220>
	<yunsjnqfqga.fsf@aiko.keithp.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 192.55.60.111 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011 21:51:33 -0700
Keith Packard <keithp@keithp.com> wrote:
> Yes, making it cleaner would help a ton. There are some basic problems
> with the DRM API that make this hard though -- intel_dp_prepare may
> not ever be followed by a call to intel_dp_commit. That's why I had
> the VDD AUX stuff get turned off by a delayed work proc instead.
> 
> Also, leaving VDD AUX high after EDID is fetched means that we can
> start the mode setting immediately, rather than having to wait for the
> power-off/power-on delay (which is really long).

Yeah agreed.  

> What we could do is force VDD AUX off after the panel gets turned on;
> that would ensure that turning the panel off would actually turn the
> power off, rather than having VDD stay high for some time after that.

Yep, that sounds great.

Thanks,
Jesse
