Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965028Ab2JXBbC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 21:31:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:41993 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964944Ab2JXBbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 21:31:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,638,1344236400"; 
   d="scan'208";a="237403139"
Date: Wed, 24 Oct 2012 09:30:47 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        linux-am33-list@redhat.com
Subject: Re: [next:akpm 155/157] drivers/char/random.c:827:3: warning: format
 '%zd' expects argument of type 'signed size_t', but argument 7 has type
 'size_t'
Message-ID: <20121024013047.GA11093@localhost>
References: <20121023101658.GC10451@localhost>
 <20121023145358.e3d17a47.akpm@linux-foundation.org>
 <20121024005612.GA4028@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121024005612.GA4028@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[add CC to mn10300/cris arch lists]

On Wed, Oct 24, 2012 at 08:56:12AM +0800, Fengguang Wu wrote:
> On Tue, Oct 23, 2012 at 02:53:58PM -0700, Andrew Morton wrote:
> > On Tue, 23 Oct 2012 18:16:58 +0800
> > Fengguang Wu <fengguang.wu@intel.com> wrote:
> > 
> > > Hi Jiri,
> > > 
> > > FYI, there are new compile warnings show up in
> > > 
> > > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git akpm
> > > head:   dbfe0815b4af06cc4ca6cd12b17e2d13ffaaf991
> > > commit: 0b1f5a647784c406ee33a6ddd3bb6382a2278111 [155/157] random: fix debug format strings
> > > config: mn10300-asb2364_defconfig # make ARCH=mn10300 asb2364_defconfig
> > > 
> > > All warnings:
> > > 
> > > drivers/char/random.c: In function 'xfer_secondary_pool':
> > > drivers/char/random.c:827:3: warning: format '%zd' expects argument of type 'signed size_t', but argument 7 has type 'size_t' [-Wformat]
> > > drivers/char/random.c: In function 'account':
> > > drivers/char/random.c:859:2: warning: format '%zd' expects argument of type 'signed size_t', but argument 5 has type 'size_t' [-Wformat]
> > > drivers/char/random.c:881:2: warning: format '%zd' expects argument of type 'signed size_t', but argument 5 has type 'size_t' [-Wformat]
> > > drivers/char/random.c: In function 'random_read':
> > > drivers/char/random.c:1141:3: warning: format '%zd' expects argument of type 'signed size_t', but argument 5 has type 'int' [-Wformat]
> > > drivers/char/random.c:1145:3: warning: format '%zd' expects argument of type 'signed size_t', but argument 5 has type 'int' [-Wformat]
> > > drivers/char/random.c:1145:3: warning: format '%zd' expects argument of type 'signed size_t', but argument 6 has type 'size_t' [-Wformat]
> > > drivers/char/random.c: In function 'write_pool':
> > > drivers/char/random.c:1213:11: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> > > 
> > 
> > Ah, I get it.  %zd vs %zu.  This?
> 
> With the patch, there are still errors (below). I think the reason of the
> warnings is, (size_t * 8) makes it an (int) because the constant 8 is (int).

Sorry (size_t * 8) becomes (unsigned int) because (size_t) is (unsigned int).

And the problem is specific to mn10300/cris: (size_t * 8) is no longer (size_t),
which triggers the gcc warnings discussed here.

Thanks,
Fengguang

