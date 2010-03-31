Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab0CaCmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 22:42:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:54335 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119Ab0CaCmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 22:42:38 -0400
Message-ID: <4BB2B65E.5030905@kernel.org>
Date: Wed, 31 Mar 2010 11:41:34 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       adobriyan@gmail.com, tglx@linutronix.de, hpa@zytor.com,
       yi.zhu@intel.com, reinette.chatre@intel.com, ilw@linux.intel.com,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 3/4] include cleanup: Update gfp.h and slab.h includes
 to prepare for breaking implicit slab.h inclusion from percpu.h
References: <1269420538-18039-1-git-send-email-tj@kernel.org>	 <1269420538-18039-4-git-send-email-tj@kernel.org> <1269959410.16298.20.camel@useless.americas.hpqcorp.net>
In-Reply-To: <1269959410.16298.20.camel@useless.americas.hpqcorp.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 31 Mar 2010 02:41:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/30/2010 11:30 PM, Lee Schermerhorn wrote:
> I rebased your series atop the mmotm dated 24march to test my "generic
> percpu numa_*_id()" series.  This largish patch [3/4] threw a few [13]
> rejects.  I'll list them below.  You've said that you're going to submit
> this to linux-next where it might not see the same rejects.  I built,
> booted and am using the resulting kernel on x86_64.

This series is already in linux-next from next-20100329.  I forgot to
run slabh-sweep.py script on new code in linux-next which led to
various build breakages.  Stephen fixed the ones which cause build
failures and I later ran the script on linux-next and sent out patches
to subsystem trees.  The good news is there was only one build
breakage from mainline code.  All else were new code in linux-next.
So, the conversion seems quite comprehensive.

> Building with allyesconfig, I found 15 additional files in the mmotm
> tree that will need an explicit include of slab.h added.  I have
> attached a patch that addresses these.
> 
> I have rebased my numa_*_id() series atop this mmotm, less the
> percpu.h/percpu-defs.h hack that led you down this path.  That kernel
> builds and boots fine.  I'm currently testing with and without
> memoryless nodes.  So far, this series looks good.

Great, can you please retry mm once it pulls in linux-next from
20100401?  That should have most of necessary fixes.

>  drivers/hwmon/tmp102.c              |    1 +
>  drivers/input/misc/ad714x.c         |    1 +
>  drivers/input/misc/pcf8574_keypad.c |    1 +
>  drivers/leds/leds-input.c           |    1 +
>  drivers/misc/hwlat_detector.c       |    1 +
>  drivers/mtd/sm_ftl.c                |    1 +
>  drivers/vbus/bus-proxy.c            |    1 +
>  kernel/debug/kdb/kdb_support.c      |    1 +
>  sound/soc/codecs/twl6040.c          |    1 +
>  sound/usb/endpoint.c                |    1 +
>  sound/usb/format.c                  |    1 +
>  sound/usb/helper.c                  |    1 +
>  sound/usb/mixer_quirks.c            |    1 +
>  sound/usb/pcm.c                     |    1 +
>  sound/usb/quirks.c                  |    1 +
>  15 files changed, 15 insertions(+)

Most of the above are the ones already fixed in linux-next.  Can you
please try out next-20100330?

Thanks.

-- 
tejun
