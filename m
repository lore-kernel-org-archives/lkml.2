Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab0DFFnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 01:43:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:2012 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164Ab0DFFnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 01:43:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,370,1267430400"; 
   d="scan'208";a="262409584"
Date: Tue, 6 Apr 2010 13:43:05 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] /dev/mem: Allow rewinding
Message-ID: <20100406054305.GB18217@localhost>
References: <1270499041.9013.15.camel@edumazet-laptop> <1270501448.9013.23.camel@edumazet-laptop> <1270502345.9013.31.camel@edumazet-laptop> <y2h2375c9f91004052230i557aab00t7189369ba42f940d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <y2h2375c9f91004052230i557aab00t7189369ba42f940d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 01:30:29PM +0800, Américo Wang wrote:
> On Tue, Apr 6, 2010 at 5:19 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > Le lundi 05 avril 2010 à 23:04 +0200, Eric Dumazet a écrit :
> >> Andrew, commit dcefafb6ac90ece8d68a6c203105f3d313e52da4 seems to be the
> >> problem.
> >>
> >> It breaks rewinds (negative offsets to lseek (... SEEK_CUR))
> >>
> >
> > Here is a patch to make rewind working again on /dev/mem
> >
> > [PATCH] /dev/mem: Allow rewinding
> >
> > commit dcefafb6 (/dev/mem: dont allow seek to last page)
> > inadvertently disabled rewinding on /dev/mem.
> >
> > This broke x86info for example.
> >
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> > ---
> > diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> > index 1f3215a..3973a1d 100644
> > --- a/drivers/char/mem.c
> > +++ b/drivers/char/mem.c
> > @@ -710,11 +710,6 @@ static loff_t memory_lseek(struct file *file, loff_t offset, int orig)
> >        switch (orig) {
> >        case SEEK_CUR:
> >                offset += file->f_pos;
> > -               if ((unsigned long long)offset <
> > -                   (unsigned long long)file->f_pos) {
> > -                       ret = -EOVERFLOW;
> > -                       break;
> > -               }
> 
> Why completely dropping the overflow check? What you need to do is just
> adding the 'offset < 0' case check.

It will fall through to the next EOVERFLOW check in the SEEK_SET case :)

Thanks,
Fengguang

