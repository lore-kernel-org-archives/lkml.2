Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab1KGT0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 14:26:24 -0500
Received: from mr7.metrobridge.net ([66.119.172.226]:39089 "EHLO
	mail.metrobridge.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752491Ab1KGT0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 14:26:14 -0500
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Nov 2011 14:26:13 EST
X-AuditID: 0a01004f-b7b9cae000000b4d-a1-4eb8290ef6eb
From: Tim Vlaar <Tvlaar@ptgrey.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Greg KH <greg@kroah.com>, Markus Rechberger <mrechberger@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 7 Nov 2011 11:16:58 -0800
Subject: RE: [Patch] Increase USBFS Bulk Transfer size
Thread-Topic: [Patch] Increase USBFS Bulk Transfer size
Thread-Index: AcydfoFTpO4N72YDSeem9gzB68r6IwAAf2dQ
Message-ID: <BADF286A08026E4DAFA9622608E3D8DB063CE25890@rosser.pointgrey.local>
References: <CA+O4pCKKOvjRmgpC1fijzmpKOMQGdb1vkKeiSgFTY3Sv7xeaoQ@mail.gmail.com>
 <Pine.LNX.4.44L0.1110140956390.2036-100000@iolanthe.rowland.org>
 <20111014143329.GB9478@kroah.com> <20111107185255.GA9005@xanatos>
In-Reply-To: <20111107185255.GA9005@xanatos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsXCxcgQpsunucPP4O5/Q4vV64+wWJxbMIPR
	4vKuOWwWi5a1Mlu8X3OT1aL5xClmiwm/L7A5sHvsnHWX3ePtwwCPeScDPVpPbmL1mH33B6PH
	501yAWxRXDYpqTmZZalF+nYJXBkbHh9hLLjGU9E0s4m1gbGJq4uRk0NCwERiyeXV7BC2mMSF
	e+vZuhi5OIQEjjFKrO95zAzhtDNKXL+xjAWkik1AWeLntlOsILaIQKTE9yPr2UGKmAV2M0o0
	z5rF2MXIwcEioCIx63M4SI2wgJnE4wVLWEHCIgLmEve280C0Gkl82bQZLMwr4C+xa3olxKrr
	jBLHds5kBqnhFNCR2LfgCdhxjEDHfT+1hgnEZhYQl7j1ZD4TxNECEkv2nGeGsEUlXj7+xwpR
	Lypxp309I0S9jsSC3Z/YIGxtiWULX4PV8woISpyc+YRlAqPYLCRjZyFpmYWkZRaSlgWMLKsY
	hdITczIT8/L1CkrSi1Ir9ZLzczcxQqLRfwfj+oPChxgFOBiVeHhfCuzwE2JNLCuuzD3EKMHB
	rCTCy8gFFOJNSaysSi3Kjy8qzUktPsTIxMEp1cAYyL13qVS4cMpBvsCr998FXFk66cSa1/p/
	J2XwrZqo13JlpkTf8zWz3t9gf/JJ5dRt5d0qWea//kYsu/WFZUXqZbWac2aZSyvXetpWRbSt
	C7re+eqLaSBrttHhk4KL3OP4lU/mVUw4dXnZRDbFK8rWmZwFQtnvPj29K7Rm76lIbl5zEcvT
	s64+VGIpzkg01GIuKk4EAPdsAt2kAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sarah,

One of our cameras can produce 60MB images.  We usually queue up 10 images.  In Windows we have had customers queue up 100s of images at 2-3MB/image, but not at 60MB at a time ... yet.  That could easily amount to 60x10 = 600MB of in flight data or more.  Should there be a limit as long as there is memory available?

Thanks
Tim

-----Original Message-----
From: Sarah Sharp [mailto:sarah.a.sharp@linux.intel.com] 
Sent: Monday, November 07, 2011 10:53 AM
To: Alan Stern; Tim Vlaar
Cc: Greg KH; Markus Rechberger; Alan Cox; USB list; LKML
Subject: Re: [Patch] Increase USBFS Bulk Transfer size

On Fri, Oct 14, 2011 at 08:33:29AM -0600, Greg KH wrote:
> On Fri, Oct 14, 2011 at 10:05:41AM -0400, Alan Stern wrote:
> > No, a much better approach is to remove all limits on individual 
> > transfer sizes and instead have a global limit on the total amount 
> > of all usbfs buffers in use at any time.  Maybe something like 16 
> > MB; at SuperSpeed, that's about about 30 ms worth of data.
> 
> That sounds quite reasonable.

Alan, won't this global limit on the usbfs URB buffer size effect userspace drivers that are currently allocating large amounts of buffers, but still respecting individual buffer limit of 16KB?  It seems like the patch has the potential to break userspace drivers.

I think that Point Grey's USB 3.0 webcam will be attempting to queue a series of bulk URBs that will be bigger than your 16MB global limit.

Tim, what is the total size of buffers that will be in flight at any one time for your device?

Sarah Sharp
