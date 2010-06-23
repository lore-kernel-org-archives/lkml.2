Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab0FWTO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 15:14:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:62718 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab0FWTOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 15:14:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=uc98z7E6TuF4wHuUakwA5wvY+/EgFrw2Z23QHFyM8b2MUhmB4lPK4zYvVvZs8/fxcd
         fKHJa1pAAGa9yp1RDXX/BPrVfuC0VvCNWDNAwklueFsX6/rJT9kJRy3wsHpvB8MUgrFP
         MjRd1RCHAhJu4adup/wPsYT5oz/GXW49uEMKA=
MIME-Version: 1.0
In-Reply-To: <4C223657.3030507@colorfullife.com>
References: <alpine.DEB.2.00.1006180940140.11575@router.home>
	<20100621200118.GA4021@nb-core2.darkstar.lan>
	<4C223657.3030507@colorfullife.com>
Date: Wed, 23 Jun 2010 21:14:22 +0200
Message-ID: <AANLkTimE_BeA3yiCovC0ckn_MbbH3lpgctLD8zD5ir6j@mail.gmail.com>
Subject: Re: 2.6.35-rc3 deadlocks on semaphore operations
From: Luca Tettamanti <kronos.it@gmail.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Julia Lawall <julia@diku.dk>, Andrew Morton <akpm@linux-foundation.org>,
       maciej.rutecki@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 6:29 PM, Manfred Spraul
<manfred@colorfullife.com> wrote:
> Hi,
>
> I think I found it:
> Previously, queue.status was never IN_WAKEUP when the semaphore spinlock was
> held.
>
> The last patch changes that:
> Now the change from IN_WAKEUP to the final result code happens after the the
> semaphore spinlock is dropped.
> Thus a task can observe IN_WAKEUP even when it acquired the semaphore
> spinlock.
>
> As a result, semop() sometimes returned 1 (IN_WAKEUP) for a successful
> operation.
>
> Attached is a patch that should fix the bug.

Apache seems fine.

Tested-by: Luca Tettamanti <kronos.it@gmail.com>

thanks,
Luca
