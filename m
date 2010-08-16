Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743Ab0HPCvy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 22:51:54 -0400
Received: from smtp-out-249.synserver.de ([212.40.180.249]:1031 "EHLO
	smtp-out-244.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751185Ab0HPCvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 22:51:53 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 11404
Date: Mon, 16 Aug 2010 04:51:46 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        Zhao Yakui <yakui.zhao@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Adam Jackson <ajax@redhat.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Intel graphics CPU usage - SDVO detect bogosity?
Message-ID: <20100816025146.GA1639@arch.tripp.de>
References: <AANLkTi=NFpeyo7Q31yMfqKSP2c-2OS2ccqa=Q9CQ8bpk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=NFpeyo7Q31yMfqKSP2c-2OS2ccqa=Q9CQ8bpk@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 15, 2010 at 07:32:15PM -0700, Linus Torvalds wrote:
> I started wondering why 'top' was showing an otherwise idle system as
> having a load average of 0.5+, and worker threads constantly using the
> CPU.
> 
> So I did a system-wide profile, and got the attached output (look at
> it in a really wide terminal).
> 
> There seems to be something _seriously_ wrong with i915 SDVO detect.
> This is on an Apple Mac Mini (hey, your favorite problem child!), and
> apparently it spends 20% of its non-idle CPU time just doing udelay's
> for the i2c SDVO connection detection.
> 
> That sounds a bit wrong, doesn't it?
> 
> I don't know how recent this is - it might have been going on for some
> time without me noticing. It's the wife's computer, and the same thing
> doesn't seem to happen on my Core i5 desktop
> 
> Any ideas? Any information I can give about the machine?

You're not alone. I'm seeing similar things on my machine (AMD,Radeon).
The monitor outputs are polled every 10 sec in drivers/gpu/drm/drm_crtc_helper.c.

There is a patch attached to the following bug report that disables
polling and solves the problem for me:
http://bugs.freedesktop.org/show_bug.cgi?id=29536

-- 
»A man who doesn't know he is in prison can never escape.«
William S. Burroughs
