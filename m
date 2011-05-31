Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab1EaFFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 01:05:45 -0400
Received: from smtp-out.google.com ([74.125.121.67]:60683 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757767Ab1EaFFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 01:05:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=RCn3T6pwsreg9XWzxII7F7IW/WOGI4xTQZjPbPHzMjv1OmAL15aud1opKbx5e+YkEL
         k6XdzkEYpceuM2fhAinw==
Date: Mon, 30 May 2011 22:05:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Eric Miao <eric.y.miao@gmail.com>, Samuel Ortiz <samuel@sortiz.org>
Subject: Re: IrDA driver fails on PXA255
In-Reply-To: <20110529215656.GA5576@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.1105302202510.18793@chino.kir.corp.google.com>
References: <20110528205701.GA1788@doriath.ww600.siemens.net> <alpine.DEB.2.00.1105281628480.9934@chino.kir.corp.google.com> <BANLkTim9YdhjY75CzMsSOCVKZWi-WKZ5wA@mail.gmail.com> <alpine.DEB.2.00.1105291410450.9658@chino.kir.corp.google.com>
 <20110529215656.GA5576@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 May 2011, Russell King - ARM Linux wrote:

> > That would return memory that is not guaranteed to be within the first 
> > 16MB of address space, so a GFP_DMA allocation would succeed with memory 
> > not from ZONE_DMA.
> 
> Err, no. GFP_DMA returns memory in a zone which the platform has setup.
> There's nothing specific about it being "16MB" or any other size; the
> arch can chose what size that is.
> 

Sorry, was talking from the x86 perspective, which probably doesn't make 
much sense since we're talking about an arm driver :)

> > That's an invalid configuration, so users, including 
> > you, should at least edit their .config by hand to enable CONFIG_ZONE_DMA 
> > as a workaround.
> 
> Again, no.  This change has caused a load of previously working drivers
> to suddenly start failing without _any_ explanation why or even warning
> about the change.  It needs to start off as a WARN_ON() so that stuff
> can be fixed, and then changed to a hard error.
> 

I haven't seen a "load" of error reports where this is causing an issue, 
maybe it is much more popular on arm?

This also isn't a hard error, admins should be able to enable 
CONFIG_ZONE_DMA and rebuild so that the driver being loaded can get the 
type of memory it is requesting.  Just putting a WARN_ON() doesn't provide 
any incentive to ever get this stuff fixed.
