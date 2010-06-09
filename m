Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab0FIKHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:07:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43652 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183Ab0FIKHB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:07:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kVH8AxtLyTA9HMcJIkSu02L30QbjsKFV0VStC98NL1XQe0t6al+IqGjv/RLaZ2v3Oe
         PrVchIyyJsihOBxHPshZqgcqEQhKEtH1tZot/ZmZoHZPiNDJeUwCsBJPG/0TVzSiFO/J
         L4FdHq0W82LK1Ezz/M5+FyW3gGxQv1c2eX6j0=
MIME-Version: 1.0
In-Reply-To: <1276068001_13533@mail4.comsite.net>
References: <96933b66aa5f995746a34410ca63e5e8b84593cb.1275968594.git.joe@perches.com>
	<cover.1275968594.git.joe@perches.com>
	<1276068001_13533@mail4.comsite.net>
Date: Wed, 9 Jun 2010 13:06:59 +0300
X-Google-Sender-Auth: jPg6AMbOgln-KKI5RdlJmvVEEOA
Message-ID: <AANLkTimSgiMP8EZ57Eba00vGsVTA3QKRZbh1bNYavISv@mail.gmail.com>
Subject: Re: [PATCH 00/12] treewide: Remove unnecessary kmalloc casts
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Milton Miller <miltonm@bga.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Milton,

On Wed, Jun 9, 2010 at 10:20 AM, Milton Miller <miltonm@bga.com> wrote:
> However, in this case you are removing casts that, while not necessary
> for C, are indeed there for a reason.
>
> Specifically, they are of the form
>   type *p;
>   <code>
>   p = (type *)kmalloc(sizeof(type), ...);
>
> For example, from the powerpc patch:
>> goto out;
>> }
>> - tmp_part = (struct nvram_partition *)
>> - kmalloc(sizeof(struct nvram_partition), GFP_KERNEL);
>> + tmp_part = kmalloc(sizeof(struct nvram_partition), GFP_KERNEL);
>> err = -ENOMEM;
>
> The reason they casts are present is to guard against someone changing
> the type of p at the top of the function and not changing the type at
> the kmalloc.

If you're worried about that...

[snip]

> There may have been discussion of doing the above vs
>   p = kmalloc(sizeof(*p), ...);

...it's better to use this form. There's actually a mention of this in
"Chapter 14: Allocating memory" of Documentation/CodingStyle. The
guard is not really a guard as someone can still change the "sizeof"
part to something else and the cast from "void *" will silently ignore
it.

                        Pekka
