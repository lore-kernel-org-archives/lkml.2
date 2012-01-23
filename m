Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab2AWUVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 15:21:52 -0500
Received: from masquerade.micron.com ([137.201.242.130]:8301 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab2AWUVv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 15:21:51 -0500
From: "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
To: Christoph Hellwig <hch@infradead.org>,
        Asai Thambi SP <asaithambisp@gmail.com>
CC: Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONT - Type 2]" 
	<asamymuthupa@micron.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mtip32xx: rename the confusing argument 'barrier', of
 mtip_hw_submit_io()
Thread-Topic: [PATCH] mtip32xx: rename the confusing argument 'barrier', of
 mtip_hw_submit_io()
Thread-Index: AQHM1krvr24jYpMouE6ohbualiS1MpYa3o6A//+NCJA=
Date: Mon, 23 Jan 2012 20:21:35 +0000
Message-ID: <80B89753B40C5141A3E2D53FE7A2A8A919691477@NTXBOIMBX02.micron.com>
References: <CAKgD3HCqS8MkXbve3sT=8vZ4=Mvdtz-JDmy8N5t7moXcjSV1sg@mail.gmail.com>
 <20120123200923.GA9801@infradead.org>
In-Reply-To: <20120123200923.GA9801@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.201.88.182]
x-tm-as-product-ver: SMEX-10.0.0.4152-6.500.1024-18664.001
x-tm-as-result: No--39.552300-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Subject: Re: [PATCH] mtip32xx: rename the confusing argument 'barrier', of
> mtip_hw_submit_io()
> 
> On Wed, Jan 18, 2012 at 05:29:40PM -0800, Asai Thambi SP wrote:
> > This device does not support write cache, hence renamed confusing argument
> > 'barrier' to 'fua'. Setting of FUA bit is done in all IOs for compatibility.
> 
> That's not correct, you set it if REQ_FUA is set, which won't ever be
> set given how you configure the queue. I.e. it's dead code that can be
> removed.

That was done intentionally to minimize the scope of changes for future 
variants of the P320 that do support write cache.  We'll go ahead and
remove it, however, since it is presently dead code.
