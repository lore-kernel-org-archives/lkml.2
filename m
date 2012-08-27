Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab2H0V1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 17:27:23 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46514 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253Ab2H0V1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 17:27:21 -0400
Message-ID: <1346102820.8623.32.camel@lambeau>
Subject: Re: [PATCH RFC 0/3] Add guest cpu_entitlement reporting
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Reply-To: mjw@linux.vnet.ibm.com
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, peterz@infradead.org,
        mtosatti@redhat.com, glommer@parallels.com, mingo@redhat.com
Date: Mon, 27 Aug 2012 16:27:00 -0500
In-Reply-To: <503BD920.20603@redhat.com>
References: <20120823231346.11681.1502.stgit@lambeau>
	 <503BC298.3080306@redhat.com> <1346098984.8623.23.camel@lambeau>
	 <503BD920.20603@redhat.com>
Organization: IBM
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082721-8974-0000-0000-00000CA3648D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-27 at 13:31 -0700, Avi Kivity wrote:
> On 08/27/2012 01:23 PM, Michael Wolf wrote:
> > > 
> > > How would a guest know what its entitlement is?
> > > 
> > > 
> >
> > Currently the Admin/management tool setting up the guests will put it on
> > the qemu commandline.  From this it is passed via an ioctl to the host.
> > The guest will get the value from the host via a hypercall.
> >
> > In the future the host could try and do some of it automatically in some
> > cases. 
> 
> Seems to me it's a meaningless value for the guest.  Suppose it is
> migrated to a host that is more powerful, and as a result its relative
> entitlement is reduced.  The value needs to be adjusted.

This is why I chose to manage the value from the sysctl interface rather
than just have it stored as a value in /proc.  Whatever tool was used to
migrate the vm could hopefully adjust the sysctl value on the guest.
> 
> This is best taken care of from the host side.

Not sure what you are getting at here.  If you are running in a cloud
environment, you purchase a VM with the understanding that you are
getting certain resources.  As this type of user I don't believe you
have any access to the host to see this type of information.  So the
user still wouldnt have a way to confirm that they are receiving what
they should be in the way of processor resources.

Would you please elaborate a little more on this?
> 



