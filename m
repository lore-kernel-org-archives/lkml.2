Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab0DTP4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 11:56:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:65511 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab0DTP4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 11:56:14 -0400
Date: Tue, 20 Apr 2010 08:53:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, fweisbec@gmail.com, peterz@infradead.org,
       gorcunov@gmail.com, aris@redhat.com, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
Subject: Re: [PATCH 1/6] [watchdog] combine nmi_watchdog and softlockup
Message-Id: <20100420085350.fce77f4f.randy.dunlap@oracle.com>
In-Reply-To: <1271777043-3807-2-git-send-email-dzickus@redhat.com>
References: <1271777043-3807-1-git-send-email-dzickus@redhat.com>
	<1271777043-3807-2-git-send-email-dzickus@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090208.4BCDCE78.0016:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Apr 2010 11:23:58 -0400 Don Zickus wrote:

> diff --git a/init/Kconfig b/init/Kconfig
> index 7331a16..98e3f5f 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -948,8 +948,11 @@ config PERF_USE_VMALLOC
>  
>  config PERF_EVENTS_NMI
>  	bool
> +	depends on PERF_EVENTS
>  	help
> -	  Arch has support for nmi_watchdog
> +	  Arch can generate an NMI using the perf event subsystem

Hi Don,

I realize that you didn't introduce Arch in this help text,
but can we eliminate him, please?  E.g.:

	  Platform can generate an NMI using the perf event subsystem.
or
	  System hardware can generate an NMI using the perf event subsystem.

> +	  Also has support for calculating cpu cycle events to

	                                   CPU

> +	  determine how many clock cycles in a given period

                                                     period.

>  
>  menu "Kernel Performance Events And Counters"


---
~Randy
