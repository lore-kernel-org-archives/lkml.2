Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab2DNVMX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 17:12:23 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57563 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab2DNVMW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 17:12:22 -0400
MIME-Version: 1.0
In-Reply-To: <1334441685-4438-2-git-send-email-levinsasha928@gmail.com>
References: <1334441685-4438-1-git-send-email-levinsasha928@gmail.com> <1334441685-4438-2-git-send-email-levinsasha928@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Apr 2012 14:12:00 -0700
X-Google-Sender-Auth: sJjw9ckrw5DYdcE5viq-W6oqaWk
Message-ID: <CA+55aFwvP=SHw9VcsPApW5xdpOdTU5MKekjVdxKzGe1zfeLL+A@mail.gmail.com>
Subject: Re: [RFC 1/3] typecheck: extend typecheck.h with more useful
 typechecking macros
To: Sasha Levin <levinsasha928@gmail.com>
Cc: akpm@linux-foundation.org, peterz@infradead.org, mingo@elte.hu,
        hpa@zytor.com, tglx@linutronix.de, srivatsa.bhat@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 3:14 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> +#define typecheck2(type,x,y)           \
> +({     typecheck(type, x);             \
> +       typecheck(type, y);             \
> +       1;                              \
> +})

This seems silly.

Since typecheck() is already a nice expression returning 1, there's no
reason to do *another* level of statement expressions. So it would be
just

  #define typecheck2(type,x,y) \
    (typecheck(type, x), typecheck(type, y))

instead.

Which makes me suspect you don't really need that whole typecheck2 etc
macro set at all.

                 Linus