>   CC      drivers/char/random.o
> /c/wfg/linux/drivers/char/random.c: In function 'xfer_secondary_pool':
> /c/wfg/linux/drivers/char/random.c:827:3: warning: format '%zu' expects argument of type 'size_t', but argument 7 has type 'unsigned int' [-Wformat]
> /c/wfg/linux/drivers/char/random.c: In function 'account':
> /c/wfg/linux/drivers/char/random.c:859:2: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'unsigned int' [-Wformat]
> /c/wfg/linux/drivers/char/random.c:881:2: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'unsigned int' [-Wformat]
> /c/wfg/linux/drivers/char/random.c: In function 'random_read':
> /c/wfg/linux/drivers/char/random.c:1141:3: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'int' [-Wformat]
> /c/wfg/linux/drivers/char/random.c:1145:3: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'int' [-Wformat]
> /c/wfg/linux/drivers/char/random.c:1145:3: warning: format '%zu' expects argument of type 'size_t', but argument 6 has type 'unsigned int' [-Wformat]
> 
> And that behavior is depending on arch. Changing %zu to %u will make
> mn10300/parisc/i386 etc. archs compile cleanly, however x86_64 goes
> wrong like this:
> 
> /c/wfg/linux/drivers/char/random.c:827:3: warning: format ‘%u’ expects argument of type ‘unsigned int’, but argument 7 has type ‘size_t’ [-Wformat]
> 
> So in x86_64, (size_t * 8) is still of type size_t.
> 
> Thanks,
> Fengguang
> ---
> > 
> > From: Andrew Morton <akpm@linux-foundation.org>
> > Subject: random-fix-debug-format-strings-fix
> > 
> > s/%zd/%zu/ for unsigned `size_t'
> > 
> > Cc: Jiri Kosina <jkosina@suse.cz>
> > Cc: Theodore Ts'o <tytso@mit.edu>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  drivers/char/random.c |   12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff -puN drivers/char/random.c~random-fix-debug-format-strings-fix drivers/char/random.c
> > --- a/drivers/char/random.c~random-fix-debug-format-strings-fix
> > +++ a/drivers/char/random.c
> > @@ -825,7 +825,7 @@ static void xfer_secondary_pool(struct e
> >  		bytes = min_t(int, bytes, sizeof(tmp));
> >  
> >  		DEBUG_ENT("going to reseed %s with %d bits "
> > -			  "(%zd of %d requested)\n",
> > +			  "(%zu of %d requested)\n",
> >  			  r->name, bytes * 8, nbytes * 8, r->entropy_count);
> >  
> >  		bytes = extract_entropy(r->pull, tmp, bytes,
> > @@ -856,7 +856,7 @@ static size_t account(struct entropy_sto
> >  	spin_lock_irqsave(&r->lock, flags);
> >  
> >  	BUG_ON(r->entropy_count > r->poolinfo->POOLBITS);
> > -	DEBUG_ENT("trying to extract %zd bits from %s\n",
> > +	DEBUG_ENT("trying to extract %zu bits from %s\n",
> >  		  nbytes * 8, r->name);
> >  
> >  	/* Can we pull enough? */
> > @@ -878,7 +878,7 @@ static size_t account(struct entropy_sto
> >  		}
> >  	}
> >  
> > -	DEBUG_ENT("debiting %zd entropy credits from %s%s\n",
> > +	DEBUG_ENT("debiting %zu entropy credits from %s%s\n",
> >  		  nbytes * 8, r->name, r->limit ? "" : " (unlimited)");
> >  
> >  	spin_unlock_irqrestore(&r->lock, flags);
> > @@ -1138,11 +1138,11 @@ random_read(struct file *file, char __us
> >  		if (n > SEC_XFER_SIZE)
> >  			n = SEC_XFER_SIZE;
> >  
> > -		DEBUG_ENT("reading %zd bits\n", n*8);
> > +		DEBUG_ENT("reading %zu bits\n", n*8);
> >  
> >  		n = extract_entropy_user(&blocking_pool, buf, n);
> >  
> > -		DEBUG_ENT("read got %zd bits (%zd still needed)\n",
> > +		DEBUG_ENT("read got %zu bits (%zu still needed)\n",
> >  			  n*8, (nbytes-n)*8);
> >  
> >  		if (n == 0) {
> > @@ -1210,7 +1210,7 @@ write_pool(struct entropy_store *r, cons
> >  	const char __user *p = buffer;
> >  
> >  	while (count > 0) {
> > -		bytes = min(count, sizeof(buf));
> > +		bytes = min_t(size_t, count, sizeof(buf));
> >  		if (copy_from_user(&buf, p, bytes))
> >  			return -EFAULT;
> >  
> > _
