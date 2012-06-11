Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab2FKTjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 15:39:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:2267 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab2FKTjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 15:39:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="156292265"
Date: Mon, 11 Jun 2012 21:49:46 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dave Jones <davej@redhat.com>, Sasha Levin <levinsasha928@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>, lauro.venancio@openbossa.org,
        aloisio.almeida@openbossa.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: net: nfc: BUG and panic in accept() on 3.5-rc2
Message-ID: <20120611194946.GA22557@sortiz-mobl>
References: <1339423241.4999.53.camel@lappy>
 <20120611144134.GX22557@sortiz-mobl>
 <1339425693.6001.2268.camel@edumazet-glaptop>
 <20120611145700.GY22557@sortiz-mobl>
 <1339426778.6001.2312.camel@edumazet-glaptop>
 <20120611152007.GZ22557@sortiz-mobl>
 <1339433810.4999.65.camel@lappy>
 <20120611172545.GA1776@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120611172545.GA1776@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Mon, Jun 11, 2012 at 01:25:45PM -0400, Dave Jones wrote:
> On Mon, Jun 11, 2012 at 06:56:50PM +0200, Sasha Levin wrote:
> 
>  > > > > > > What's trinity ?
>  > > > > > > Also, if this one is reproducible, would you mind sharing some details about
>  > > > > > > how we could reproduce it ?
>  > > > > > 
>  > > > > > Well, bugfix should be trivial enough ;)
>  > > > > Yep, I looked at the code only after looking at Sasha's report.
>  > > > > 
>  > > > > Thanks for the patch, do you mind if I add your SOB to it ?
>  > > > 
>  > > > I  would prefer making sure it fixes the bug first ;)
>  > > Sure, although your patch makes sense regardless of that :)
>  > > I'll still wait for Sasha to confirm that it fixes his crash.
>  > 
>  > I don't have a direct way of reproducing it, but I've put it in the test
>  > vm and the fuzzer is running, I'll let you know tomorrow if it happened
>  > again.
> 
> You might be able to trigger it faster by using -P PF_NFC, which will 
> force trinity to only use NFC sockets.
> 
> sidenote: most protocols trigger the module to be auto-loaded when a socket
> is created. This doesn't seem to happen with nfc, making me need to manually
> modprobe it first. Intentional ?
No, I'm missing the MODULE_ALIAS_NETPROTO() call for NFC. Thanks for the
report.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
