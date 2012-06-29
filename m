Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab2F2Pj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:39:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab2F2Pjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:39:55 -0400
Message-ID: <1340984391.1207.349.camel@bling.home>
Subject: Re: [PATCH v2 6/6] kvm: Level IRQ de-assert for KVM_IRQFD
From: Alex Williamson <alex.williamson@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Date: Fri, 29 Jun 2012 09:39:51 -0600
In-Reply-To: <4FEC552E.40409@redhat.com>
References: <20120627044758.23698.249.stgit@bling.home>
	 <20120627051013.23698.91132.stgit@bling.home> <4FEC552E.40409@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-28 at 15:59 +0300, Avi Kivity wrote:
> On 06/27/2012 08:10 AM, Alex Williamson wrote:
> > This is an alternate level irqfd de-assert mode that's potentially
> > useful for emulated drivers.  It's included here to show how easy it
> > is to implement with the new level irqfd and eoifd support.  It's
> > possible this mode might also prove interesting for device-assignment
> > where we inject via level irqfd, receive an EOI (w/o de-assert), and
> > use the level de-assert irqfd here.
> 
> This use case is racy.  The guest driver will have shut down the
> interrupt before EOI, but with what you describe, it will fire again
> until the eoifd/deassertfd sequence completes.

Hmm, that's a good point.  We'll continue asserting the interrupt in the
indeterminate gap between eoifd and de-assert-irqfd which could fire
enough times for the guest to disable it.  Oh well.  Thanks,

Alex

