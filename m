Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab1EaFBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 01:01:23 -0400
Received: from smtp-out.google.com ([216.239.44.51]:33368 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab1EaFBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 01:01:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=r5zOiU+W1cG0jKC/HzOMz0EDmkF+3SHJRkL7DsRvh2x2xRlko4QCTX1Srs+9EezHCW
         D8VwjQdBatba5WrSQXMQ==
Date: Mon, 30 May 2011 22:01:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>, Samuel Ortiz <samuel@sortiz.org>
Subject: Re: IrDA driver fails on PXA255
In-Reply-To: <20110529215805.GB5576@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.1105302156190.18793@chino.kir.corp.google.com>
References: <20110528205701.GA1788@doriath.ww600.siemens.net> <alpine.DEB.2.00.1105281628480.9934@chino.kir.corp.google.com> <20110528234614.GV24876@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1105281913490.15709@chino.kir.corp.google.com>
 <20110529072516.GW24876@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1105291417090.9658@chino.kir.corp.google.com> <20110529215805.GB5576@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 May 2011, Russell King - ARM Linux wrote:

> We might as well enable CONFIG_ZONE_DMA for everything if that's what
> you're proposing, because it's not just this driver which will be affected.

I'd certainly suggest at least defaulting it to on for arm if you're going 
to be using GFP_DMA in drivers.

> And as soon as we do that, we completely lose the warnings that stuff
> needs fixing.
> 

That's because nothing needs fixing at that point, the page allocator is 
guaranteed to return lowmem if GFP_DMA is passed and CONFIG_ZONE_DMA is 
enabled, or NULL.  Whether GFP_DMA is correct in the memory allocator is a 
different subject, but those types of audits can easily be done on the 
source code.  In my opinion, we should be doing "select ZONE_DMA" on any 
Kconfig option that builds a driver that unconditionally uses GFP_DMA.

The current behavior exists so that the admin reports the error here so it 
can get fixed up (either by finding that GFP_DMA is unnecessary, selective 
depending on the particular hardware, or modifying the Kconfig) and can 
workaround the problem by forcing CONFIG_ZONE_DMA.
