Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab0FATkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 15:40:11 -0400
Received: from xenotime.net ([72.52.115.56]:41388 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751762Ab0FATkJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 15:40:09 -0400
Date: Tue, 1 Jun 2010 12:39:59 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Giangiacomo Mariotti <gg.mariotti@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: Possible bug in 2.6.34 slub
Message-Id: <20100601123959.747228c6.rdunlap@xenotime.net>
In-Reply-To: <AANLkTilLq-hn59CBcLnOsnT37ZizQR6MrZX6btKPhfpb@mail.gmail.com>
References: <AANLkTimEFy6VM3InWlqhVooQjKGSD3yBxlgeRbQC2r1L@mail.gmail.com>
	<20100531165528.35a323fb.rdunlap@xenotime.net>
	<4C047CF9.9000804@tmr.com>
	<AANLkTilLq-hn59CBcLnOsnT37ZizQR6MrZX6btKPhfpb@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010 21:17:40 +0200 Giangiacomo Mariotti wrote:

> On Tue, Jun 1, 2010 at 5:22 AM, Bill Davidsen <davidsen@tmr.com> wrote:
> > Randy Dunlap wrote:
> >>
> >> On Tue, 1 Jun 2010 01:39:43 +0200 Giangiacomo Mariotti wrote:
> >>
> >>> Hi, I've recently noticed this line on the dmesg output(kernel 2.6.34):
> >>> [    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0,
> >>> CPUs=16, Nodes=1
> >>>
> >>> My cpu is an I7 920, so it has 4 cores and there's hyperthreading
> >>> enabled, so there are 8 logical cpus. Is this a bug?
> >>
> >>
> >> No, it's just some boot/init time information.
> >>
> > I would consider it a bug to claim CPUs=xx when xx is something other than
> > the number of cores or the number of SMT threads supported by the processor.
> > Of course if /proc/cpuinfo shows four siblings per core or something
> > exciting, then it's right and you have a CPU you can sell to gizmodo and
> > tell them a drunk left on the bar.
> >
> So....is it a bug or not?

Sorry, I think that I misread your report.
It does look like misinformation.
Let's cc Christoph Lameter & Pekka.


> The point is, I guess(didn't actually look at the code), if that's
> just the count of MAX number of cpus supported, which is a config time
>  define and then the actual count gets refined afterwards by slub
> too(because I know that the rest of the kernel knows I've got 4
> cores/8 logical cpus) or not. Is that it? If this is not the case(that
> is, it's not a static define used as a MAX value), then I can't see
> what kind of boot/init time info it is. If it's a boot-time info, it
> just means it's a _wrong_ boot-time info.



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
