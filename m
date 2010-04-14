Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab0DNUkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 16:40:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63213 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab0DNUkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 16:40:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC][PATCH v3 1/3] A device for zero-copy based on KVM virtio-net.
Date: Wed, 14 Apr 2010 22:39:49 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.31-19-generic; KDE/4.4.2; x86_64; ; )
Cc: xiaohui.xin@intel.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, davem@davemloft.net,
       jdike@linux.intel.com
References: <1270805865-16901-1-git-send-email-xiaohui.xin@intel.com> <201004141835.57673.arnd@arndb.de> <20100414203142.GA11321@redhat.com>
In-Reply-To: <20100414203142.GA11321@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004142239.50299.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19VGRmB/zsKlN+JnVswTgT1Uq8i+4RPSkyVyDB
 WSmtBBurKhFjxCWiND0NgupikNTCZNoxXPxFf2vhkaOh6vfYVo
 JGGMUwSeucBRqDbP70PCw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 April 2010 22:31:42 Michael S. Tsirkin wrote:
> On Wed, Apr 14, 2010 at 06:35:57PM +0200, Arnd Bergmann wrote:
> > On Wednesday 14 April 2010, Michael S. Tsirkin wrote:
> > > > > 
> > > > > qemu needs the ability to inject raw packets into device
> > > > > from userspace, bypassing vhost/virtio (for live migration).
> > > > 
> > > > Ok, but since there is only a write callback and no read, it won't
> > > > actually be able to do this with the current code, right?
> > > 
> > > I think it'll work as is, with vhost qemu only ever writes,
> > > never reads from device. We'll also never need GSO etc
> > > which is a large part of what tap does (and macvtap will
> > > have to do).
> > 
> > Ah, I see. I didn't realize that qemu needs to write to the
> > device even if vhost is used. But for the case of migration to
> > another machine without vhost, wouldn't qemu also need to read?
> 
> Not that I know. Why?

Well, if the guest not only wants to send data but also receive
frames coming from other machines, they need to get from the kernel
into qemu, and the only way I can see for doing that is to read
from this device if there is no vhost support around on the new
machine.

Maybe we're talking about different things here.

	Arnd
