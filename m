Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab2DIWYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 18:24:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40983 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab2DIWYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 18:24:49 -0400
Date: Tue, 10 Apr 2012 02:24:43 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu,
        Michal Marek <mmarek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
Message-ID: <20120409222443.GW1625@moon>
References: <20120215143606.GA14037@redhat.com>
 <20120215160652.GA17680@redhat.com>
 <20120215162752.GF4533@moon>
 <20120409151027.7f3e0fa5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120409151027.7f3e0fa5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 03:10:27PM -0700, Andrew Morton wrote:
> Back on to kcmp.
> 
> On Wed, 15 Feb 2012 20:27:52 +0400
> Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
> > On Wed, Feb 15, 2012 at 05:06:52PM +0100, Oleg Nesterov wrote:
> > > Not a comment, but the question. I am just curious...
> > > 
> > > > +/*
> > > > + * We don't expose real in-memory order of objects for security
> > > > + * reasons, still the comparison results should be suitable for
> > > > + * sorting. Thus, we obfuscate kernel pointers values and compare
> > > > + * the production instead.
> > > > + */
> > > > +static unsigned long cookies[KCMP_TYPES][2] __read_mostly;
> > > > +
> > > > +static long kptr_obfuscate(long v, int type)
> > > > +{
> > > > +       return (v ^ cookies[type][0]) * cookies[type][1];
> > > > +}
> > > 
> > > OK, but why do we need this per type? Just to add more obfuscation
> > > or there is another reason?
> > 
> > Just to add more obfuscation.
> 
> Having re-read most of the (enormous) email discussion on the kcmp()
> syscall patch, I'm thinking:
> 
> - Nobody seems to understand the obfuscation logic.  Jon sounded
>   confused, Oleg sounds confused and it's rather unclear what it does,
>   how it does it and why it does it.

The obfuscation logic was done with great help from hpa@. And the main
idea was to have ordered results after obfuscation. Per-type noise increase
randomization of results. So Andrew, I actually dont know what to add
here. We don't want to provide kernel order back to user-space in
naked manner.

> 
> - Lots of people have looked at the code and made comments and there
>   have been lots of changes.  But we presently have zero Acked-by's and
>   Reviewed-by's.
> 

I guess I can ask hpa@ and Eric for Reviewed-by or Acked-by tag?

> I guess this means that at present nobody is aware of any issues with
> the proposal, btu nobody is terribly excisted about it either?
> 

I would rather say not much people yet use it.

> So what do people think?  Any issues?  Any nacks?  Should I sneak it
> into Linus this week or do we need to go another round with it all?
> 
> I'd like to at least have a fighting chance of understnading what's
> going on with that obfuscation code.

	Cyrill
