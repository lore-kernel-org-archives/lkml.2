Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab2G0TxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 15:53:23 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:40659 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab2G0TxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 15:53:22 -0400
Date: Fri, 27 Jul 2012 21:53:20 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Stiegmann <astiegmann@vmware.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com, vm-crosstalk@vmware.com, cschamp@vmware.com,
        gregkh@linuxfoundation.org
Subject: Re: [vmw_vmci 11/11] Apply the header code to make VMCI build
Message-ID: <20120727195320.GA5822@merkur.ravnborg.org>
References: <20120727103455.GA4639@merkur.ravnborg.org> <1693394101.5749000.1343409643934.JavaMail.root@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1693394101.5749000.1343409643934.JavaMail.root@vmware.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +
> > > +#define CAN_BLOCK(_f) (!((_f) & VMCI_QPFLAG_NONBLOCK))
> > > +#define QP_PINNED(_f) ((_f) & VMCI_QPFLAG_PINNED)
> > 
> > Looks like poor obscufation.
> > Use a statis inline function if you need a helper for this.
> 
> These definitions are intended more as a helper to make reading the code easier.  IMHO ts a lot easier to read
> 
> if (CAN_BLOCK(flags))
> 
> compared to 
> 
> if (!(flags & VMCI_QPFLAG_NONBLOCK))
> 
> Wouldn't you agree?  I'm not sure something this simple warrants a static inline
> function but I don't see any harm in converting it over to that.

I would put it the other way around. I cannot see that such simple stuff warrants a #define.
A static inline is (almost) always preferable to hide code in a macro.

For once you get better type-checks.
And semantics are also much simpler. With a macro you can do so many silly things.

	Sam
