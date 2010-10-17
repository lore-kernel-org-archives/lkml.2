Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab0JQSwK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 14:52:10 -0400
Received: from canuck.infradead.org ([134.117.69.58]:41781 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508Ab0JQSwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 14:52:08 -0400
Date: Sun, 17 Oct 2010 14:52:03 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Paris <eparis@parisplace.org>, eparis@redhat.com,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org, hpa@zytor.com,
        devel@lists.fedoraprojet.org
Subject: Re: ima: use of radix tree cache indexing == massive waste of memory?
Message-ID: <20101017185203.GD28060@infradead.org>
References: <20101016065206.GO4681@dastard>
 <20101016192027.GA6883@infradead.org>
 <1287295077.3020.83.camel@localhost.localdomain>
 <1287313332.1998.172.camel@laptop>
 <AANLkTinNbF9=5Ojn8kKEvSkGbpqQw+DGKyRWhAD1AYZK@mail.gmail.com>
 <1287323960.1998.360.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287323960.1998.360.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 03:59:20PM +0200, Peter Zijlstra wrote:
> Well, it does suck it needs to bloat data and code when its effectively
> disabled. Isn't there a way to gather this data before we enable it, eg.
> scan the files list on enable or somesuch?
> 
> I mean, if you mandate an external storage you might as well extend
> struct inode, that's cheaper in each respect.

That's in fact what it did initially.  While IBM claimed it would never
be enabled in distros and this would be fine I feared this would not be
true and told them to not make it have overhead if compiled in but not
used.

Turns out I wa right in my fear that IBM pressured distros to enable
it anyway.  And turns out that I should have verified they didn't
actually mess it up instead of expecting people to get such trivial
things right.

> Me, I'm henceforth making sure to have CONFIG_IMA disabled...

Yeah.

> >  but it doesn't
> > help the fact that the suggested structure for storage (the radix
> > tree) is apparently quite inefficient.  I'd love to hear other
> > suggestions for a better structure.... 
> 
> radix tree is efficient for dense sets, not sparse sets.

Which actually works just fine for inodes on many filesystems if you
use the right key.
