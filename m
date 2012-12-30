Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab2L3LU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 06:20:27 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52227 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab2L3LUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 06:20:25 -0500
Date: Sun, 30 Dec 2012 13:20:18 +0200
From: Ido Yariv <ido@wizery.com>
To: "steve.zhan" <zhanzhenbo@gmail.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-omap <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] hwspinlock/core: Add testing capabilities
Message-ID: <20121230112018.GA14042@WorkStation.localnet>
References: <CAKvkGKfc5jw+_ABgB8nrX37B7zHCoA5Ld0Gs5O-EDFD-Gk0OKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKvkGKfc5jw+_ABgB8nrX37B7zHCoA5Ld0Gs5O-EDFD-Gk0OKg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Sat, Dec 29, 2012 at 05:19:08PM +0800, steve.zhan wrote:
> Hi,
> 
>     It is good idea add this feature.
> 
> 1: Can we let the "ret = hwspin_lock_tests(ops, hwlock);" add after
> hwspin_lock_register_single have return
> succeed, that can avoid test duplicated Or error lockid. Of course, If
> this interface is intend to test soc hardware capability only, we can
> put it in the arch module not this core framework. For driver hardware
> sanity check, i would add it after software have register it.

I'd rather not test the spinlocks after they are registering as they
might already be in use by then.

While this feature only verifies the underlying platform implementation,
I think it's best to avoid code duplication and keep it in one place
that will always get called.

> 2:Is it possible that interface add configs that choose which locks
> will be test? Because the hwspinlock module is init late in
> postcore_initcall phase, Maybe MACH/ARCH code(for example: code in
> early_initcall) need use private other interfaces to lock some
> hwspinlocks and then register hw locks to hwspinlock framework, Maybe
> some hw locks is in lock status but which test failed.

It was assumed that up to the point where the hw spinlocks are
registered they will not be used, regardless of when this module is
initialized.
If this assumption does not hold for your platform, the simplest
solution would be to set this config option to 'N', as there is no safe
way of verifying spinlocks that are actively being used.

Thanks for reviewing this,
Ido.
