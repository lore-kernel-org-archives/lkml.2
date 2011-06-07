Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab1FGAY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 20:24:26 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:48196 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753090Ab1FGAYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 20:24:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=LwIVMExC3fOnslLH2waxaUZbitXFtVpSH45P8gVPrrwJn2oLqYMrAJYv9z5rW9hYvP9RxkfrgJ9B1dMBF7uxxy3ZFBoDLSJTHGo1VuPifID22/rGYJeT2sj7/2zKo+lR;
Date: Mon, 6 Jun 2011 17:24:02 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Keith Packard <keithp@keithp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.0.0-rc2 fails to boot on Atom appliance (bisected, drm/i915)
Message-ID: <20110606172402.72ddb29b@jbarnes-desktop>
In-Reply-To: <4DED69C6.1090301@candelatech.com>
References: <4DED33DF.8000201@candelatech.com>
	<4DED6221.1060806@candelatech.com>
	<yunzkluzfw9.fsf@aiko.keithp.com>
	<4DED69C6.1090301@candelatech.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Jun 2011 16:59:02 -0700
Ben Greear <greearb@candelatech.com> wrote:

> On 06/06/2011 04:41 PM, Keith Packard wrote:
> > On Mon, 06 Jun 2011 16:26:25 -0700, Ben Greear<greearb@candelatech.com>  wrote:
> >> On 06/06/2011 01:09 PM, Ben Greear wrote:
> >>> Anyone seen something like this?  For what it's worth, it seems
> >>> that -rc1 had the same problem. I'll start bisecting soon if
> >>> the problem isn't already resolved somehow...
> >>
> >> I bisected this problem down to this commit:
> >
> > This should be fixed by this patch:
> >
> > -------------------- drivers/gpu/drm/i915/intel_display.c ---------------------
> > index f553ddf..bb1b59b 100644
> > @@ -7675,6 +7675,7 @@ static void intel_init_display(struct drm_device *dev)
> >   			dev_priv->display.update_wm = NULL;
> >   		} else
> >   			dev_priv->display.update_wm = pineview_update_wm;
> > +		dev_priv->display.init_clock_gating = gen3_init_clock_gating;
> >   	} else if (IS_G4X(dev)) {
> >   		dev_priv->display.update_wm = g4x_update_wm;
> >   		dev_priv->display.init_clock_gating = g4x_init_clock_gating;
> >
> > This hasn't been merged yet, but should be soon.
> 
> I tried adding that, but the problem stays the same.
> 
> Any other patches I should try?

Are you sure you booted the right kernel and that it built & installed
correctly?

You could add an:
  if (dev_priv->display.init_clock_gating)
above the call to display.init_clock_gating in intel_init_clock_gating
to be sure it's the same problem...

-- 
Jesse Barnes, Intel Open Source Technology Center
