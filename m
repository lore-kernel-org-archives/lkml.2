Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287Ab1KHUbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 15:31:24 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40345 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab1KHUbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 15:31:22 -0500
Date: Tue, 8 Nov 2011 21:31:16 +0100
From: Borislav Petkov <bp@amd64.org>
To: Daniel Drake <dsd@laptop.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Geode LX boot fails after x86 microcode revision change
Message-ID: <20111108203116.GF25083@aftab>
References: <CAMLZHHTSuHZoPbm_YfB8G05JA+xKCE4+Jmj4NW8mnZUHogQSBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMLZHHTSuHZoPbm_YfB8G05JA+xKCE4+Jmj4NW8mnZUHogQSBA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 01:59:40PM -0600, Daniel Drake wrote:
> Hi,
> 
> Linux-3.1 works fine on OLPC XO-1 (Geode LX) but latest linus master
> fails to boot. It hangs so early on that we don't even receive any
> output over serial.
> 
> git bisect tracked it down to:
> 
> 
> commit bcb80e53877c2045d9e52f4a71372c3fe6501f6f
> Author: Borislav Petkov <borislav.petkov@amd.com>
> Date:   Mon Oct 17 16:34:36 2011 +0200
> 
>     x86, microcode, AMD: Add microcode revision to /proc/cpuinfo
> 
>     Enable microcode revision output for AMD after 506ed6b53e00 ("x86,
>     intel: Output microcode revision in /proc/cpuinfo") did it for Intel.
> 
>     Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> 
> 
> Any thoughts?

Hmm,

it might be that the Geode doesn't have the patch level MSR.., can you
send /proc/cpuinfo from a working kernel please, say 3.1?

Although, I have rdmsr_safe in the patch there so it actually shouldn't
be an issue, theoretically.

Can you also install msr-tools and do

$ rdmsr 0x8b

as root on the working kernel? If it hangs there too, then we know why.

Also, can you boot if you comment out the rdmsr_safe line in
early_init_amd(), line 477:

// rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);

?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
