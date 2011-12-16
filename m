Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760614Ab1LPTaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:30:39 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:48807 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752264Ab1LPTae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:30:34 -0500
Subject: Re: [PATCH net-next v1 5/6] tg3: implementation of a non-NAPI mode
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Decotigny <decot@googlers.com>
CC: Matt Carlson <mcarlson@broadcom.com>, Michael Chan <mchan@broadcom.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        Robin Getz <rgetz@blackfin.uclinux.org>,
        Matt Mackall <mpm@selenic.com>, Tom Herbert <therbert@google.com>
In-Reply-To: <6d55ce25f5f237a4538f6a2fcd2609b877669297.1324059527.git.decot@googlers.com>
References: <cover.1324059527.git.decot@googlers.com>
	 <6d55ce25f5f237a4538f6a2fcd2609b877669297.1324059527.git.decot@googlers.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Fri, 16 Dec 2011 19:30:26 +0000
Message-ID: <1324063826.2798.8.camel@bwh-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18586.005
X-TM-AS-Result: No--12.606900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 10:19 -0800, David Decotigny wrote:
> From: Tom Herbert <therbert@google.com>
> 
> The tg3 NIC has a hard limit of 511 descriptors for the receive ring.
> Under heavy load of small packets, this device receive queue may not
> be serviced fast enough to prevent packets drops.  This could be due
> to a variety of reasons such as lengthy processing delays of packets
> in the stack, softirqs being disabled too long, etc.
[...]

I think those are bugs to be fixed, not worked around.

Various drivers had NAPI as a compile-time option for a while, and
pretty much all of those have now been made to use NAPI unconditionally
(I think tulip is the only one left).  Adding such an option back is
unlikely to be accepted now.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

