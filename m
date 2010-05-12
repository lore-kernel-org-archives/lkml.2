Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab0ELNGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 09:06:16 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:46644 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab0ELNGO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 09:06:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WUlUSJMt+llc6Kqq75LV2Ql5KrRgwDxPLLKH4K7jrzG5vEEjP7co7hyDvNcpWfBOTP
         9APS38oRVuDN6F+hC1DhxyjNRDV9WAnJ65GP3E+8jCi5AXS0kaWupVeRkVGEog9EHNhk
         smtIsuGub+22DjndzUjO9Hb+BqS2jmJbwE/TA=
MIME-Version: 1.0
In-Reply-To: <201005121121.49135.tvrtko.ursulin@sophos.com>
References: <201005121121.49135.tvrtko.ursulin@sophos.com>
Date: Wed, 12 May 2010 16:00:51 +0300
X-Google-Sender-Auth: 977e71fce2c0fae4
Message-ID: <g2i84144f021005120600wa8eb0409k13f67f49c519509@mail.gmail.com>
Subject: Re: 2.6.33.2 kmalloc-8 slab leaks ~512 objects per second
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tvrtko,

On Wed, May 12, 2010 at 1:21 PM, Tvrtko Ursulin
<tvrtko.ursulin@sophos.com> wrote:
> As the subject says, is this a know issue? I have been tracking the growth at
> one second intervals and it looks like this:
>
> 512 (67716608) Slab:             606744 kB
> 512 (67717120) Slab:             606752 kB
> 512 (67717632) Slab:             606756 kB
> 0 (67718144) Slab:             606756 kB
> 512 (67718144) Slab:             606760 kB
> 1024 (67718656) Slab:             606768 kB
> 512 (67719680) Slab:             606772 kB
> 512 (67720192) Slab:             606776 kB
> 0 (67720704) Slab:             606776 kB
> 512 (67720704) Slab:             606780 kB
>
> First fiels is the diff in numobj, in parentheses is actual numobj and last is
> the total slab size from /proc/meminfo.
>
> kmalloc-8         68044800 68044800      8  512    1 : tunables    0    0    0
> : slabdata 132900 132900      0
>
> dm-io slab also seems large, don't know... :
> dm_io              75924 147288     40  102    1 : tunables    0    0    0 :
> slabdata   1444   1444      0
>
> Some other info about the system/kernel is attached.

[snip]

You might want to try out the built-in kernel memory leak detector.
See Documentation/kmemleak.txt for details how to enable it and use
it.

                                   Pekka
