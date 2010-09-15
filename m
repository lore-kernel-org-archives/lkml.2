Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab0IOTbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 15:31:09 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:48091 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab0IOTbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 15:31:07 -0400
Subject: Re: [RFC PATCH] drivers/net/tg3.c: Raise Jumbo Frame MTU to 9216?
From: Ben Hutchings <bhutchings@solarflare.com>
To: Joe Perches <joe@perches.com>
Cc: Michael Chan <mchan@broadcom.com>, Matthew Carlson <mcarlson@broadcom.com>,
        Benjamin Li <benli@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1284578095.10223.27.camel@Joe-Laptop>
References: <1284572516.10223.12.camel@Joe-Laptop>
	 <1284573454.8929.221.camel@HP1>  <1284578095.10223.27.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Wed, 15 Sep 2010 20:31:03 +0100
Message-ID: <1284579063.2293.28.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Sep 2010 19:36:00.0005 (UTC) FILETIME=[39A21350:01CB550D]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17638.005
X-TM-AS-Result: No--27.674000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-15 at 12:14 -0700, Joe Perches wrote:
> On Wed, 2010-09-15 at 10:57 -0700, Michael Chan wrote:
> > On Wed, 2010-09-15 at 10:41 -0700, Joe Perches wrote:
> > > The TG3 apparently supports 9K frame sizes.
> > > http://www.broadcom.com/collateral/pb/5704C-PB05-R.pdf
> > > Is exactly 9000 a hardware limit?
> > > Should the jumbo frame MTU be raised to 9216 or 9216
> > > less the size of MAC, VLAN, IP and TCP headers?
> > 9000 has been the de facto standard, has it been changed recently?
> 
> I know of a performance lab that's trying to use 9216 as a "standard"
> jumbo frame length.
[...]

We also use 9000 as the 'normal' jumbo MTU, though hard limit in sfc is
a bit higher than this.

The frame length limit is not defined only by the DMA engine and FIFOs
but also by the MAC and PHY.  On the receive side, the MAC and/or PHY
need to handle skew between the remote and local clocks which can grow
proportionally with frame length.  For a controller which is used with
several different PHYs, I would be hesitant to raise the driver's limit.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

