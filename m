Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab1BVW7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:59:46 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61578 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab1BVW7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:59:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=eO1JYqoopoIrmTnRcvZSzw6YZfd7+UDvU26ndtKO07QZN9+exaDF3wR9babaGk6xlT
         HGqfXq0wPs5MYiO+MMxvm3SoJGVYtnUIAR5wFhS4UhJrFw45T5NZaeyc/eja39BOHsft
         EVs8WPyDMZ10a7mNZCQFFJ6Ln7FBzunhlq6I8=
Message-ID: <4D643FDD.703@gmail.com>
Date: Tue, 22 Feb 2011 23:59:41 +0100
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Alan Cox <alan@linux.intel.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gma500: Intel GMA500 staging driver
References: <20110222121704.19437.4650.stgit@localhost.localdomain> <20110222154002.GB9720@srcf.ucam.org>
In-Reply-To: <20110222154002.GB9720@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 04:40 PM, Matthew Garrett wrote:
> On Tue, Feb 22, 2011 at 12:17:46PM +0000, Alan Cox wrote:
>> This is an initial staging driver for the GMA500. It's been stripped out
>> of the PVR drivers and crunched together from various bits of code and
>> different kernels.
>>
>> Currently it's unaccelerated but still pretty snappy even compositing with
>> the frame buffer X server.
>>
>> Lots of work is needed to rework the ttm and bo interfaces from being
>> ripped out and then 2D acceleration wants putting back for framebuffer
>> and somehow eventually via DRM.

>> +++ b/drivers/staging/gma500/psb_intel_sdvo.c
> Does PSB really support SDVO? I thought by that period the only thing
> it'd be used for was plug-in SDVO cards, which doesn't seem so likely
> with PSB.
>
The Fit-PC2 needs SDVO for its DVI/HDMI output. The SDVO chip is likely 
put directly on the PCB.
I tried to write my own driver for the gma500 (called it i500) which had 
all the SDVO stuff in place,
but I never sorted out the TTM stuff so it's been gathering dust for 
quite some time now.
>> diff --git a/drivers/staging/gma500/psb_ttm_fence.c b/drivers/staging/gma500/psb_ttm_fence.c
> This really looks like it's intended to be core TTM functionality, so it
> should probably go past dri-devel.
>
> This is definitely the best gma500 driver we've seen yet, but it seems
> like there's two directions it can go. If the intention for now is to
> provide a kernel-quality unaccelerated 2D driver then there's a *lot*
> more code that can just be ripped out. If we want the acceleration to
> work then there's an argument that we should be abstracting that into a
> more generic SGX layer that other drivers can make use of. Does omapfb
> have any acceleration? If so, is there anything we can build on there?
 From what I can see, omapfb doesn't have any acceleration,
and yes, it would be very nice to have a generic SGX layer.

Cheers
Patrik Jakobsson
