Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab0HPDad (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 23:30:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab0HPDac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 23:30:32 -0400
Subject: Re: Intel graphics CPU usage - SDVO detect bogosity?
From: Dave Airlie <airlied@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        Zhao Yakui <yakui.zhao@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
In-Reply-To: <AANLkTi=NFpeyo7Q31yMfqKSP2c-2OS2ccqa=Q9CQ8bpk@mail.gmail.com>
References: <AANLkTi=NFpeyo7Q31yMfqKSP2c-2OS2ccqa=Q9CQ8bpk@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 13:30:08 +1000
Message-ID: <1281929408.3530.1.camel@clockmaker-el6>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-08-15 at 19:32 -0700, Linus Torvalds wrote:
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

At least we should replace mdelay with msleep in those functions.

Can you get a boot with drm.debug=4?

I wonder are we picking up a bad SDVO, the insane code retries 50 times
with a hard loop delay.

Dave.


