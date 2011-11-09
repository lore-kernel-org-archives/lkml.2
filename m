Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab1KIBHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 20:07:14 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:22189 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab1KIBHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 20:07:13 -0500
Date: Tue, 8 Nov 2011 20:07:01 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Arne Jansen <sensille@gmx.net>
Cc: Andrea Gelmini <andrea.gelmini@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs pull request
Message-ID: <20111109010701.GI4149@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Arne Jansen <sensille@gmx.net>,
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB8DEAC.7000906@gmx.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4EB9D23E.0038,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 08:47:56AM +0100, Arne Jansen wrote:
> On 07.11.2011 13:50, Andrea Gelmini wrote:
> > 2011/11/7 Arne Jansen <sensille@gmx.net>:
> >> is it 32 or 64 bit?
> > 
> > 64bit.
> > Please take a look at my other reply.
> 
> Can you please have a look with strace to make sure it's
> really the ioctl the ENOMEM originates froM?

Looks like bio_add_page() is failing and we're getting the enomem from
there.  LVM is only letting us put one page in each bio.

-chris

