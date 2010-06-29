Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab0F2SvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 14:51:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754548Ab0F2SvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 14:51:07 -0400
Date: Tue, 29 Jun 2010 11:50:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Liu Aleaxander <aleaxander@gmail.com>, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [uml-devel] [PATCH] um: Include missing header file in 
 os-linux/mem.c
Message-Id: <20100629115029.4eccea6e.akpm@linux-foundation.org>
In-Reply-To: <4C29B034.8070208@panasas.com>
References: <AANLkTikziSEDW07YiiJs6ny6JLhSQ-TGvdw_kTroIIx5@mail.gmail.com>
	<4C1809D3.7030707@panasas.com>
	<AANLkTikYn_EwizmUq6ZxitJ6ibCkr8Nfd4yslK_Bo0zR@mail.gmail.com>
	<4C29B034.8070208@panasas.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jun 2010 11:35:00 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On 06/15/2010 11:06 AM, Liu Aleaxander wrote:
> > The os-linux/mem.c file calls fchmod function, which is declared in sys/stat.h
> > header file, so include it.
> > 
> > Signed-off-by: Liu Aleaxander <Aleaxander@gmail.com>
> > ---
> >  arch/um/os-Linux/mem.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/um/os-Linux/mem.c b/arch/um/os-Linux/mem.c
> > index 93a11d7..e696144 100644
> > --- a/arch/um/os-Linux/mem.c
> > +++ b/arch/um/os-Linux/mem.c
> > @@ -10,6 +10,7 @@
> >  #include <errno.h>
> >  #include <fcntl.h>
> >  #include <string.h>
> > +#include <sys/stat.h>
> >  #include <sys/mman.h>
> >  #include <sys/param.h>
> >  #include "init.h"
> > 
> 
> On 06/15/2010 04:06 AM, Liu Aleaxander wrote:
> > On Wed, Jun 16, 2010 at 7:16 AM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> >>
> >> Yes. I have the same patch.
> >>
> >> Apparently it's new for Fedora 13. Previous Fedora's are compiling fine.
> > 
> > Same here:)
> > 
> >> I guess something has changed with the new gcc headers include sequence
> > 
> 
> Andrew? Jeff? someone?

I got it.

> I saw that some uml patches where pushed for -rc4. What about this patch?
> could some one push this patch? It's for FC13 compilation?
> 
> It might be needed for stable@ as well. I'll try to test with old Kernels.
> Am back on an FC12 in the office so it'll take some time.

Yes, it's needed in -stable.  People will want to compile 2.6.34 under
FC13.


