Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab0G2Su6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 14:50:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56894 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab0G2Su4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 14:50:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=w/xE48fzadRqY/1wTYDbAajkF2eH39JqJvTLRq8Y8hjdT34OVMb+ATZHBaexnL8arf
         YJnAE3MeTnWLYM9b9nLPx1SedGbSNxIW7lzduQMQdH3e1M9hZ7SYq7BmKqyIp0/4rcVK
         yK57cy8s3hvx1zIy3Z/2ubVMg///syJTaDop4=
MIME-Version: 1.0
In-Reply-To: <AANLkTik4oyv4edZ6dyKiA59C9TSHWn2grQqTh30MRmC=@mail.gmail.com>
References: <AANLkTin-9jtHP1xmhUp4uUQNZD64pN3Ee5Kn2cqH64Go@mail.gmail.com>
	<4C505F86.7050509@cs.helsinki.fi>
	<AANLkTintAmpBcxbZUmMd7B7yHpVKs77xHgkjSxMY_O6J@mail.gmail.com>
	<AANLkTik-M_=G4Ks=U6hRm1dBTzbzovR47jdhjTjNqekX@mail.gmail.com>
	<4C519A6E.8000002@cs.helsinki.fi>
	<AANLkTik4oyv4edZ6dyKiA59C9TSHWn2grQqTh30MRmC=@mail.gmail.com>
Date: Thu, 29 Jul 2010 21:50:54 +0300
X-Google-Sender-Auth: ccyLoDZyupmDLh9U9eDDZMWpIEQ
Message-ID: <AANLkTinAtDQoB9VhX4J=HJSkYTM8ERBDXG8ZYng1SGYL@mail.gmail.com>
Subject: Re: [2.6.35-rc6 patch] increase kmemleak robustness at boot
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Catalin Marinas <catalin.marinas@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 9:03 PM, Daniel J Blueman
<daniel.blueman@gmail.com> wrote:
>> If it's just kmemleak_init() we're talking about, slab caches are up at that
>> point so you can just use kmalloc().
>
> The slab allocator isn't up at this point. With
> CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE set to 16K elements, an extra 3MB
> of __initdata memory is used, but freed afterwards, and it works
> great.

Right. I guess the required earlylog buffer size would be smaller if
we initialized kmemleak earlier. Can we do that in mm_init() after
kmem_cache_init()?
