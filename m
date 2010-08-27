Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab0H0RKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 13:10:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60122 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab0H0RKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 13:10:14 -0400
Message-ID: <4C77F164.8000100@zytor.com>
Date: Fri, 27 Aug 2010 10:09:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, k8-gart: Decouple handling of garts and northbridges
References: <20100827075945.GA5348@loge.amd.com>
In-Reply-To: <20100827075945.GA5348@loge.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2010 12:59 AM, Andreas Herrmann wrote:
> From: Andreas Herrmann <andreas.herrmann3@amd.com>
> 
> So far we only provide num_k8_northbridges. This is required in
> different areas (e.g. L3 cache index disable, GART). But not all AMD
> CPUs provide a GART. Thus it is useful to split off the GART handling
> from the generic caching of AMD northbridge misc devices.
> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  arch/x86/include/asm/k8.h             |   13 +++++---
>  arch/x86/kernel/cpu/intel_cacheinfo.c |    4 +-
>  arch/x86/kernel/k8.c                  |   52 +++++++++++++++++++--------------
>  arch/x86/kernel/pci-gart_64.c         |   27 +++++++++++------
>  drivers/char/agp/amd64-agp.c          |   33 ++++++++++++++------
>  drivers/edac/amd64_edac.c             |    2 +-
>  6 files changed, 82 insertions(+), 49 deletions(-)
> 
> 
> Please apply.
> 

>From just looking at it: isn't this patch going to break compiling with
CONFIG_K8_NB=n?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

