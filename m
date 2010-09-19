Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab0ISL3X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 07:29:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548Ab0ISL3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 07:29:22 -0400
Date: Sun, 19 Sep 2010 13:23:23 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: enable irq injection from interrupt context
Message-ID: <20100919112323.GE7350@redhat.com>
References: <20100916142335.GC24850@redhat.com>
 <20100916145117.GK3008@redhat.com>
 <20100916152411.GE24850@redhat.com>
 <20100916154326.GL3008@redhat.com>
 <20100916220715.GA30531@redhat.com>
 <20100917075929.GA11518@redhat.com>
 <20100919104550.GA7350@redhat.com>
 <4C95EC4C.4060904@redhat.com>
 <20100919105512.GB7350@redhat.com>
 <4C95EE65.3090209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C95EE65.3090209@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 19, 2010 at 01:05:09PM +0200, Avi Kivity wrote:
>  On 09/19/2010 12:55 PM, Michael S. Tsirkin wrote:
> >On Sun, Sep 19, 2010 at 12:56:12PM +0200, Avi Kivity wrote:
> >>   On 09/19/2010 12:45 PM, Michael S. Tsirkin wrote:
> >>  >On Fri, Sep 17, 2010 at 09:59:29AM +0200, Gleb Natapov wrote:
> >>  >>   >   writing 0 to eventfd does nothing. The way to deassert irq
> >>  >>   That is implementation detail of current irqfd. It was designed for MSI
> >>  >>   not level triggered interrupts.
> >>  >
> >>  >Maybe we should add a check that gsi is mapped to MSI (or unmapped) then?
> >>  >Level which switches to 1 and back to 0 immediately will be racy anyway
> >>  >...
> >>  >
> >>
> >>  Add a check where?
> >
> >I would make sure that if you bind irqfd to a non-MSI GSI,
> >signalling it has no effect.
> >
> 
> Certainly.  We should also update the documentation, when we have
> irqfd documentation.

When and if we start supporing level, we'll have to add a capability flag.
By way of documentation, reserve a bit value in header right now?

> -- 
> error compiling committee.c: too many arguments to function
