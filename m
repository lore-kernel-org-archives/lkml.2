Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab2K3Ukt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 15:40:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37498 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757261Ab2K3Ukq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 15:40:46 -0500
Message-ID: <50B9198F.7050806@zytor.com>
Date: Fri, 30 Nov 2012 12:39:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Jim Cromie <jim.cromie@gmail.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Michal Marek <mmarek@suse.cz>,
        Tony Lindgren <tony@atomide.com>,
        Jonathan Kliegman <kliegs@chromium.org>,
        Chris Zankel <chris@zankel.net>,
        Bill Pemberton <wfp5p@viridian.itc.virginia.edu>,
        Fengguang Wu <fengguang.wu@intel.com>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH 1/2] init.h: Remove __dev* sections from the kernel
References: <20121129184133.GA15110@kroah.com> <20121129184328.GB15110@kroah.com>
In-Reply-To: <20121129184328.GB15110@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2012 10:43 AM, Greg Kroah-Hartman wrote:
>
> -/* Used for HOTPLUG */
> -#define __devinit        __section(.devinit.text) __cold notrace
> -#define __devinitdata    __section(.devinit.data)
> -#define __devinitconst   __constsection(.devinit.rodata)
> -#define __devexit        __section(.devexit.text) __exitused __cold notrace
> -#define __devexitdata    __section(.devexit.data)
> -#define __devexitconst   __constsection(.devexit.rodata)
> +/* Used for HOTPLUG, but that is always enabled now, so just make them noops */
> +#define __devinit
> +#define __devinitdata
> +#define __devinitconst
> +#define __devexit
> +#define __devexitdata
> +#define __devexitconst
>

Second question... what about the __exitused __cold notrace annotations?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

