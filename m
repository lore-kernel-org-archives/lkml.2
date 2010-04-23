Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab0DWLyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 07:54:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:54317 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756662Ab0DWLyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 07:54:04 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1+72OYGF5i7sFCbpsaZvVHVdKemXsLYDtLjdyNX1b
	1mUer5FaebM3Fg
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: patch md-raid5-allow-for-more-than-2-31-chunks.patch added to 2.6.33-stable tree
Date: Fri, 23 Apr 2010 13:53:52 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.33-2.slh.8-sidux-686; KDE/4.4.2; i686; ; )
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       king.br@gmail.com, stable@kernel.org
References: <12718801381479@kroah.org> <201004221336.28530.s.L-H@gmx.de> <20100423031100.GA1637@suse.de>
In-Reply-To: <20100423031100.GA1637@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004231353.56030.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46999999999999997
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Friday 23 April 2010, Greg KH wrote:
> On Thu, Apr 22, 2010 at 01:36:26PM +0200, Stefan Lippers-Hollmann wrote:
> > Hi
> > 
> > On Thursday 22 April 2010, Neil Brown wrote:
> > > On Thu, 22 Apr 2010 04:08:30 +0200
> > > "Stefan Lippers-Hollmann" <s.L-H@gmx.de> wrote:
> > > > On Thursday 22 April 2010, gregkh@suse.de wrote:
> > [...]
> > > > > From 35f2a591192d0a5d9f7fc696869c76f0b8e49c3d Mon Sep 17 00:00:00 2001
> > > > > From: NeilBrown <neilb@suse.de>
> > > > > Date: Tue, 20 Apr 2010 14:13:34 +1000
> > > > > Subject: md/raid5: allow for more than 2^31 chunks.
> > > > > 
> > > > > From: NeilBrown <neilb@suse.de>
> > > > > 
> > > > > commit 35f2a591192d0a5d9f7fc696869c76f0b8e49c3d upstream.
> > > > > 
> > > > > With many large drives and small chunk sizes it is possible
> > > > > to create a RAID5 with more than 2^31 chunks.  Make sure this
> > > > > works.
> > > > > 
> > > > > Reported-by: Brett King <king.br@gmail.com>
> > > > > Signed-off-by: NeilBrown <neilb@suse.de>
> > > > > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > > > 
> > > > This patch, as part of the current 2.6.33 stable queue, breaks compiling
> > > > on i386 (CONFIG_LBDAF=y) for me (amd64 builds fine):
> > > > 
> > > > [...]
> > > >   BUILD   arch/x86/boot/bzImage
> > > > Root device is (254, 6)
> > > > Setup is 12700 bytes (padded to 12800 bytes).
> > > > System is 2415 kB
> > > > CRC db6fa5fa
> > > > Kernel: arch/x86/boot/bzImage is ready  (#1)
> > > > ERROR: "__umoddi3" [drivers/md/raid456.ko] undefined!
> > > > 
> > > > reverting just this patch fixes the problem for me.
> > > 
> > > Thanks for testing and reporting.
> > > 
> > > If you could verify that this additional patch fixes the compile error I
> > > would really appreciate it.
> > 
> > I can confirm that this patch on top of the original 
> > md-raid5-allow-for-more-than-2-31-chunks.patch fixes the build problem on 
> > i386 for me (amd64 continues to build fine as well).
> > 
> > Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
> 
> Neil, care to push this to Linus?

Gitweb:     http://git.kernel.org/linus/6e3b96ed610e5a1838e62ddae9fa0c3463f235fa
Commit:     6e3b96ed610e5a1838e62ddae9fa0c3463f235fa
Parent:     35f2a591192d0a5d9f7fc696869c76f0b8e49c3d
Author:     NeilBrown <neilb@suse.de>
AuthorDate: Fri Apr 23 07:08:28 2010 +1000
Committer:  NeilBrown <neilb@suse.de>
CommitDate: Fri Apr 23 07:08:28 2010 +1000

    md/raid5: fix previous patch.
    
    Previous patch changes stripe and chunk_number to sector_t but
    mistakenly did not update all of the divisions to use sector_dev().
    
    This patch changes all the those divisions (actually the '%' operator)
    to sector_div.
    
    Signed-off-by: NeilBrown <neilb@suse.de>
    Cc: stable@kernel.org
    Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>

Regards
	Stefan Lippers-Hollmann
