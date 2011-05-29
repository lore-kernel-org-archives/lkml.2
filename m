Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab1E2VRJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 17:17:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:59288 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab1E2VRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 17:17:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=B90ZPzpmjJ8qx20MIBTzfAX2ImujPOV4kQqL8pQIz/7diqommsQIZ6zmOpFsaDdjoh
         c9cxS2FmQSE9+6aF0zQA==
Date: Sun, 29 May 2011 14:17:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Eric Miao <eric.y.miao@gmail.com>, Samuel Ortiz <samuel@sortiz.org>
Subject: Re: IrDA driver fails on PXA255
In-Reply-To: <BANLkTim9YdhjY75CzMsSOCVKZWi-WKZ5wA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1105291410450.9658@chino.kir.corp.google.com>
References: <20110528205701.GA1788@doriath.ww600.siemens.net> <alpine.DEB.2.00.1105281628480.9934@chino.kir.corp.google.com> <BANLkTim9YdhjY75CzMsSOCVKZWi-WKZ5wA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 May 2011, Dmitry Eremin-Solenikov wrote:

> What about changing your patch for less intrusive one (to emit a
> WARN_ON) for at least one
> or two major releases and only then changing it back to the current state?
> 

That would return memory that is not guaranteed to be within the first 
16MB of address space, so a GFP_DMA allocation would succeed with memory 
not from ZONE_DMA.  That's an invalid configuration, so users, including 
you, should at least edit their .config by hand to enable CONFIG_ZONE_DMA 
as a workaround.  Then, we should try to fix up the Kconfig entries for 
drivers requiring DMA allocations to select CONFIG_ZONE_DMA or fix 
defconfigs when DMA is known to be needed for a device.
