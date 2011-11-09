Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab1KIMMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 07:12:14 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:18614 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1KIMMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 07:12:12 -0500
Date: Wed, 9 Nov 2011 07:11:55 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Arne Jansen <sensille@gmx.net>
Cc: Christoph Hellwig <hch@infradead.org>,
        Andrea Gelmini <andrea.gelmini@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs pull request
Message-ID: <20111109121155.GJ4149@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Arne Jansen <sensille@gmx.net>,
	Christoph Hellwig <hch@infradead.org>,
	Andrea Gelmini <andrea.gelmini@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20111106183851.GA4339@shiny>
 <CAK-xaQau04whLQm0Fz-fkCZ1AumLs84UiqGi0Rc=GZUzRvV7Gg@mail.gmail.com>
 <4EB7A6CC.5030502@gmx.net>
 <CAK-xaQbvpZQzPVxunSEVDzTXXzQ2HaQWHVR3BwR1iq95URWEdw@mail.gmail.com>
 <4EB7D2D8.2060505@gmx.net>
 <CAK-xaQbmY2Z3OJyQ211cUQn0CM2ho2U+UgpRKK9bUzxhEu6hzQ@mail.gmail.com>
 <4EB8DEAC.7000906@gmx.net>
 <20111109010701.GI4149@shiny>
 <20111109074847.GA16742@infradead.org>
 <4EBA42AF.3000501@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBA42AF.3000501@gmx.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4EBA6E14.00B2,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 10:06:55AM +0100, Arne Jansen wrote:
> On 09.11.2011 08:48, Christoph Hellwig wrote:
> > On Tue, Nov 08, 2011 at 08:07:01PM -0500, Chris Mason wrote:
> >> Looks like bio_add_page() is failing and we're getting the enomem from
> >> there.  LVM is only letting us put one page in each bio.
> > 
> > Yes, at the moment all bio based DM targets only allow single page I/O.
> 
> That's... unexpected. I guess this won't change with 3.3? For 3.3 I have
> to rework that part from scrub to account for Chris' bigblocks. If it can
> wait that long I'd prefer to fix both at once. Chris?

For 3.2, lets just do one page per bio and crank up the bios per device
to correspond.

-chris

