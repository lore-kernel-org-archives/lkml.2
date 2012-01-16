Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab2APTUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 14:20:36 -0500
Received: from masquerade.micron.com ([137.201.242.130]:56912 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab2APTUe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 14:20:34 -0500
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jan 2012 14:20:34 EST
From: "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONT - Type 2]" 
	<asamymuthupa@micron.com>
Subject: RE: [GIT PULL] Block drivers for 3.3-rc
Thread-Topic: [GIT PULL] Block drivers for 3.3-rc
Thread-Index: AQHM04BRTFSvEq7uCkSDrsB9947OuZYPXgOg
Date: Mon, 16 Jan 2012 19:13:18 +0000
Message-ID: <80B89753B40C5141A3E2D53FE7A2A8A91968752B@NTXBOIMBX02.micron.com>
References: <4F12A1CC.50105@kernel.dk>
 <20120115103331.GA31956@infradead.org> <4F12C4ED.6060301@kernel.dk>
In-Reply-To: <4F12C4ED.6060301@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.201.88.182]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.500.1024-18650.001
X-TM-AS-Result: No--21.257700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 2012-01-15 11:33, Christoph Hellwig wrote:
> > On Sun, Jan 15, 2012 at 10:52:12AM +0100, Jens Axboe wrote:
> >> Hi Linus,
> >>
> >> Please see below for the 3.3-rc1 block driver pull request.
> >>
> >> Essentially two different categories here:
> >>
> >> - Adds the driver for the Micron RealSSD P320 pci-express flash card.
> >
> > The REQ_FUA and REQ_FLUSH handling in it is still completely broken,
> > with no attempt to fix it since it last came up.
> >
> > So a pretty clear NAK on that driver from me.
> 
> Good point, I had forgotten about the ordered writes, I believe the rest
> of the items have been handled. The driver/hw, as it stands, does not
> reorder writes and it doesn't have a write back cache. So it should
> actually be safe. Any acked write is stable. Sam, correct me if I'm
> wrong.

That's correct, Jens.  Neither the driver nor the hardware reorders commands so we choose to ignore barriers.  I see now that the "barrier" parameter in the function is rather unfortunately named.  We'll fix that.

-Sam
