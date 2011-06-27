Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab1F0SS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 14:18:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:42807 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab1F0SRF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 14:17:05 -0400
Subject: Re: [PATCH v2] futex: Fix regression with read only mappings
From: Peter Zijlstra <peterz@infradead.org>
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
Cc: Darren Hart <dvhart@linux.intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        eric.dumazet@gmail.com, david@rgmadvisors.com,
        linux-kernel@vger.kernel.org, zvonler@rgmadvisors.com,
        hughd@google.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110627164008.GA2095@BohrerMBP.rgmadvisors.com>
References: <20110623194949.GA2083@BohrerMBP.rgmadvisors.com>
	 <1308931186-28707-1-git-send-email-sbohrer@rgmadvisors.com>
	 <4E052DC3.6000902@linux.intel.com>
	 <20110627164008.GA2095@BohrerMBP.rgmadvisors.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 27 Jun 2011 20:15:59 +0200
Message-ID: <1309198559.6701.108.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-27 at 11:40 -0500, Shawn Bohrer wrote:
> > >     if (PageAnon(page_head)) {
> > 
> > This bit needs a comment too (unless I am the only one to whom this
> was
> > non-obvious), maybe:
> > 
> >               
> >               /*
> >                * A read-only anonymous page implies a COW on a
> >                * MAP_PRIVATE mapping. There is no sane use-case
> >                * for this scenario, return -EFAULT to userspace.
> >                */
> 
> Your comment is wrong.  Unfortunately the code is completly
> non-obvious to me as well, and I have no idea why it is there.  This
> little snippet came from Peter's suggested fix in:
> 
> https://lkml.org/lkml/2011/6/6/368
> 
> Sadly Peter's gone silent and I'm left wondering if he knew some
> corner case that should return -EFAULT with a RO anonymous page or if
> he _thought_ this was preventing RO MAP_PRIVATE mappings.  If it is
> the latter then this block can be removed because it does NOT do that.
> > > +           if (ro) {
> > > +                   err = -EFAULT;
> > > +                   goto out;
> > > +           }
> > > + 

Peter simply gets too much email.. anyway, the reason I put that there
is that a RO Anon page will never change and is thus a little pointless
to use for futex ops.


