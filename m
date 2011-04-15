Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab1DOOqC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 10:46:02 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:31307 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751219Ab1DOOqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 10:46:00 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: fnPJROQVM1ly00kPbIFWap8XmTwszcKh7zynnNvWRVMQzZk
 sOLPa.aHuUVYz4Be_H0qmrIqd.lhKQfupGPgjoQqQn8Ae7SIvFA0HymhEbsJ
 R2LRm241OLJCrn26ey8cc.F7dwnfv.6CjZK4r3lHa5Satncut30jpbPs8tQQ
 ZXfI32LFG4EzFbob600_QXHFH6B8dQw3w9ob9UwtmVSYJ21POPlab0AwfFTj
 4uL0sTFNhTGNIZ.piPOZvSiNOWfqjuXrrIs7LlZlp5Jjgm5tP.n9D.0Dfog8
 xcpILWwU828kmvepckS4zyGczTL_GEc7IK7IZiQsXw9kNowN7
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 15 Apr 2011 09:45:56 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Dave Hansen <dave@sr71.net>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jan Beulich <JBeulich@novell.com>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: BUILD_BUG_ON() breaks sparse gfp_t checks
In-Reply-To: <1302817191.16562.1036.camel@nimitz>
Message-ID: <alpine.DEB.2.00.1104150945230.5863@router.home>
References: <1302795695.14658.6801.camel@nimitz>  <20110414132220.970cfb2a.akpm@linux-foundation.org> <1302817191.16562.1036.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011, Dave Hansen wrote:

> On Thu, 2011-04-14 at 13:22 -0700, Andrew Morton wrote:
> > The kernel calls gfp_zone() with a constant arg in very few places.
> > This?
> >
> > --- a/include/linux/gfp.h~a
> > +++ a/include/linux/gfp.h
> > @@ -249,14 +249,9 @@ static inline enum zone_type gfp_zone(gf
> >
> >         z = (GFP_ZONE_TABLE >> (bit * ZONES_SHIFT)) &
> >                                          ((1 << ZONES_SHIFT) - 1);
> > -
> > -       if (__builtin_constant_p(bit))
> > -               BUILD_BUG_ON((GFP_ZONE_BAD >> bit) & 1);
> > -       else {
> >  #ifdef CONFIG_DEBUG_VM
> > -               BUG_ON((GFP_ZONE_BAD >> bit) & 1);
> > +       BUG_ON((GFP_ZONE_BAD >> bit) & 1);
> >  #endif
> > -       }
> >         return z;
> >  }
>
> That definitely makes sparse happier.  I hope the folks on cc will chime
> in if they wanted something special at build time.

You can also remove the #ifdef. Use VM_BUG_ON.

