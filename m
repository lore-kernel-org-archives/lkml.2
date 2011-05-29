Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab1E2Vd2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 17:33:28 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50711 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab1E2Vd1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 17:33:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Riqg5JkjNbo1cwsxBhihctWGysisO2HA/M4wfAaHIEcbVZWKTY5j26HuQvSOhTNQ1k
         KQA1bq5oc09hQlUUf3X1O/U8ZxvBM+EYa/Q1YBZQf3Ecjf69dClj5iX764MZ7PQ5CFph
         Wtm+XM0kEjBg4DdqD01UfYuYF8QMaDaT6BC5U=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1105291410450.9658@chino.kir.corp.google.com>
References: <20110528205701.GA1788@doriath.ww600.siemens.net>
	<alpine.DEB.2.00.1105281628480.9934@chino.kir.corp.google.com>
	<BANLkTim9YdhjY75CzMsSOCVKZWi-WKZ5wA@mail.gmail.com>
	<alpine.DEB.2.00.1105291410450.9658@chino.kir.corp.google.com>
Date: Mon, 30 May 2011 01:33:26 +0400
Message-ID: <BANLkTi=RWG_iiyd1f_aGEpqk9Cbh1dT7iw@mail.gmail.com>
Subject: Re: IrDA driver fails on PXA255
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Eric Miao <eric.y.miao@gmail.com>, Samuel Ortiz <samuel@sortiz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 1:17 AM, David Rientjes <rientjes@google.com> wrote:
> On Sun, 29 May 2011, Dmitry Eremin-Solenikov wrote:
>
>> What about changing your patch for less intrusive one (to emit a
>> WARN_ON) for at least one
>> or two major releases and only then changing it back to the current state?
>>
>
> That would return memory that is not guaranteed to be within the first
> 16MB of address space, so a GFP_DMA allocation would succeed with memory
> not from ZONE_DMA.  That's an invalid configuration, so users, including
> you, should at least edit their .config by hand to enable CONFIG_ZONE_DMA
> as a workaround.  Then, we should try to fix up the Kconfig entries for
> drivers requiring DMA allocations to select CONFIG_ZONE_DMA or fix
> defconfigs when DMA is known to be needed for a device.

Am I right that this was the previous behaviour for GFP_DMA allocations
w/o CONFIG_ZONE_DMA? If so, we can have it (probably) for one more
major release to get all warnings.

-- 
With best wishes
Dmitry
