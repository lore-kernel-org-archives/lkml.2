Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab0DUKlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 06:41:50 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:7763 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab0DUKls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 06:41:48 -0400
X-SpamScore: -23
X-BigFish: VPS-23(zz1432P98dN936eM148cMzz1202hzzz32i2a8h87h43h64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1831D-01-DRH-02
X-M-MSG: 
Date: Wed, 21 Apr 2010 12:41:38 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Greg KH <greg@kroah.com>, Joerg Roedel <joro@8bytes.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pci_get_dev_by_id() from interrupt handlers
Message-ID: <20100421104138.GH31537@amd.com>
References: <20100420160423.GD31537@amd.com>
 <20100420163215.GB3270@kroah.com>
 <20100420173552.GA15669@8bytes.org>
 <20100420175202.GA4874@kroah.com>
 <20100421100528.GG31537@amd.com>
 <1271845271.1776.74.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1271845271.1776.74.camel@laptop>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 21 Apr 2010 10:41:39.0346 (UTC) FILETIME=[39447F20:01CAE13F]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 12:21:11PM +0200, Peter Zijlstra wrote:
> On Wed, 2010-04-21 at 12:05 +0200, Joerg Roedel wrote:
> > 
> > > Why not do the whole thing in an interrupt task as the whole thing
> > > sounds like something that shouldn't be done in interrupt context,
> > > right?  Now that we have this type of functionality, we should take
> > > advantage of it :)
> > 
> > Ok, I think I move the IOMMU interrupt handling to a tasklet.
> > 
> tasklet is softirq context, and is not what gregkh was talking about.
> 
> You'd still need to change the klist spinlock to be softirq-safe.

Ah right. Thanks for pointing this out. I couldn't find much about the
interrupt tasks. Is it about the request_threaded_irq interface? And
this would be run in the context of a kernel thread, right?

	Joerg


