Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab2G0UHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 16:07:11 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:53948 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752549Ab2G0UHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 16:07:07 -0400
Date: Fri, 27 Jul 2012 13:07:07 -0700 (PDT)
From: Andrew Stiegmann <astiegmann@vmware.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com, vm-crosstalk@vmware.com, cschamp@vmware.com,
        gregkh@linuxfoundation.org
Message-ID: <1365693798.5911635.1343419627088.JavaMail.root@vmware.com>
In-Reply-To: <20120727195320.GA5822@merkur.ravnborg.org>
Subject: Re: [vmw_vmci 11/11] Apply the header code to make VMCI build
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.60.13]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC20 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Sam Ravnborg" <sam@ravnborg.org>
> To: "Andrew Stiegmann" <astiegmann@vmware.com>
> Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
> vm-crosstalk@vmware.com, cschamp@vmware.com, gregkh@linuxfoundation.org
> Sent: Friday, July 27, 2012 12:53:20 PM
> Subject: Re: [vmw_vmci 11/11] Apply the header code to make VMCI build
> 
> > > > +
> > > > +#define CAN_BLOCK(_f) (!((_f) & VMCI_QPFLAG_NONBLOCK))
> > > > +#define QP_PINNED(_f) ((_f) & VMCI_QPFLAG_PINNED)
> > > 
> > > Looks like poor obscufation.
> > > Use a statis inline function if you need a helper for this.
> > 
> > These definitions are intended more as a helper to make reading the
> > code easier.  IMHO ts a lot easier to read
> > 
> > if (CAN_BLOCK(flags))
> > 
> > compared to
> > 
> > if (!(flags & VMCI_QPFLAG_NONBLOCK))
> > 
> > Wouldn't you agree?  I'm not sure something this simple warrants a
> > static inline
> > function but I don't see any harm in converting it over to that.
> 
> I would put it the other way around. I cannot see that such simple
> stuff warrants a #define.
> A static inline is (almost) always preferable to hide code in a
> macro.
> 
> For once you get better type-checks.
> And semantics are also much simpler. With a macro you can do so many
> silly things.

Fair enough.  I'll make them into static inline functions.

> 	Sam
> 
