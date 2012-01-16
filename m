Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab2APTUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 14:20:38 -0500
Received: from masquerade.micron.com ([137.201.242.130]:56912 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab2APTUg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 14:20:36 -0500
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jan 2012 14:20:34 EST
From: "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONT - Type 2]" 
	<asamymuthupa@micron.com>
Subject: RE: [GIT PULL] Block drivers for 3.3-rc
Thread-Topic: [GIT PULL] Block drivers for 3.3-rc
Thread-Index: AQHM04BRTFSvEq7uCkSDrsB9947OuZYNYY6ngAH6PSA=
Date: Mon, 16 Jan 2012 19:10:10 +0000
Message-ID: <80B89753B40C5141A3E2D53FE7A2A8A91968751D@NTXBOIMBX02.micron.com>
References: <4F12A1CC.50105@kernel.dk>
 <20120115103331.GA31956@infradead.org> <4F12C4ED.6060301@kernel.dk>
 <20120115124405.GA7389@infradead.org> <4F12CB96.4030704@kernel.dk>
In-Reply-To: <4F12CB96.4030704@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.201.88.182]
x-tm-as-product-ver: SMEX-10.0.0.4152-6.500.1024-18650.001
x-tm-as-result: No--51.809900-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 2012-01-15 13:44, Christoph Hellwig wrote:
> > On Sun, Jan 15, 2012 at 01:22:05PM +0100, Jens Axboe wrote:
> >> Good point, I had forgotten about the ordered writes, I believe the rest
> >> of the items have been handled. The driver/hw, as it stands, does not
> >> reorder writes and it doesn't have a write back cache. So it should
> >> actually be safe. Any acked write is stable. Sam, correct me if I'm
> >> wrong.
> >
> > I tried to get that out of the micron folks a while ago but don't
> > remember getting an answer.  If that's actually tree please remove
> > the (misnamed) barrier argument from mtip_hw_submit_io, and maybe add
> > a comment that the current hardware can't have a volatile write cache.
> 
> Sure, will do post pull to not mess up the current pull request.
> 
> > Btw, does the hardware claim to have writeback caches in the ATA
> > IDENTIFY words related to it?
> 
> I'll let Sam answer this one and the question above, it's better if it
> comes from the source.

Apologies for not communicating this clearly to the mailing list.  The P320 does not have and will not claim writeback cache support in the IDENTIFY.

We will promptly submit a patch that renames the barrier argument and describes the current state of writeback cache support.

Thanks,
-Sam
