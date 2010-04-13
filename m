Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab0DMUk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:40:27 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:40241 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab0DMUkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:40:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EgD76cx/1Bz/a9KQd6/Njoaee+o1NMFZO0NqkOiwPOwoafQtLKIRIdzmE/SmPoKVa0
         xU85gNiDxPlk7o+/xzH5dM9oFctwVD4/i5IqtffVzG49aXdgRi+EmRyflg1A3NX7aJIb
         SiZto/ZepVRD/Djbtgs8hTfn11uzR9dkIXzM8=
Date: Tue, 13 Apr 2010 22:10:18 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/6] procfs: Kill the bkl in ioctl
Message-ID: <20100413201014.GA5602@nowhere>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <201004121934.18307.arnd@arndb.de> <20100412215320.GF8285@nowhere> <201004131126.27482.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004131126.27482.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 11:26:27AM +0200, Arnd Bergmann wrote:
> On Monday 12 April 2010, Frederic Weisbecker wrote:
> > On Mon, Apr 12, 2010 at 07:34:17PM +0200, Arnd Bergmann wrote:
> > > 
> > > I think the rule set for the conversion needs to be one that can
> > > be done purely based on the code. How about this:
> > > 
> > > For each file operation {
> > >       if (uses f_pos) {
> > >               if (same module uses BKL)
> > >                       -> default_llseek
> > >               else
> > >                       -> generic_file_llseek
> > >       } else {
> > >               if (driver maintained)
> > >                       -> no_llseek (with maintainer ACK)
> > >               else
> > >                       -> noop_llseek
> > >       }
> > > }
> > 
> > It is also hard to determine a given driver really doesn't use
> > the bkl. A sole lock_kernel() grep in its files is not sufficient.
> > But a manual second pass should do the trick.
> 
> Why not? In my 2.6.33 based series, I have removed all implicit
> uses of the BKL, so we can be sure that it doesn't use the BKL
> unless the module is part of that series. The only two cases
> I can think of are:
> 
> - ioctl callback, which we should do in the same change, like I
> originally did. If a driver defines ->ioctl(), make it use
> deprecated_ioctl() and default_llseek()/deprecated_llseek.
> 
> - Any of the file systems from Jan's series.
> 
> 	Arnd


Ok looks like a good plan then.

Thanks.

