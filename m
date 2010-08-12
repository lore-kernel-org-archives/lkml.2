Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581Ab0HLDMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 23:12:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64677 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759221Ab0HLDMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 23:12:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kEYkZbTGwyHdqxgYoIYSkQEmYV2mHZ7kEDAGVNaxdvFnSvCl3WHw7Ghll6IlTjvQ7d
         nxPMDqpfjxhExTv0+YWO/g48HOKPtvA3JvKqehr2mF1uMF4sHWwOKL+caKYHzTksiOSy
         B1DVXugN5LoctgrtUhCRP3PwOX4hxgsiFt6qs=
MIME-Version: 1.0
In-Reply-To: <1281556723.1861.3.camel@cowboy>
References: <1281532732.2067.11.camel@cowboy>
	<1281537344.3976.32.camel@Joe-Laptop.home>
	<1281556723.1861.3.camel@cowboy>
Date: Wed, 11 Aug 2010 23:12:11 -0400
X-Google-Sender-Auth: 5M9Ru_yytsUQTOXtgnRLuOvSOaA
Message-ID: <AANLkTimEpS4APKabf1Gk_rJvBZZzVMMt-BO8oknf_v_c@mail.gmail.com>
Subject: Re: [PATCH] DRM: Replace kmalloc/memset combos with kzalloc
From: =?UTF-8?Q?Kristian_H=C3=B8gsberg?= <krh@bitplanet.net>
To: dave@gnu.org
Cc: Joe Perches <joe@perches.com>, Dave Airlie <airlied@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 3:58 PM, Davidlohr Bueso <dave@gnu.org> wrote:
> On Wed, 2010-08-11 at 07:35 -0700, Joe Perches wrote:
>> On Wed, 2010-08-11 at 09:18 -0400, Davidlohr Bueso wrote:
>> > memory allocation in drm_bufs.c is followed by initializing the memory with 0.
>> >
>> > Replace the use of kmalloc+memset with kzalloc.
>>
>> Perhaps kzalloc's with a multiply could/should also be converted
>> to kcalloc.
>>
>> > +   entry->buflist = kzalloc(count * sizeof(*entry->buflist), GFP_KERNEL);
>>
>>       entry->buflist = kcalloc(count, sizeof(*entry->buflist), GFP_KERNEL);
>>
>> etc.
>>
>> > +   entry->buflist = kzalloc(count * sizeof(*entry->buflist), GFP_KERNEL);
>> > +   entry->seglist = kzalloc(count * sizeof(*entry->seglist), GFP_KERNEL);
>> > +   entry->buflist = kzalloc(count * sizeof(*entry->buflist),
>> > +   entry->buflist = kzalloc(count * sizeof(*entry->buflist),
>>
>
> Doable, but don't see much difference. David, what do you think?

kcalloc does an integer overflow check, plus it's nice to be explicit
about allocating a number of elements of a certain size in the API.

Kristian
