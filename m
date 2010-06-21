Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab0FUTqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 15:46:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab0FUTqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 15:46:12 -0400
Date: Mon, 21 Jun 2010 15:45:59 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] Add TAINT_HARDWARE_UNSUPPORTED flag
Message-ID: <20100621194559.GI3217@redhat.com>
References: <20100617134654.22523.39845.sendpatchset@prarit.bos.redhat.com>
 <20100617091322.b7d21473.randy.dunlap@oracle.com>
 <4C1A7D61.8010900@redhat.com>
 <20100621122145.76ebd7ac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100621122145.76ebd7ac.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 12:21:45PM -0700, Andrew Morton wrote:
> > @@ -243,6 +245,9 @@ void add_taint(unsigned flag)
> >  	 */
> >  	if (flag != TAINT_CRAP && flag != TAINT_WARN && __debug_locks_off())
> >  		printk(KERN_WARNING "Disabling lock debugging due to kernel taint\n");
> > +	if (flag == TAINT_HARDWARE_UNSUPPORTED)
> > +		printk(KERN_CRIT
> > +		       "WARNING: This system's hardware is unsupported.\n");
> >  
> >  	set_bit(flag, &tainted_mask);
> >  }
> 
> That's pretty user-hostile.  What are they to do - throw the entire
> computer away because it has the wrong type of mouse?
> 
> How about
> 
> void add_hardware_unsupported_taint(const char *hardware)
> {
> 	printk(KERN_CRIT
> 	       "Hardware device %s is unsupported by this kernel's vendor\n",
> 		hardware);
> 	add_taint(TAINT_HARDWARE_UNSUPPORTED);
> }
> 
> and
> 
> /*
>  * Don't call add_taint(TAINT_HARDWARE_UNSUPPORTED) directly - use
>  * add_hardware_unsupported_taint()
>  */
> #define TAINT_HARDWARE_UNSUPPORTED	12

Internally here that is how we planned on using the flag.  We weren't sure
if upstream would accept that piece or not, so we started with the flag
for now to at least reserve the bit.

But I can see your point about the other printk being a little
user-hostile if someone forgot to call the wrapper function.

I can respin with the wrapper function (Prarit is on vacation) or go with
Alan's idea of just reserving the upper few bits.

Thoughts?

Cheers,
Don
