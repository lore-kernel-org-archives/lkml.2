Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab0FWPxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 11:53:49 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:44622 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752766Ab0FWPxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 11:53:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=bqjjl6A4/ahH2T0uEkj7iNTXvreuyWdMJXf9SIaIjJIIa30FD1zcOBKdPKA6ECr+O3SAWvxjtMUiBwpD62vEjR2qD+USlNO0OC7Uctt9m+PUA72VbvzwDqU2xLIWpsUT;
Date: Wed, 23 Jun 2010 08:51:53 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Avi Kivity <avi@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
       virtualization@lists.linux-foundation.org,
       Anthony Liguori <aliguori@us.ibm.com>, linux-pci@vger.kernel.org,
       Matt Carlson <mcarlson@broadcom.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH for-2.6.35] virtio-pci: disable msi at startup
Message-ID: <20100623085153.603e943f@virtuousgeek.org>
In-Reply-To: <4C2229DB.6060706@redhat.com>
References: <20100610152252.GA3510@redhat.com>
	<4C22132F.4060307@redhat.com>
	<20100623135946.GA30526@redhat.com>
	<4C221871.6020509@redhat.com>
	<20100623144307.GB30526@redhat.com>
	<4C222508.2060804@redhat.com>
	<20100623152633.GC30526@redhat.com>
	<4C2229DB.6060706@redhat.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jun 2010 18:35:55 +0300
Avi Kivity <avi@redhat.com> wrote:

> On 06/23/2010 06:26 PM, Michael S. Tsirkin wrote:
> >
> >
> >>>
> >>>        
> >>>>>> Shouldn't a reset be equivalent to power cycling?
> >>>>>>
> >>>>>>
> >>>>>>              
> >>>>> If we did this, driver would need to restore registers
> >>>>> such as BAR etc.
> >>>>>
> >>>>>
> >>>>>            
> >>>> We could save/restore the registers we care about.
> >>>>
> >>>>          
> >>> It seems easier to clear registers we care about.
> >>>        
> >> We know the registers we care about, we don't know the ones we don't.
> >>      
> > If/when we use more registers, we can update driver to clear them on start.
> >    
> 
> The kdump kernel may not load drivers for those extra devices.

FLR or another type of reset also has the nice property of bringing the
device into a known state.  kexec/kdump has always been vulnerable to
having devices in partial states when the new kernel loads; would be
good to make it more robust.

> 
> >> I'm talking about FLRing all cards, not just those you want to use.
> >>      
> > reset using FLR/PM is complex because of the need to save/restore
> > config space. Doing this on a crashing kernel sounds scary.
> >    
> 
> Well, you only need to save/restore for the devices you use.  The rest 
> you reset and forget.
> 
> I don't really see why copying some config space is crazy.

We could push any needed save/restore of core settings and regs into
the PCI core like we do for PM.  That would save a bunch of driver
trouble...

-- 
Jesse Barnes, Intel Open Source Technology Center
