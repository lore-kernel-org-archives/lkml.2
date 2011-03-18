Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab1CRWke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 18:40:34 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48712 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932733Ab1CRWk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 18:40:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6289"; a="80858072"
Message-ID: <4D83DF5B.1000006@codeaurora.org>
Date: Fri, 18 Mar 2011 15:40:27 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
CC: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 0/4] Improve fallback LPJ calculation
References: <1299768487-13200-1-git-send-email-ext-phil.2.carmody@nokia.com>
In-Reply-To: <1299768487-13200-1-git-send-email-ext-phil.2.carmody@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2011 06:48 AM, Phil Carmody wrote:
> Apologies for picking on you, Andrew, and sending this out of the blue,
> but I didn't have much luck with my previous attempt, and I quite like
> this patchset, so thought it was worth trying again.
> (http://lkml.org/lkml/2010/9/28/121)
>
> The guts of this patchset are in patch 2/4. The motivation for that patch
> is that currently our OMAP calibrates itself using the trial-and-error 
> binary chop fallback that some other architectures no longer need to 
> perform. This is a lengthy process, taking 0.2s in an environment where 
> boot time is of great interest.
>
>
[snip]
> 1/4 is simply cosmetic to prepare for 2/4. 
> 4/4 is simply to assist testing and not intended for integration.
>

I tried this patch set out on an MSM7630.

Before:

Calibrating delay loop... 681.57 BogoMIPS (lpj=3407872)

After:

Calibrating delay loop... 680.75 BogoMIPS (lpj=3403776)

But the really good news is calibration time dropped from ~247ms to
~56ms. Sadly we won't be able to benefit from this should my udelay
patches make it into ARM because we would be using
calibrate_delay_direct() instead (at least on machines who choose to).
Can we somehow reapply the logic behind this to
calibrate_delay_direct()? That would be even better, but this is
definitely a boot time improvement.

Or maybe we could just replace calibrate_delay_direct() with this
fallback calculation? If __delay() is a thin wrapper around
read_current_timer() it should work just as well (plus patch 3 makes it
handle SMIs). I'll try that out.

You can add a

Tested-by: Stephen Boyd <sboyd@codeaurora.org>

to the first 3 patches.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

