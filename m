Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1IYNP6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 09:15:58 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:17590 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752540Ab1IYNP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 09:15:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAFAP4nf05Ld+Jv/2dsb2JhbABCmT+OWnmBUwEBBTgeBhwBEAsLDQkWDwkDAgECAQ8CFh4GAQwBBQICrzaGRDuIc4cLBIlziV+KF4J1hEM
X-IronPort-AV: E=Sophos;i="4.68,439,1312171200"; 
   d="scan'208";a="138412646"
Message-ID: <4E7F2983.3050407@gmail.com>
Date: Sun, 25 Sep 2011 09:15:47 -0400
From: Woody Suwalski <terraluna977@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110902 Firefox/6.0.2 SeaMonkey/2.3.3
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Chris Wilson <chris@chris-wilson.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re:  Regression: i915 blank issue on kernel 3.1.0-rc3
References: <4E7A6CED.5000501@gmail.com> <yun4o05xkgl.fsf@aiko.keithp.com>
In-Reply-To: <yun4o05xkgl.fsf@aiko.keithp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Packard wrote:
> On Wed, 21 Sep 2011 19:02:05 -0400, Woody Suwalski<terraluna977@gmail.com>  wrote:
>
>> Chris, I do not know if it is i915 driver or X'drm or what..
>> Problem exists on 3.1.0, no problem on 3.0.3
> Any way you could narrow it down a bit more? A bisect should sort it out
> pretty quickly, given that you've got working code in 3.0 and
> not-working code in 3.1-rc. You can start by manually bisecting across the
> 3.1 release candidates, and then narrow it down from there by bisecting
> only across the drivers/gpu/drm/i915 directory.
Yes, I have narrowed it down. I did not run bisect, as it takes me 4hrs 
for kernel build on Eeepc...

The problem has appeared in 3.1-rc3, it is a regression.
I have tested -rc1 and -rc2, they are OK ( not that there was much 
activity regarding i915 in -rc2). The problem is still present in -rc7.

I see these entries in the changelog, these are Keith's additions to 
-rc3 which maight impact the blanker:

Keith Packard (6):
       drm/i915: Wait for LVDS panel power sequence
       drm/i915: Leave LVDS registers unlocked
       drm/i915: Fix PCH port pipe select in CPT disable paths
       drm/i915: Remove unused 'reg' argument to dp_pipe_enabled
       drm/i915: Can't do accurate vblank timestamps with UMS
       drm/i915: Cannot set clock gating under UMS

I can do a fast incremental rebuild of my current -rc3 tree, if Keith could send me some patches...

Thanks, Woody


