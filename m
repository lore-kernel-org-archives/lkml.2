Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab1IEPEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 11:04:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49827 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab1IEPEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 11:04:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kyungmin Park <kmpark@infradead.org>
Subject: Re: [RFC PATCH v2] support ioctl for tunable user request
Date: Mon, 5 Sep 2011 17:04:11 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <jaxboe@fusionio.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lin Ming <lxy@ss.pku.edu.cn>
References: <4E5B4AAF.2040101@samsung.com> <20110905121840.GA4768@infradead.org> <CAH9JG2U9uWMQYVjyH1HOmefe2mdf79fpR5mkjPW9nj4v2MrcwQ@mail.gmail.com>
In-Reply-To: <CAH9JG2U9uWMQYVjyH1HOmefe2mdf79fpR5mkjPW9nj4v2MrcwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109051704.12040.arnd@arndb.de>
X-Provags-ID: V02:K0:v0ppi3o9rGTlSLKB0iTSbkmtPCGuFzEt1eqvQYD288Y
 +lJ3l09wG5D0B0D1xRuyaQuCULbW1UkG8HnUnNCDc9/9d4iv55
 qdkgHjD2PaudG3oLzIpFmERV0ZlD68sCH3Ll3f2D9PMPhBL+LP
 +m5yAa6KhO1sl9YuAOORn/RNNboc6JRA8c9X/+TVYMaMwh1yCK
 ZyMbtJyNMzylkGtaCKzFVG2eoYyEQh1BwRulJIyQ/4YRmgpUvr
 y538zInW/GCpR3vcgavrYZcn02Nq68IL5rO8er7L9DPeZNyE4M
 1yeAmj5KDahi8A9lky4r+CfYCg8GM2AiBnSxntWHu88B3BrNCq
 iit7kkTMd0rkYqXGvEK8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 September 2011, Kyungmin Park wrote:
> On Mon, Sep 5, 2011 at 9:18 PM, Christoph Hellwig <hch@infradead.org> wrote:
> > On Mon, Sep 05, 2011 at 08:47:58PM +0900, Kyungmin Park wrote:
> >> The concept is similar with DISCARD request except no-wait for request complete
> >>
> >>  #define REQ_DISCARD            (1 << __REQ_DISCARD)
> >> +#define REQ_TUNE               (1 << __REQ_TUNE)
> >>
> >> As it's hard to detect the idle time at device level, user send the
> >> tune request to device when idle.
> >
> > But what does a "tune" request actually do?  It's an overly generic
> > term, but I still can't even think of what it would do to a storage
> 
> Yes, tune is generic term, that's reason to send the RFC patch, we
> consider the several names, but not found the proper name, if you
> suggest the proper name, it can change the proper one.

Would __REQ_GC as a shortcut for garbage collection fit? Right now,
I also think TUNE is not at all describing what we expect the drive
to do, but it's hard to come up with a term that is generic enough
to cover similar concepts in other hardware while still describing
what the drive does.

	Arnd
