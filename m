Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab0CXShj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 14:37:39 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:63691 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960Ab0CXShi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 14:37:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=O2Ww9/acV6VvTD4Qrjbzv9MTRlWkZYBfsTogC9ww7lnbvJkQhJ6RBT4d48C1unQL//
         3UVZ84cFCU76TRNK8aphWaAjiMvCqfcGmcfm8MDxkjSjP7+uh37ul1tb5K+6U0X01TZe
         9VaBl5w6t4zMqhI14+ky+F7f36ygRnykpKr0s=
MIME-Version: 1.0
In-Reply-To: <20100324112106.c8e7b96d.akpm@linux-foundation.org>
References: <1268849455-19503-1-git-send-email-Joakim.Tjernlund@transmode.se>
	 <20100324112106.c8e7b96d.akpm@linux-foundation.org>
Date: Wed, 24 Mar 2010 19:37:36 +0100
X-Google-Sender-Auth: 0dfc89ce82027964
Message-ID: <10f740e81003241137y382d155fnb777344d3af25f03@mail.gmail.com>
Subject: Re: [PATCH] [RFC] #define __BYTE_ORDER
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 19:21, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 17 Mar 2010 19:10:55 +0100
> Joakim Tjernlund <Joakim.Tjernlund@transmode.se> wrote:
>
>> Linux does not define __BYTE_ORDER in its endian header files
>> which makes some header files bend backwards to get at the
>> current endian. Lets #define __BYTE_ORDER in big_endian.h/litte_endian.h
>> to make it easier for header files that are used in user space too.
>
> I don't get it.  Why not nuke __BYTE_ORDER altogether and do `#ifdef
> __LITTLE_ENDIAN' and `#ifdef __BIG_ENDIAN' everywhere?

Because in userspace the convention is that
  1. _both_ __LITTLE_ENDIAN and __BIG_ENDIAN are defined,
  2. you have to test for e.g. __BYTE_ORDER == __BIG_ENDIAN.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
