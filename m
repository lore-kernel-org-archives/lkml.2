Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab2DHOF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 10:05:26 -0400
Received: from exprod8og119.obsmtp.com ([64.18.3.38]:36460 "HELO
	exprod8og119.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755430Ab2DHOFY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 10:05:24 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Apr 2012 10:05:24 EDT
X-AuditID: ac160a69-b7f676d00000405c-bf-4f81979a6fa1
From: Alex Lemberg <Alex.Lemberg@sandisk.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Rik van Riel <riel@redhat.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luca Porzio (lporzio)" <lporzio@micron.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Hyojin Jeong <syr.jeong@samsung.com>,
        "kernel-team@android.com" <kernel-team@android.com>,
        Yejin Moon <yejin.moon@samsung.com>, Hugh Dickins <hughd@google.com>,
        Yaniv Iarovici <Yaniv.Iarovici@sandisk.com>
Date: Sun, 8 Apr 2012 06:50:16 -0700
Subject: RE: swap on eMMC and other flash
Thread-Topic: swap on eMMC and other flash
Thread-Index: Ac0Q4Ow3IWP0RA9CRPesM7kXZgY/QAErJwSw
Message-ID: <D70D75BB1A02CA42A3E28AA542D282303A0661B561@MILMBMIPV3.sdcorp.global.sandisk.com>
References: <201203301744.16762.arnd@arndb.de>
 <201204021145.43222.arnd@arndb.de>
 <alpine.LSU.2.00.1204020734560.1847@eggly.anvils>
 <201204021455.25029.arnd@arndb.de>
In-Reply-To: <201204021455.25029.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsWyRoxnke6s6Y3+Bg0b9C3+TjrGbvH0Ux+L
	xY7tIhbvDz1jtri8aw6bxb01/1ktjvzvZ7TYOfslm8XfK+tZLKa0nWS1WH92G4sDt8e23dtY
	PX7/msTosWBTqcemT5PYPW7/e8zs8X19B5vH+31X2Tz6tqxi9Pi8SS6AM4rLJiU1J7MstUjf
	LoErY90l5YIOqYq3b56wNjD+Feli5OCQEDCRmLvcq4uRE8gUk7hwbz1bFyMXh5DANUaJR2ub
	WCCcY4wSN3dsYQKpYhPQlXh7ejcriC0ioCgx9cUzZpAiZoFJLBK9N9vZQRIsAioST0/vYQax
	hQU0JS7N2cAM0aAlMXfpbDYI20hi25TLYDavQKzEwpnfmSG2rWGUWLpoBwtIglNAX2L2p2tg
	mxmB7vt+ag2YzSwgLnHryXwmiLsFJJbsOc8MYYtKvHz8jxWiXlTiTvt6Roh6HYkFuz+xQdja
	EssWvmaGWCwocXLmE5YJjGKzkIydhaRlFpKWWUhaFjCyrGIUy83MKc5NTy0wNNIrTsxLySzO
	1kvOz93ECI5urswdjCsmmR9iFOBgVOLhfbKjwV+INbGsuDL3EKMEB7OSCC9zX6O/EG9KYmVV
	alF+fFFpTmrxIUYmDk6pBkbWmgjD/4pblk/U+/Fomf7cku1fnk6+7jP56T7WuL/fdfoVz8TU
	TSh06+5JmvTRJehljEDW0dXXbsS43RPsPLjNP6N/4qp1QX+2L30395Ki4g5tv44LLvPeLvY9
	kXvGefLEH2KZVgd+fcm8brr9wpJi5Zv2fxhvsry0S5nM0J//SG+F7bRnW8PmKrEUZyQaajEX
	FScCAHWah7zMAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Regarding time to issue discard/TRIM commands:
It would be advised to issue the discard command immediately after deleting/freeing a SWAP cluster (i.e. as soon as it becomes available).

Regarding SWAP page size:
Working with as large as SWAP pages as possible would be recommended (preferably 64KB). Also, writing in a sequential manner as much as possible while swapping large quantities of data is also advisable.

SWAP pages and corresponding transactions should be aligned to the SWAP page size (i.e. 64KB above), the alignment should correspond to the physical storage "LBA 0", i.e. to the first LBA of the storage device (and not to a logical/physical partition).

Thanks,
Alex

> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Monday, April 02, 2012 5:55 PM
> To: Hugh Dickins
> Cc: linaro-kernel@lists.linaro.org; Rik van Riel; linux-
> mmc@vger.kernel.org; Alex Lemberg; linux-kernel@vger.kernel.org; Luca
> Porzio (lporzio); linux-mm@kvack.org; Hyojin Jeong; kernel-
> team@android.com; Yejin Moon
> Subject: Re: swap on eMMC and other flash
>
> On Monday 02 April 2012, Hugh Dickins wrote:
> > On Mon, 2 Apr 2012, Arnd Bergmann wrote:
> > >
> > > Another option would be batched discard as we do it for file
> systems:
> > > occasionally stop writing to swap space and scanning for areas that
> > > have become available since the last discard, then send discard
> > > commands for those.
> >
> > I'm not sure whether you've missed "swapon --discard", which switches
> > on discard_swap_cluster() just before we allocate from a new cluster;
> > or whether you're musing that it's no use to you because you want to
> > repurpose the swap cluster to match erase block: I'm mentioning it in
> > case you missed that it's already there (but few use it, since even
> > done at that scale it's often more trouble than it's worth).
>
> I actually argued that discard_swap_cluster is exactly the right thing
> to do, especially when clusters match erase blocks on the less capable
> devices like SD cards.
>
> Luca was arguing that on some hardware there is no point in ever
> submitting a discard just before we start reusing space, because
> at that point it the hardware already discards the old data by
> overwriting the logical addresses with new blocks, while
> issuing a discard on all blocks as soon as they become available
> would make a bigger difference. I would be interested in hearing
> from Hyojin Jeong and Alex Lemberg what they think is the best
> time to issue a discard, because they would know about other hardware
> than Luca.
>
>       Arnd

PLEASE NOTE: The information contained in this electronic mail message is intended only for the use of the designated recipient(s) named above. If the reader of this message is not the intended recipient, you are hereby notified that you have received this message in error and that any review, dissemination, distribution, or copying of this message is strictly prohibited. If you have received this communication in error, please notify the sender by telephone or e-mail (as shown above) immediately and destroy any and all copies of this message in your possession (whether hard copies or electronically stored copies).

