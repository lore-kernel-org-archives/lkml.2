Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab1D1HYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 03:24:32 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:34927 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab1D1HYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 03:24:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Zc4Qj1tLUbP38oqZKwKDPQtpeeLcGab5+rVcxwcJ1HmOPdIMEspr9S7mOjNGrRtW9H
         geY/ua436vBwjH/d0gvnBAeQq4lR73jjJ0TbnADeVNTKxG42JhlzEfOouyKb76Nv08DN
         acHLsULwYKFJw60CeCC8anRZ9qPa+PWssJtao=
MIME-Version: 1.0
In-Reply-To: <1303940737.2513.190.camel@pasglop>
References: <201104212129.17013.arnd@arndb.de>
	<BANLkTinPbZZS9F1tRCA73fgoD-y__jSfCA@mail.gmail.com>
	<1303940737.2513.190.camel@pasglop>
Date: Thu, 28 Apr 2011 16:24:30 +0900
X-Google-Sender-Auth: VB2Q7FAAwJ1FL-ZOcs4D_hHBjDo
Message-ID: <BANLkTi=8fh97S00HwcCvXe84v=0i+BQ74Q@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
From: KyongHo Cho <pullip.cho@samsung.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 6:45 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> Don't you have a risk where speculative loads or prefetches might bring
> back some stuff into the cache via the cachable mapping ? Is that an
> issue ? As long as it's non-dirty and the cachable mapping isn't
> otherwise used, I suppose it might be a non-issue, tho I've seen in
> powerpc land cases of processors that can checkstop if a subsequent non
> cachable access "hits" the stuff that was loaded in the cache.
>
> Cheers,
> Ben.
>
As far as I know, ARM processors does not have the capability
to detect non-cacheable access hits the stuff in  the cache.

IMHO, speculative prefetch becomes a problem
when a coherent buffer (that is not-cacheable in ARM) is modified by a
DMA transaction
while old data is already loaded in the cache via another cacheable
mapping onto the buffer
even though it is never touched by CPU.
We can avoid this problem if the kernel removes 'executable' property
from the cacheable mapping.
But it is not able to modify page table entries in the direct mapping area.

Regards,
KyongHo
