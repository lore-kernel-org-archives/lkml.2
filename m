Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933937Ab1CXTpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:45:51 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:54967 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab1CXTps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:45:48 -0400
Date: Thu, 24 Mar 2011 20:45:46 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
Message-ID: <20110324194546.GA1741@gentoo.trippels.de>
References: <4D8B4A89.80608@fusionio.com>
 <20110324183019.GA1676@gentoo.trippels.de>
 <4D8B8F34.5000203@fusionio.com>
 <4D8B92AE.8090308@fusionio.com>
 <20110324185445.GB1696@gentoo.trippels.de>
 <4D8B9457.2020608@fusionio.com>
 <20110324193441.GA1723@gentoo.trippels.de>
 <4D8B9D2F.4010504@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8B9D2F.4010504@fusionio.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.03.24 at 20:36 +0100, Jens Axboe wrote:
> On 2011-03-24 20:34, Markus Trippelsdorf wrote:
> > On 2011.03.24 at 19:58 +0100, Jens Axboe wrote:
> >> On 2011-03-24 19:54, Markus Trippelsdorf wrote:
> >>> On 2011.03.24 at 19:51 +0100, Jens Axboe wrote:
> >>>> On 2011-03-24 19:36, Jens Axboe wrote:
> >>>>> On 2011-03-24 19:30, Markus Trippelsdorf wrote:
> >>>>>> On 2011.03.24 at 14:43 +0100, Jens Axboe wrote:
> >>>>>>>
> >>>>>>> This is the main pull request for the block IO layer and friends for
> >>>>>>> 2.6.39.
> >>>>>>
> >>>>>> This merge results in an early oops on my system (amd64, xfs).
> >>>>>> See the attached photo.
> >>>>>>
> >>>>>
> >>>>> Auch. Can you ensure that you have CONFIG_DEBUGINFO=y in your .config
> >>>>> and then do:
> >>>>>
> >>>>> $ gdb vmlinux
> >>>>> ...
> >>>>> l *cfq_insert_request+0x32
> >>>>>
> >>>>> and send that output?
> >>>>
> >>>> I took a closer look at the oops, and it most likely looks like q ==
> >>>> NULL (offset 0x18 == q->elevator). You left out the Code part, so I
> >>>> can't verify that for certain. Which makes very little sense. I take it
> >>>> this is 100% reproducible? When you send the gdb output, please also
> >>>> attach your .config.
> >>>
> >>> Yes, it's 100% reproducible here. My .config follows:
> >>
> >> Can you try this patch and see if it makes a difference?
> > 
> > There's no patch ;-)
> 
> Oh, here it is.
> 
It doesn't help, unfortunately. I still get the same BUG at
cfq_insert_request+0x32/0x4d0.

-- 
Markus
