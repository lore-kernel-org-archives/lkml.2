Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab0ISL10 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 07:27:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548Ab0ISL1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 07:27:25 -0400
Date: Sun, 19 Sep 2010 13:21:24 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: enable irq injection from interrupt context
Message-ID: <20100919112124.GD7350@redhat.com>
References: <20100916142335.GC24850@redhat.com>
 <20100916145117.GK3008@redhat.com>
 <20100916152411.GE24850@redhat.com>
 <20100916154326.GL3008@redhat.com>
 <20100916220715.GA30531@redhat.com>
 <20100917075929.GA11518@redhat.com>
 <20100919104550.GA7350@redhat.com>
 <4C95EC4C.4060904@redhat.com>
 <20100919105512.GB7350@redhat.com>
 <20100919111844.GQ3008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100919111844.GQ3008@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 19, 2010 at 01:18:44PM +0200, Gleb Natapov wrote:
> On Sun, Sep 19, 2010 at 12:55:12PM +0200, Michael S. Tsirkin wrote:
> > On Sun, Sep 19, 2010 at 12:56:12PM +0200, Avi Kivity wrote:
> > >  On 09/19/2010 12:45 PM, Michael S. Tsirkin wrote:
> > > >On Fri, Sep 17, 2010 at 09:59:29AM +0200, Gleb Natapov wrote:
> > > >>  >  writing 0 to eventfd does nothing. The way to deassert irq
> > > >>  That is implementation detail of current irqfd. It was designed for MSI
> > > >>  not level triggered interrupts.
> > > >
> > > >Maybe we should add a check that gsi is mapped to MSI (or unmapped) then?
> > > >Level which switches to 1 and back to 0 immediately will be racy anyway
> > > >...
> > > >
> > > 
> > > Add a check where?
> > 
> > I would make sure that if you bind irqfd to a non-MSI GSI,
> > signalling it has no effect.
> > 
> Why would you do that? I am not against checking per se, but why a user of
> the API can't check for that?
> 
> --
> 			Gleb.

Currently using irqfd with level will kind of work, sometimes.
Better have it consistently not working so application
writers get the message that they can't rely on it.

-- 
MST
