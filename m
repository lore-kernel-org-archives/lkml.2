Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031427Ab2K3SMC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:12:02 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:38436 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab2K3SL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:11:59 -0500
Date: Fri, 30 Nov 2012 19:11:56 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Jim Cromie <jim.cromie@gmail.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Michal Marek <mmarek@suse.cz>,
        Tony Lindgren <tony@atomide.com>,
        Jonathan Kliegman <kliegs@chromium.org>,
        Chris Zankel <chris@zankel.net>,
        Bill Pemberton <wfp5p@viridian.itc.virginia.edu>,
        Fengguang Wu <fengguang.wu@intel.com>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH 1/2] init.h: Remove __dev* sections from the kernel
Message-ID: <20121130181156.GA18287@merkur.ravnborg.org>
References: <20121129184133.GA15110@kroah.com> <20121129184328.GB15110@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129184328.GB15110@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 10:43:28AM -0800, Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> With the recent work to remove CONFIG_HOTPLUG, we are starting to get a
> bunch of __devinit section warnings, despite CONFIG_HOTPLUG always being
> enabled.  So, stop marking the sections entirely, by defining them away
> the section markings in init.h
> 
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
> 
> ---
>  include/linux/init.h |   18 +++++++-----------
>  1 file changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/init.h b/include/linux/init.h
> index e59041e..f63692d 100644
> --- a/include/linux/init.h
> +++ b/include/linux/init.h
> @@ -93,13 +93,13 @@
>  
>  #define __exit          __section(.exit.text) __exitused __cold notrace
>  
> -/* Used for HOTPLUG */
> -#define __devinit        __section(.devinit.text) __cold notrace
> -#define __devinitdata    __section(.devinit.data)
> -#define __devinitconst   __constsection(.devinit.rodata)
> -#define __devexit        __section(.devexit.text) __exitused __cold notrace
> -#define __devexitdata    __section(.devexit.data)
> -#define __devexitconst   __constsection(.devexit.rodata)
> +/* Used for HOTPLUG, but that is always enabled now, so just make them noops */

This comment should be explicit that these are provided only for backward compatibility
and their usage is discouarged.

	Sam
