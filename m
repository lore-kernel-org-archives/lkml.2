Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab1FIKUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 06:20:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58251 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab1FIKUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 06:20:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Fv0HoCtfBoIuTIjLqjrpXvUkSl5nMUWII+zNCoSlA126Eb5gQWqpemM5X5pg8cQBIo
         0KSogGN/ML3wz/uMYjl0oPhhWV7E425wH1j+IKxhRfW+NiU2kuUdYzw2F56UdSLFsWSk
         y2mMtXDy0yhvZeZ7Jd3aiysEzqBhfPKCkx3bo=
Date: Thu, 9 Jun 2011 12:20:38 +0200
From: Tejun Heo <tj@kernel.org>
To: Maxin B John <maxin.john@gmail.com>
Cc: eike-kernel@sf-tec.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, dima@android.com, willy@linux.intel.com,
        segooon@gmail.com, jkosina@suse.cz, tglx@linutronix.de
Subject: Re: [PATCH] mm: dmapool: fix possible use after free in
 dmam_pool_destroy()
Message-ID: <20110609102038.GE11773@htj.dyndns.org>
References: <20110602142242.GA4115@maxin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110602142242.GA4115@maxin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jun 02, 2011 at 05:22:42PM +0300, Maxin B John wrote:
> > The pool itself is not used there, only the address where the pool
> > has been.This will only lead to any trouble if something else is allocated to
> > the same place and inserted into the devres list of the same device between
> > the dma_pool_destroy() and devres_destroy().

Which can't happen.  devres release is bound to device driver model
and a device can't be re-attached before release is complete.
ie. those operations are serialized, so the failure mode is only
theoretical.

> Thank you very much for explaining it in detail. 
> 
> > But I agree that this is bad style. But if you are going to change
> > this please also have a look at devm_iounmap() in lib/devres.c. Maybe also the
> > devm_*irq* functions need the same changes.
> 
> As per your suggestion, I have made similar modifications for lib/devres.c and
> kernel/irq/devres.c
> 
> CCed the maintainers of the respective files.
>  
> Signed-off-by: Maxin B. John <maxin.john@gmail.com>

But it shouldn't hurt and if it helps memleak.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
