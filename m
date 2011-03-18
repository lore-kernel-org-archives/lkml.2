Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab1CRNV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 09:21:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756515Ab1CRNVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 09:21:23 -0400
Date: Fri, 18 Mar 2011 15:21:02 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jean-philippe.menil@univ-nantes.fr, stable@kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [stable] [PATCH] kvm: fix crash on irqfd deassign
Message-ID: <20110318132102.GD4221@redhat.com>
References: <20110317085333.GA7336@redhat.com>
 <20110317161308.GA12740@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317161308.GA12740@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 09:13:08AM -0700, Greg KH wrote:
> On Thu, Mar 17, 2011 at 10:53:33AM +0200, Michael S. Tsirkin wrote:
> > irqfd in kvm used flush_work incorrectly:
> > it assumed that work scheduled previously can't run
> > after flush_work, but since kvm uses a non-reentrant
> > workqueue (by means of schedule_work)
> > we need flush_work_sync to get that guarantee.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Reported-by: Jean-Philippe Menil <jean-philippe.menil@univ-nantes.fr>
> > Tested-by: Jean-Philippe Menil <jean-philippe.menil@univ-nantes.fr>
> > ---
> > 
> > Note: this is needed for kernel 2.6.39 and earlier.
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> for how to do this properly.
> 
> thanks,
> 
> greg k-h

What I missed is Cc: stable@kernel.org in the text?
OK, thanks for the correction.  Actually I forgot, Avi and Marcelo want
to handle stable patches for kvm themselves.
Avi, Marcelo, right?
So Greg, you can forget about this one for now.

Thanks,

-- 
MST
