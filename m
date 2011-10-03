Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624Ab1JCVNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 17:13:07 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:50217 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757277Ab1JCVM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 17:12:58 -0400
Date: Mon, 3 Oct 2011 14:12:47 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Dave Airlie <airlied@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 9/9] drm/i915: Initialize PCH refclks at
 modeset init time
Message-ID: <20111003141247.76038b31@jbarnes-desktop>
In-Reply-To: <yunoby597o2.fsf@aiko.keithp.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com>
	<1317103906-4649-1-git-send-email-keithp@keithp.com>
	<1317103906-4649-10-git-send-email-keithp@keithp.com>
	<e0d58a$1mfht8@orsmga002.jf.intel.com>
	<yunoby597o2.fsf@aiko.keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Sep 2011 11:11:57 -0700
Keith Packard <keithp@keithp.com> wrote:

> On Tue, 27 Sep 2011 17:56:39 +0100, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> 
> > Ah, now I see why we moved from using the active configuration earlier. ;-)
> 
> My evil plan is revealed!
> 
> > Doesn't this prevent us from ever using SSC though, as virtually every
> > single PCH machine has HDMI encoders that haven't been masked out through
> > the chicken fuses or VBT?
> 
> That wasn't my intent -- the SSC source gets modulated whenever the VBT
> table says it can, so when the panel uses the SSC source, it will get
> SSC. Did I mess something up here? Or is it just some interaction with
> the mode setting code that I didn't get right?

Assuming we're selecting the proper reference clock in the PLL
selection code anyway...

Doing it all up front seems nicer; did you get confirmation that the
"wavy VGA" bug was fixed with this series?  Overall seems like a good
improvement over our old PCH refclk code...

-- 
Jesse Barnes, Intel Open Source Technology Center
