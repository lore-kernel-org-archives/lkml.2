Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab1KGUNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 15:13:11 -0500
Received: from mr7.metrobridge.net ([66.119.172.226]:41931 "EHLO
	mail.metrobridge.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751322Ab1KGUNI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 15:13:08 -0500
X-AuditID: 0a01004f-b7b9cae000000b4d-ed-4eb836355890
From: Tim Vlaar <Tvlaar@ptgrey.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <greg@kroah.com>,
        Markus Rechberger <mrechberger@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 7 Nov 2011 12:13:05 -0800
Subject: RE: [Patch] Increase USBFS Bulk Transfer size
Thread-Topic: [Patch] Increase USBFS Bulk Transfer size
Thread-Index: AcydhzYZUw1XftemR46zEKMLI70EaAAAf7Kg
Message-ID: <BADF286A08026E4DAFA9622608E3D8DB063CE258A1@rosser.pointgrey.local>
References: <BADF286A08026E4DAFA9622608E3D8DB063CE25890@rosser.pointgrey.local>
 <Pine.LNX.4.44L0.1111071451330.2004-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1111071451330.2004-100000@iolanthe.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsXCxcgQpmtqtsPP4NxzI4vV64+wWJxbMIPR
	4vKuOWwWi5a1Mlu8X3OT1aL5xClmiwm/L7A5sHvsnHWX3ePtwwCPeScDPVpPbmL1mH33B6PH
	501yAWxRXDYpqTmZZalF+nYJXBn/Tr9mKnjJWfH9WHID4032LkZODgkBE4mzH96wQdhiEhfu
	rQezhQSOMUrcPRTWxcgFZLczSiyZsxisgU1AWeLntlOsILaIgJbE5qaXzCBFzAKvGCWuNewF
	62YRUJH4Pv0PC4gtLGAm8XjBEqAGDqAGc4l723kgeo0kZv2eyQRi8wr4S7TM/84OsWwSo8TJ
	Bb1gCzgFfCWO3pgEVsQIdN33U2vAbGYBcYlbT+YzQVwtILFkz3lmCFtU4uXjf6wQ9aISd9rX
	M0LU60gs2P2JDcLWlli28DUzxGJBiZMzn7BMYBSbhWTsLCQts5C0zELSsoCRZRWjUHpiTmZi
	Xr5eQUl6UWqlXnJ+7iZGSDT672Bcf1D4EKMAB6MSD+9LgR1+QqyJZcWVuYcYJTiYlUR4GbmA
	QrwpiZVVqUX58UWlOanFhxiZODilGhhl3rPuPrrxVe6/Jf2bxMo2f1wptPi4UdHE7q95N7VE
	75rHlZ191dx8j8k+lOWs73alExWFG3l3majoGroXm9T1GiXEqu/6dfDapWgbo4c8HGcvKXBc
	+P7N23aJcoEsS7VM5u2WjZM0bdNOa8Vc+bZ/RfIylq7G1ID7yz9KLIl9cXuv2b2m1TxKLMUZ
	iYZazEXFiQANCNvMpAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having a setting that we could adjust or even set to "no limit"  would work for us :)

Thanks
Tim


-----Original Message-----
From: Alan Stern [mailto:stern@rowland.harvard.edu] 
Sent: Monday, November 07, 2011 11:56 AM
To: Tim Vlaar
Cc: Sarah Sharp; Greg KH; Markus Rechberger; Alan Cox; USB list; LKML
Subject: RE: [Patch] Increase USBFS Bulk Transfer size

On Mon, 7 Nov 2011, Tim Vlaar wrote:

> Hi Sarah,
> 
> One of our cameras can produce 60MB images.  We usually queue up 10 
> images.  In Windows we have had customers queue up 100s of images at 
> 2-3MB/image, but not at 60MB at a time ... yet.  That could easily 
> amount to 60x10 = 600MB of in flight data or more.  Should there be a 
> limit as long as there is memory available?

This is debatable.  There are limits on how much memory a single process can allocate, but those limits don't apply to usbfs.  Even the patch Sarah referred to doesn't impose a per-process limit, but rather an overall global limit.

If we make the usbfs limit adjustable, one of the settings could be "no limit".  Then nothing would prevent you from using up more and more memory for your USB transfers until the machine runs out.  :-)

Alan Stern

