Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab1DCKPm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 06:15:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab1DCKPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 06:15:40 -0400
Date: Sun, 3 Apr 2011 13:15:34 +0300
From: Alon Levy <alevy@redhat.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [ANNOUNCE] Native Linux KVM tool
Message-ID: <20110403101533.GJ4047@playa.redhat.com>
Mail-Followup-To: Pekka Enberg <penberg@kernel.org>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1301592656.586.15.camel@jaguar>
 <20110403090149.GI4047@playa.redhat.com>
 <1301824898.7875.5.camel@jaguar>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1301824898.7875.5.camel@jaguar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 03, 2011 at 01:01:38PM +0300, Pekka Enberg wrote:
> On Sun, 2011-04-03 at 12:01 +0300, Alon Levy wrote:
> > On Thu, Mar 31, 2011 at 08:30:56PM +0300, Pekka Enberg wrote:
> > > Hi all,
> > > 
> > > We’re proud to announce the native Linux KVM tool!
> > > 
> > > The goal of this tool is to provide a clean, from-scratch, lightweight
> > > KVM host tool implementation that can boot Linux guest images (just a
> > > hobby, won't be big and professional like QEMU) with no BIOS
> > > dependencies and with only the minimal amount of legacy device
> > > emulation.
> > > 
> > > Note that this is a development prototype for the time being: there's no
> > > networking support and no graphics support, amongst other missing
> > > essentials.
> > 
> > I've looked at how to add spice to this, the qxl device should be relatively
> > easy to add as it's just another pci device and you already support the virtio
> > block pci device. But to add the spice server library there needs to be some
> > simple fd and timer (i.e. select/epoll) event loop, which I see is missing. Are
> > you planning on adding something like that?
> 
> We have kvm__start_timer() in tools/kvm/kvm.c. Can you use that as a
> base for qxl?
> 

Haven't looked at it close enough yet, but if I can set an arbitrary time
ahead wakeup using it then it's good enough for timers. For waking up as
a result of a socket being ready for read or write I need something else.
Maybe I'm missing something and you already have something like that.

> 			Pekka
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
