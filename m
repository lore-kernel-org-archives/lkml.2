Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573Ab0FBTng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 15:43:36 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:64116 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab0FBTne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 15:43:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T3pqPlnlnfx/Ga5bv/8kxfBFb+oA1uklrRZl1eCjkU1sV/3k8yik9IBlS3zskgyirg
         +qgn2mst8RHSal6J3Er0Nmgha3fFQTUbjfZUjSdOmyiiSkzCwz+FGANs5Q0ZzTobO9CH
         SrpsaqTKJGH+BwRHMW2UiARdtBmmDKcCmo0KA=
Date: Wed, 2 Jun 2010 21:43:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Don Zickus <dzickus@redhat.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       linux-ide@vger.kernel.org
Subject: Re: hibernation hangs with ATA errors (lockup_detector bug)
Message-ID: <20100602194336.GB5164@nowhere>
References: <4C03C608.1040600@gmail.com> <20100601135004.GP15159@redhat.com> <4C051D44.7040203@gmail.com> <20100602184459.GA15159@redhat.com> <20100602191336.GA5164@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602191336.GA5164@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 09:13:40PM +0200, Frederic Weisbecker wrote:
> On Wed, Jun 02, 2010 at 02:44:59PM -0400, Don Zickus wrote:
> > On Tue, Jun 01, 2010 at 04:46:28PM +0200, Jiri Slaby wrote:
> > > On 06/01/2010 03:50 PM, Don Zickus wrote:
> > > > On Mon, May 31, 2010 at 04:22:00PM +0200, Jiri Slaby wrote:
> > > >> Hi,
> > > >>
> > > >> with -next I get the following errors while trying to hibernate in
> > > >> qemu-kvm after the image is stored on disk:
> > > > 
> > > > Is this the host that is hibernating or the guest?
> > > 
> > > Guest.
> > > 
> > > > KVM guests don't emulate the performance counters, so the nmi piece
> > > > shouldn't be functioning and the soft lockup piece just sits on top of an
> > > > hrtimer, so off the top of my head it is hard to imagine it intefering
> > > > with a sata driver.
> > > > 
> > > > I'll need your whole boot up log to see how the lockup detector
> > > > initialized itself.
> > 
> > Ok, so I found out what is causing the problem, not entirely sure why or
> > what the right fix is, but this patch should do the trick.
> > 
> > This is probably one of those fixing the symptoms but not the problem patch,
> > but I don't know enough about suspend/resume to understand what the real
> > problem is.
> 
> 
> So the problem is that we stop the cpu hotplug notifying, I guess this prevents
> some ata callbacks to execute in the cpu hotplug notifier and then provoke this
> crash.


(Adding more people in Cc)


But I'm eventually surprised about this: stopping the cpu hotplug callbacks
prevents some ATA resume callbacks to execute.

Does that mean some ata resume path are done from a cpu hotplug notifier?
That looks weird.

