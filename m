Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab1HIUWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 16:22:43 -0400
Received: from mx2.parallels.com ([64.131.90.16]:39858 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735Ab1HIUWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 16:22:42 -0400
From: James Bottomley <jbottomley@parallels.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Stable-review] [28/55] [SCSI] fix crash in scsi_dispatch_cmd()
Thread-Topic: [Stable-review] [28/55] [SCSI] fix crash in scsi_dispatch_cmd()
Thread-Index: AQHMVS8JppVwAs6Xz0uGJqTkQMem7ZUTpWwAgAASYoCAAbdUAA==
Date: Tue, 9 Aug 2011 20:22:37 +0000
Message-ID: <1312921356.8648.13.camel@mulgrave>
References: <20110806000251.682788533@clark.kroah.org>
	 <1312739411.2591.1026.camel@deadeye> <1312739484.2591.1027.camel@deadeye>
	 <20110808170424.GB27419@suse.de>  <20110808181011.GE29924@decadent.org.uk>
In-Reply-To: <20110808181011.GE29924@decadent.org.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [76.243.235.53]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A84AD9E80330C946A80C9257334FF172@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p79KMpF3032529

On Mon, 2011-08-08 at 19:10 +0100, Ben Hutchings wrote:
> On Mon, Aug 08, 2011 at 10:04:24AM -0700, Greg KH wrote:
> > On Sun, Aug 07, 2011 at 06:51:24PM +0100, Ben Hutchings wrote:
> > > On Sun, 2011-08-07 at 18:50 +0100, Ben Hutchings wrote:
> > > > On Fri, 2011-08-05 at 17:01 -0700, Greg KH wrote:
> > > > > 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
> > > > > 
> > > > > ------------------
> > > > > 
> > > > > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > > > 
> > > > > commit bfe159a51203c15d23cb3158fffdc25ec4b4dda1 upstream.
> > > > > 
> > > > > USB surprise removal of sr is triggering an oops in
> > > > > scsi_dispatch_command().  What seems to be happening is that USB is
> > > > > hanging on to a queue reference until the last close of the upper
> > > > > device, so the crash is caused by surprise remove of a mounted CD
> > > > > followed by attempted unmount.
> > > > [...]
> > > > 
> > > > This has been reported in 2.6.39.y and 3.0, but not in 2.6.32.y.
> > > 
> > > That is, AFAIK.
> > 
> > Oops, good catch, I've dropped this from the .32 and .33 queue now, it's
> > not needed there at all.
>  
> Well, it is entirely possible that I am confusing multiple bugs (I
> actualy attempted to delete this message from my outgoing mail queue
> as I was becoming less confident about it).  I assume James can
> confirm one way or the other.

No ... There is an original bug somewhere that might permeate to 2.6.32
which the patch series fixes, but I don't think all the precursors were
stable tagged and it's a race condition which only started showing up in
2.6.38.

James

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
