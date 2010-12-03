Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab0LCRyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 12:54:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab0LCRyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 12:54:09 -0500
Date: Fri, 3 Dec 2010 12:54:01 -0500
From: Neil Horman <nhorman@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Maxim Uvarov <muvarov@gmail.com>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: kdump broken on 2.6.37-rc4
Message-ID: <20101203175401.GE28603@hmsreliant.think-freely.org>
References: <20101203111623.GA2741@redhat.com>
 <AANLkTi=Xvbi5M_cNRL=wC+uwksG08SiCyWcqdmwB_5TU@mail.gmail.com>
 <20101203171147.GA2299@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101203171147.GA2299@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 06:11:48PM +0100, Stanislaw Gruszka wrote:
> On Fri, Dec 03, 2010 at 06:46:09PM +0300, Maxim Uvarov wrote:
> > 2010/12/3 Stanislaw Gruszka <sgruszka@redhat.com>:
> > > On my T-60 laptop, i686 system with 2.6.37-rc4 kernel,
> > > "echo c > /proc/sysrq-trigger" just hung the system. Kdump
> > > works on 2.6.36. Is this known issue? If not, what info
> > > I should provide to solve it (I think the easiest way
> > > to solve the problem would be bisect) ?
> > >
> > > Stanislaw
> > >
> > 
> > I tested x86 QEMU yesterday with the latest git. It worked.
> > Might be something target specific.., What does console print?
> 
> Here is the photo 
> http://people.redhat.com/sgruszka/20101203_005.jpg
> 
> There are two BUGs, first "sleeping function called from invalid
> context" and then "unable to handle null pointer dereference".
> 
The warning about sleeping is an artifact of the fact that we panic the box with
irqs disabled I think (although I would think the fault handler would have
re-enabled them properly).  Not sure what the NULL pointer is from
Neil

> Stanislaw
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
