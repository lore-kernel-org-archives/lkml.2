Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab0FJN2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 09:28:25 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44457 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab0FJN2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 09:28:24 -0400
To: Tejun Heo <tj@kernel.org>
CC: miklos@szeredi.hu, hmajxxlh@corbac.com, fuse-devel@lists.sourceforge.net,
       mszeredi@suse.cz, linux-kernel@vger.kernel.org
In-reply-to: <869cdc8d-85cf-468e-8f94-ff50551684ba@email.android.com> (message
	from Tejun Heo on Thu, 10 Jun 2010 15:13:33 +0200)
Subject: Re: [fuse-devel] OSS Proxy Jack slave
References: =?US-ASCII?Q?=3C20100601092456=2EGA23572=40alia?= =?US-ASCII?Q?=2Enute=2Enet=3E_=3C4C066CF4=2E2050902=40gm?= =?US-ASCII?Q?ail=2Ecom=3E=09=3C20100605085045=2EGA56?= =?US-ASCII?Q?30=40alia=2Enute=2Enet=3E_=3C4C0A1369=2E9010?= =?US-ASCII?Q?601=40kernel=2Eorg=3E_=3CE1OMICc-0005?= =?US-ASCII?Q?f8-G5=40pomaz-ex=2Eszeredi=2Ehu=3E_=3C4C1?= =?US-ASCII?Q?0CB39=2E70002=40kernel=2Eorg=3E_=3CE1OMg?= =?US-ASCII?Q?Iz-0005Wb-2a=40pomaz-ex=2Eszeredi=2Ehu=3E?= <869cdc8d-85cf-468e-8f94-ff50551684ba@email.android.com>
Message-Id: <E1OMhnk-0005i4-8F@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 10 Jun 2010 15:28:08 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010, Tejun Heo wrote:
> Hello,
> 
> Nope, it's not required for osspd but it's a rather strong
> limitation on the interface which would be pretty difficult to work
> around later.  Page protection tricks would be very cumbersome and
> unscalable.  Hmmm, it does remove the necessity for allocating
> kernel pages, right?  Still, it seems like a big limitation.  Are
> you sure this is a good idea?

I'm sure its a good idea to provide an interface that does't _require_
server side mmaps.  This doesn't preclude an mmap interface later on,
but I'd rather start with a "pure" read/write device interface, which
is in a lot of ways simpler to solve than mmap.

As for pinning kernel pages, I still think it's a good idea for the
char device interface, but you're right, it's not necessary.

In fact I'm mostly ready with an implementation of store/retrieve that
just pokes the regular page cache.

Thanks,
Miklos
