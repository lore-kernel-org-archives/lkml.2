Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab0JEVFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 17:05:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47215 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab0JEVFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 17:05:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IRYepwRE6vhrR++3Gx67PNE2SlNF6z8f5FkTVKMm5gUop0MDx/o7yesCP1DZGN6tOu
         keGw0U1VDUCyuZEdSfchj3tGzYsU1Gay/e5RdtVfnV3JWmanMl/4TxaFKAilFm8spHaS
         S7YMw4yqB0WxLbAXkpsLU9rLtAEjgztZT4Izc=
MIME-Version: 1.0
In-Reply-To: <27F9C60D11D683428E133F85D2BB4A5304681D48D3@dlee03.ent.ti.com>
References: <1286208555-8829-1-git-send-email-felipe.contreras@gmail.com>
	<20101005190741.GC20825@kroah.com>
	<AANLkTikOBWxXh7uVrDxfW3OnwOM58JTXU76KUUoQWBWM@mail.gmail.com>
	<27F9C60D11D683428E133F85D2BB4A5304681D4889@dlee03.ent.ti.com>
	<AANLkTin=k07hUq+cLAOsf0aYw5Ey23UOpbpo=+Eb49w9@mail.gmail.com>
	<27F9C60D11D683428E133F85D2BB4A5304681D48D3@dlee03.ent.ti.com>
Date: Wed, 6 Oct 2010 00:05:44 +0300
Message-ID: <AANLkTi=ENjWQRYitr_kYzmRKgve=CoBf=7Y5KHLJNLfb@mail.gmail.com>
Subject: Re: [PATCH 0/2] omap: dsp: make the driver actually work
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
Cc: Greg KH <greg@kroah.com>, linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Hiroshi Doyu <hiroshi.doyu@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 5, 2010 at 11:09 PM, Ramirez Luna, Omar <omar.ramirez@ti.com> wrote:
> Felipe Contreras wrote:
> ...
>>>
>>> phys_to_virt instead of ioremap should work fine, still need to try
>>> it though.
>>
>> I tried that... Didn't work. I guess we need to flush at some points
>> (since the memory is cacheable).
>
> Hmmm, because my other option was to move the reserved memory outside the kernel, but that involves specifying bootargs again and using dma_alloc_coherent with their restrictions.

Huh, if there's no contiguous memory region reserved, then the driver
is doing dma_alloc_coherent already, but that fails (apparently 5M is
too much). Plus I've read that dma_alloc_coherent is "precious";
shouldn't be used for that.

> If you are working on a different method and need any help let me know.

So, first I wanted to try reserving some region with mem=X boot param,
but that solution is ugly. If that worked, then I wanted ti see if
flushing each time we access that shm memory block works, but in the
process I wanted to reorganize the whole initialization code because
right now it's very ugly and confusing.

-- 
Felipe Contreras
