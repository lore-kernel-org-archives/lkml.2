Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab0D0TvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 15:51:24 -0400
Received: from xenotime.net ([72.52.64.118]:36648 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754937Ab0D0TvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 15:51:23 -0400
Date: Tue, 27 Apr 2010 12:51:21 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Psychovisually-optimized HZ setting (2.6.33.3)
Message-Id: <20100427125121.93963b8c.rdunlap@xenotime.net>
In-Reply-To: <op.vbt4jlyn6426ze@millennium.getinternet.no>
References: <1902387910.2078.435.camel@ymzhang.sh.intel.com>
	<4BC588CF.5010507@redhat.com>
	<1902445479.2078.458.camel@ymzhang.sh.intel.com>
	<4BC6C8CD.1020801@redhat.com>
	<1902473858.2078.481.camel@ymzhang.sh.intel.com>
	<op.vbt4jlyn6426ze@millennium.getinternet.no>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010 21:03:11 +0200 Uwaysi Bin Kareem wrote:

> This is based on the research I did with optimizing my machine for  
> graphics.
> I also wrote the following article:  
> http://www.paradoxuncreated.com/articles/Millennium/Millennium.html
> It is a bit outdated now, but I will update it with current information.
> The value might iterate.

Hi,

What CPU architectures or platforms did you test this on?
Were any other kernel changes needed?


> Peace Be With You,
> Uwaysi Bin Kareem.
> 
> 
> --- Kconfig.hzorig	2010-04-27 13:33:10.302162524 +0200
> +++ Kconfig.hz	2010-04-27 20:39:54.736959816 +0200
> @@ -45,6 +45,18 @@
>   	 1000 Hz is the preferred choice for desktop systems and other
>   	 systems requiring fast interactive responses to events.
> 
> +	config HZ_3956
> +		bool "3956 HZ"
> +	help
> +	 3956 Hz is nearly the highest timer interrupt rate supported in the  
> kernel.
> +	 Graphics workstations, and OpenGL applications may benefit from this,

	drop first comma.

> +	 since it gives the lowest framerate-jitter. The exact value 3956 is
> +	 psychovisually-optimized, meaning that it aims for a level of jitter,
> +	 percieved to be natural, and therefore non-nosiy. It is tuned for a

	perceived                               non-noisy.

> +	 profile of "where the human senses register the most information".
> +	
> +	
> +
>   endchoice
> 
>   config HZ
> @@ -53,6 +65,7 @@
>   	default 250 if HZ_250
>   	default 300 if HZ_300
>   	default 1000 if HZ_1000
> +	default 3956 if HZ_3956
> 
>   config SCHED_HRTICK
>   	def_bool HIGH_RES_TIMERS && (!SMP || USE_GENERIC_SMP_HELPERS)
> 
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
