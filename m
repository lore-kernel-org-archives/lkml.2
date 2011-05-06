Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab1EFQyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 12:54:04 -0400
Received: from mail.vyatta.com ([76.74.103.46]:37668 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756666Ab1EFQyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 12:54:02 -0400
Date: Fri, 6 May 2011 09:53:59 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: TB <lkml@techboom.com>
Cc: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        David Miller <davem@davemloft.net>, Sangtae Ha <sangtae.ha@gmail.com>,
        Injong Rhee <injongrhee@gmail.com>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tcp_cubic: limit delayed_ack ratio to prevent divide
 error
Message-ID: <20110506095359.57c4fb38@nehalam>
In-Reply-To: <4DC41EB2.6070404@techboom.com>
References: <20110504113351.4643a0c9@nehalam>
	<16668.1304537481@localhost>
	<20110504123738.7bb4d1ee@nehalam>
	<20110504.124053.260068550.davem@davemloft.net>
	<20110504130456.425dee68@nehalam>
	<alpine.WNT.2.00.1105041352020.6048@JBRANDEB-DESK2.amr.corp.intel.com>
	<4DC41EB2.6070404@techboom.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 May 2011 12:15:46 -0400
TB <lkml@techboom.com> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 11-05-04 04:53 PM, Brandeburg, Jesse wrote:
> > 
> > 
> > On Wed, 4 May 2011, Stephen Hemminger wrote:
> > 
> >> TCP Cubic keeps a metric that estimates the amount of delayed
> >> acknowledgements to use in adjusting the window. If an abnormally
> >> large number of packets are acknowledged at once, then the update
> >> could wrap and reach zero. This kind of ACK could only
> >> happen when there was a large window and huge number of
> >> ACK's were lost.
> >>
> >> This patch limits the value of delayed ack ratio. The choice of 32
> >> is just a conservative value since normally it should be range of 
> >> 1 to 4 packets.
> >>
> >> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> > 
> > patch seems fine, but please credit the reporter (lkml@techboom.com) with 
> > reporting the issue with logs, maybe even with Reported-by: and some kind 
> > of reference to the panic message or the email thread in the text or 
> > header?
> 
> We're currently testing the patch on 6 production servers

Thank you, is there some regularity to the failures previously?
