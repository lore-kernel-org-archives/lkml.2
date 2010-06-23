Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab0FWDHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 23:07:06 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:47685 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab0FWDHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 23:07:04 -0400
Date: Wed, 23 Jun 2010 12:06:38 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Don Zickus <dzickus@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH v3] Add TAINT_HARDWARE_UNSUPPORTED flag
Message-ID: <20100623030637.GA30139@linux-sh.org>
References: <20100617091322.b7d21473.randy.dunlap@oracle.com> <4C1A7D61.8010900@redhat.com> <20100621122145.76ebd7ac.akpm@linux-foundation.org> <20100621194559.GI3217@redhat.com> <20100621130008.d3dc01a8.akpm@linux-foundation.org> <20100622153457.GA5381@redhat.com> <20100622164835.4ddb9432@lxorguk.ukuu.org.uk> <20100622163817.GE20668@srcf.ucam.org> <20100622175741.6541ff2a@lxorguk.ukuu.org.uk> <20100622170410.GA22182@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100622170410.GA22182@srcf.ucam.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 06:04:10PM +0100, Matthew Garrett wrote:
> On Tue, Jun 22, 2010 at 05:57:41PM +0100, Alan Cox wrote:
> 
> > And then as I said originally the example given was not even
> > "unsupported hardware" for an obvious Red Hat definition of the two
> > because it was actually about firmware combinations on specific boards -
> > ie it was an unsupported configuration.
> 
> The two examples given were:
> 
> "a distribution may want to support PPC but not the Power5 chipset, or 
> the e1000e driver but not a card with a specific DeviceID because of 
> known firmware issues."
> 
> In both those cases it's specific hardware that's unsupported, not the 
> configuration.
> 
What exactly is the use case supposed to be? If drivers are supposed to
call in to it for specific devices then they already have all of the
information they need for constructing a device blacklist and providing
more detailed information. If it's a configuration issue then we have
device quirks, which could also be extended to other busses as needed. In
either case, the context ought to be fairly explicit. I would much rather
see a message from the bus code stating that a specific device has been
disabled and skip the probe path entirely rather than trying to bolt on a
system-wide unsupported hardware state.
