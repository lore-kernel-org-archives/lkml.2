Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab0DUKFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 06:05:42 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:55390
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752308Ab0DUKFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 06:05:40 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz146fK98dN4015Lzz1202hzzz32i2a8h87h64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L181D3-01-BH3-02
X-M-MSG: 
Date: Wed, 21 Apr 2010 12:05:28 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Greg KH <greg@kroah.com>
CC: Joerg Roedel <joro@8bytes.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pci_get_dev_by_id() from interrupt handlers
Message-ID: <20100421100528.GG31537@amd.com>
References: <20100420160423.GD31537@amd.com>
 <20100420163215.GB3270@kroah.com>
 <20100420173552.GA15669@8bytes.org>
 <20100420175202.GA4874@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100420175202.GA4874@kroah.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 21 Apr 2010 10:05:29.0070 (UTC) FILETIME=[2BAEA8E0:01CAE13A]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 10:52:02AM -0700, Greg KH wrote:
> On Tue, Apr 20, 2010 at 07:35:59PM +0200, Joerg Roedel wrote:

> Why not do the whole thing in an interrupt task as the whole thing
> sounds like something that shouldn't be done in interrupt context,
> right?  Now that we have this type of functionality, we should take
> advantage of it :)

Ok, I think I move the IOMMU interrupt handling to a tasklet.

> Eventually, notifying KVM isn't something that you want to do from
> interrupt context anyway, right?

On the KVM side it is probably nothing more than setting a request bit.
But lets see how this could be done :-)

Thanks,

	Joerg


