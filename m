Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab1CVMvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 08:51:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699Ab1CVMvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 08:51:11 -0400
Date: Tue, 22 Mar 2011 14:50:53 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jean-philippe.menil@univ-nantes.fr,
        stable@kernel.org, Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH] kvm: fix crash on irqfd deassign
Message-ID: <20110322125053.GB32414@redhat.com>
References: <20110317085333.GA7336@redhat.com>
 <4D889807.6000307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D889807.6000307@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 02:37:27PM +0200, Avi Kivity wrote:
> On 03/17/2011 10:53 AM, Michael S. Tsirkin wrote:
> >irqfd in kvm used flush_work incorrectly:
> >it assumed that work scheduled previously can't run
> >after flush_work, but since kvm uses a non-reentrant
> >workqueue (by means of schedule_work)
> >we need flush_work_sync to get that guarantee.
> >
> >Signed-off-by: Michael S. Tsirkin<mst@redhat.com>
> >Reported-by: Jean-Philippe Menil<jean-philippe.menil@univ-nantes.fr>
> >Tested-by: Jean-Philippe Menil<jean-philippe.menil@univ-nantes.fr>
> >---
> >
> >Note: this is needed for kernel 2.6.39 and earlier.
> >
> 
> What about kvm.git master?

Sorry about the confusion.

Clarification: this is needed on  kvm.git master,
as well as 2.6.39 and earlier.

> -- 
> error compiling committee.c: too many arguments to function
