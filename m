Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab1KPXMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 18:12:10 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:36547 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab1KPXMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 18:12:09 -0500
Subject: Re: [PATCH net-next v6 3/9] kbuild: document RPS/XPS network
 Kconfig options
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Decotigny <david.decotigny@google.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, Richard Jones <rick.jones2@hp.com>,
        Ayaz Abdulla <AAbdulla@nvidia.com>, Tom Herbert <therbert@google.com>
In-Reply-To: <c7e7b57596f9a06b1c40c8b6e671cc6ac69dd304.1321481064.git.david.decotigny@google.com>
References: <cover.1321481064.git.david.decotigny@google.com>
	 <c7e7b57596f9a06b1c40c8b6e671cc6ac69dd304.1321481064.git.david.decotigny@google.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Wed, 16 Nov 2011 23:12:02 +0000
Message-ID: <1321485122.2709.55.camel@bwh-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18522.005
X-TM-AS-Result: No--10.284400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-OriginalArrivalTime: 16 Nov 2011 23:12:08.0468 (UTC) FILETIME=[29D3BD40:01CCA4B5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 14:15 -0800, David Decotigny wrote:
> This adds a description of RPS/XPS options and allow them to be
> changed at make menuconfig time.

I'm not sure why you think this is necessary.

[...]
>  config RPS
> -	boolean
> +	boolean "Enable Receive Packet Steering"
>  	depends on SMP && SYSFS && USE_GENERIC_SMP_HELPERS
>  	default y
> +	help
> +	  RPS distributes the load of received packet processing
> +	  across multiple CPUs. If unsure, say Y.
>  
>  config RFS_ACCEL
> -	boolean
> +	boolean "Enable Hardware Acceleration of RFS"
>  	depends on RPS && GENERIC_HARDIRQS
>  	select CPU_RMAP
>  	default y
> +	help
> +	  This is the hardware version of RPS. On multi-queue network
> +	  devices, this configures the hardware to distribute the
> +	  received packets across multiple CPUs. If unsure, say Y.
[...]

There is some confusion/conflation between RPS and RFS in both code and
documentation.

RPS originaly referred to spreading out RX packet processing based on a
flow hash.  Most multiqueue devices do this in hardware, which is
commonly referred to as RSS.  RSS can be enabled independently of any
networking core features.

RFS refers to directing RX packet processsing of specific flows based on
where the corresponding sockets have been used.  RFS acceleration means
that the driver and hardware help with this by changing hardware queue
selection for specific flows.

The RPS Kconfig option controls both RPS and RFS, and various references
to 'RPS' in the code really cover RFS as well.

The RFS_ACCEL Kconfig option enables RFS to support acceleration, and
like most offload features it has no effect without a driver that
specifically supports that.  The option only exists to abstract the
slightly odd dependency on GENERIC_HARDIRQS, and I don't think it should
be manually controllable.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

