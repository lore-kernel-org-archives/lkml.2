Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129Ab2HPSVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 14:21:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932255Ab2HPSVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 14:21:50 -0400
Date: Thu, 16 Aug 2012 19:54:26 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, gleb@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 0/6] kvm: level irqfd support
Message-ID: <20120816165426.GB22518@redhat.com>
References: <20120810223633.809.44188.stgit@bling.home>
 <20120815142803.GF3068@redhat.com>
 <1345052191.4683.435.camel@ul30vt.home>
 <20120815192224.GB5670@redhat.com>
 <502D1FF4.20506@redhat.com>
 <20120816163658.GA22518@redhat.com>
 <502D2247.7060107@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502D2247.7060107@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 07:39:35PM +0300, Avi Kivity wrote:
> On 08/16/2012 07:36 PM, Michael S. Tsirkin wrote:
> 
> >> What if a level irqfd shares a line with a KVM_IRQ_LINE ioctl?  Then an
> >> EOI can de-assert the irqfd source, but the line is kept high by the
> >> last KVM_IRQ_LINE invocation.
> > 
> > Exactly. So 1 ID for userspace and 1 for irqfd.
> 
> Gaa, this mess belongs in userspace.

Not sure I understand what you refer to.

I meant simply
#define KVM_IRQFD_IRQ_SOURCE_ID    1
request it at kvm init.

As opposed to using KVM_USERSPACE_IRQ_SOURCE_ID like we do now
for edge.
Does this seem acceptable to you?

> -- 
> error compiling committee.c: too many arguments to function
