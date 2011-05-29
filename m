Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab1E2VTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 17:19:45 -0400
Received: from smtp-out.google.com ([216.239.44.51]:60215 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab1E2VTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 17:19:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Yi9GJl2ru8J/66Uu+VyX4euqyyRCv8bMHrEw8Wj7hQvDLYmFwPuKxJwSRpmbuSgak/
         onrpQ/bOUAHqaSZUUOFw==
Date: Sun, 29 May 2011 14:19:40 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>, Samuel Ortiz <samuel@sortiz.org>
Subject: Re: IrDA driver fails on PXA255
In-Reply-To: <20110529072516.GW24876@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.1105291417090.9658@chino.kir.corp.google.com>
References: <20110528205701.GA1788@doriath.ww600.siemens.net> <alpine.DEB.2.00.1105281628480.9934@chino.kir.corp.google.com> <20110528234614.GV24876@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1105281913490.15709@chino.kir.corp.google.com>
 <20110529072516.GW24876@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 May 2011, Russell King - ARM Linux wrote:

> > arm, pxa2xx: enable DMA support for pxa2xx IRDA interface
> > 
> > The pxa2xx-ir driver allocates with GFP_DMA, so it must always have 
> > ZONE_DMA.
> 
> Wrong way.  If there's no restrictions, drivers shouldn't be using
> GFP_DMA.  For the majority of SoCs, that's the case.
> 

That's great, but before you can actually determine what requires DMA for 
this driver and what doesn't, we need something for this merge window (and 
backported to -stable) so that users aren't forced to go through and 
enable CONFIG_ZONE_DMA on their own .config.

Is there a downside to enabling CONFIG_ZONE_DMA for all configs that 
compile this driver until a better solution can be found?
