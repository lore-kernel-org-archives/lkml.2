Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab1EDUyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:54:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:45538 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756004Ab1EDUx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:53:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,316,1301900400"; 
   d="scan'208";a="638023472"
Date: Wed, 4 May 2011 13:53:51 -0700 (Pacific Daylight Time)
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: Stephen Hemminger <shemminger@vyatta.com>
cc: David Miller <davem@davemloft.net>, Sangtae Ha <sangtae.ha@gmail.com>,
        Injong Rhee <injongrhee@gmail.com>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "lkml@techboom.com" <lkml@techboom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tcp_cubic: limit delayed_ack ratio to prevent divide
 error
In-Reply-To: <20110504130456.425dee68@nehalam>
Message-ID: <alpine.WNT.2.00.1105041352020.6048@JBRANDEB-DESK2.amr.corp.intel.com>
References: <20110504113351.4643a0c9@nehalam> <16668.1304537481@localhost> <20110504123738.7bb4d1ee@nehalam> <20110504.124053.260068550.davem@davemloft.net> <20110504130456.425dee68@nehalam>
User-Agent: Alpine 2.00 (WNT 1167 2008-08-23)
ReplyTo: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
X-X-Sender: amrjbrandeb@imapmail.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 May 2011, Stephen Hemminger wrote:

> TCP Cubic keeps a metric that estimates the amount of delayed
> acknowledgements to use in adjusting the window. If an abnormally
> large number of packets are acknowledged at once, then the update
> could wrap and reach zero. This kind of ACK could only
> happen when there was a large window and huge number of
> ACK's were lost.
> 
> This patch limits the value of delayed ack ratio. The choice of 32
> is just a conservative value since normally it should be range of 
> 1 to 4 packets.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

patch seems fine, but please credit the reporter (lkml@techboom.com) with 
reporting the issue with logs, maybe even with Reported-by: and some kind 
of reference to the panic message or the email thread in the text or 
header?

