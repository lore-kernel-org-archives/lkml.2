Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab1KIMNL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 07:13:11 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:24826 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1KIMNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 07:13:09 -0500
Date: Wed, 9 Nov 2011 07:12:49 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>, Arne Jansen <sensille@gmx.net>,
        Andrea Gelmini <andrea.gelmini@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs pull request
Message-ID: <20111109121249.GK4149@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Jan Schmidt <list.btrfs@jan-o-sch.net>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Arne Jansen <sensille@gmx.net>,
	Andrea Gelmini <andrea.gelmini@gmail.com>,
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
 <4EBA560B.1070509@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBA560B.1070509@jan-o-sch.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4EBA6E4B.0065,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 11:29:31AM +0100, Jan Schmidt wrote:
> Am 09.11.2011 08:48, schrieb Christoph Hellwig:
> >On Tue, Nov 08, 2011 at 08:07:01PM -0500, Chris Mason wrote:
> >>Looks like bio_add_page() is failing and we're getting the enomem from
> >>there.  LVM is only letting us put one page in each bio.
> >
> >Yes, at the moment all bio based DM targets only allow single page I/O.
> 
> Wait. If I got that correctly, each bio_add_page needs special
> ENOMEM treatment (assuming the target could always be a device
> mapper target), right?
> 
> "grep bio_add_page fs/btrfs/*.c" will make you unhappy.

You can always add a single page into a bio.  We do need to deal better
with mixed devices where some have a low limit and some a high limit.

-chris

