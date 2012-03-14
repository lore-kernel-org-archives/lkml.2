Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760125Ab2CNUbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 16:31:34 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:44541 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535Ab2CNUbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 16:31:31 -0400
Date: Wed, 14 Mar 2012 13:30:57 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Lee <rob.lee@linaro.org>, Jean Pihet <j-pihet@ti.com>,
        Kevin Hilman <khilman@ti.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: next-20120313 cpuidle freezes when booting
In-Reply-To: <4F60F5B1.8070302@linaro.org>
Message-ID: <alpine.LSU.2.00.1203141325001.1282@eggly.anvils>
References: <alpine.LSU.2.00.1203131454500.1335@eggly.anvils> <4F608116.80508@linaro.org> <alpine.LSU.2.00.1203141156490.3826@eggly.anvils> <4F60F5B1.8070302@linaro.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2012, Daniel Lezcano wrote:
> On 03/14/2012 08:03 PM, Hugh Dickins wrote:
> > On Wed, 14 Mar 2012, Daniel Lezcano wrote:
> > > On 03/13/2012 11:29 PM, Hugh Dickins wrote:
> > > > 
> > > > Yesterday's 3.3.0-rc7-next-20120313 gives me unpredictable freezes
> > > > on x86_64, on a ThinkPad T420s - I've not dared it on more machines.
> > > 
> > > is it possible you give the cpuidle driver your host is using ?
> > 
> > "grep IDLE .config" tells me:
> > 
> > CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
> > CONFIG_ARCH_HAS_DEFAULT_IDLE=y
> > CONFIG_CPU_IDLE=y
> > CONFIG_CPU_IDLE_GOV_LADDER=y
> > CONFIG_CPU_IDLE_GOV_MENU=y
> > CONFIG_INTEL_IDLE=y
> > # CONFIG_I7300_IDLE is not set
> > 
> > but I've a feeling that isn't what you need to know.
> 
> Thanks for these informations, I forgot to ask you for them.
> By the way, do you have CONFIG_ARCH_HAS_CPU_RELAX  ?

Yes.

> 
> > Is there some /proc or /sys file I can read to tell you?
> 
> Yes, the content of /sys/devices/system/cpu/cpuidle/current_driver

intel_idle

> and /sys/devices/system/cpu/cpuidle/current_governor_ro

menu

> 
> > Though if it's something that changes dynamically, then what
> > I read now might not be what it would say when things go wrong.
> 
> No, that won't change, so the information should be enough for me to find the
> code path where the regression is.
> 
> > I expect you've realized by now, I haven't a clue about cpuidle
> > drivers: I hadn't even realized that idleness needs a driver.
> 
> No problem, thanks for git bisecting and find the culprit :)

Thank you - let me know if you've something you'd like me to try.

Hugh
