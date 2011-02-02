Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab1BBRSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 12:18:43 -0500
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:37979 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754503Ab1BBRSm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 12:18:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=NYTl7bbHKSR6+iif90Cl0dUgVC7fL5kKGVPiiowdRHbpQN3U6iwddtaZm2jAIF1IU4iD5j+MtcC5rwAIIThUmGupc3sh0wsHeWG85euFPByqEWIhuNecJnpWnFp2kT8k;
Date: Wed, 2 Feb 2011 09:18:38 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Hugh Dickins <hughd@google.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Suppress spurious vblank interrupts
Message-ID: <20110202091838.5efaa660@jbarnes-desktop>
In-Reply-To: <AANLkTikwfHd6t95-jhbXCy1ciW3OV+HVYVikZNs5LHfz@mail.gmail.com>
References: <849307$bc24ct@azsmga001.ch.intel.com>
	<1296471462-8578-1-git-send-email-chris@chris-wilson.co.uk>
	<alpine.LSU.2.00.1102010909270.1586@sister.anvils>
	<20110201094643.366bc073@jbarnes-desktop>
	<20110201100833.3219687e@jbarnes-desktop>
	<AANLkTim4kL9OjBDiQQ1MBfOCzThxmDonBic11N45NKxj@mail.gmail.com>
	<20110201113238.60b33ff9@jbarnes-desktop>
	<AANLkTikwfHd6t95-jhbXCy1ciW3OV+HVYVikZNs5LHfz@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Feb 2011 19:37:09 -0800
Hugh Dickins <hughd@google.com> wrote:

> On Tue, Feb 1, 2011 at 11:32 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> > What I find strange is that you're seeing flip pending interrupts.  Are
> > your symptoms affected if you remove the
> > I915_DISPLAY_PLANE_[AB]_FLIP_PENDING_INTERRUPT lines from
> > I915_INTERRUPT_ENABLE_FIX at the top of i915_irq.c?
> 
> No.  The first time it looked like yes it fixed it; but when I
> rebooted again, same symptoms and same underruns back: this thing is
> very erratic.
> 
> > Do you see any calls to drm_mode_page_flip_ioctl() in your environment?
> 
> None at all.
> 
> Sometime I should do a bisection between v2.6.36 and v2.6.37 to see
> what started the underruns; but I can't promise when "sometime" will
> arrive.

But presumably the FLIP_PENDING_INTERRUPT bits are stuck on in your
case, otherwise we wouldn't be getting to flip prepare/finish at all.

Some updated docs indicate those bits may not be reliable on 965
(though earlier ones did), so we may need to disable the flip code
entirely on 965 if we can't figure out what's going wrong on your
config...

-- 
Jesse Barnes, Intel Open Source Technology Center
