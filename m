Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab2IZXuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 19:50:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56967 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab2IZXup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 19:50:45 -0400
Date: Wed, 26 Sep 2012 16:50:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: Daniel Santos <danielfsantos@att.net>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, torvalds@linux-foundation.org
Subject: Re: Please be aware that __always_inline doesn't mean
 "always inline"!
Message-Id: <20120926165044.46b8f7d6.akpm@linux-foundation.org>
In-Reply-To: <50638DCC.5040506@att.net>
References: <50638DCC.5040506@att.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2012 18:20:44 -0500
Daniel Santos <danielfsantos@att.net> wrote:

> I've noticed that there's a lot of misperception about the meaning of
> the __always_inline, or more specifically,
> __attribute__((always_inline)), which does not actually cause the
> function to always be inlined.  Rather, it *allows* gcc to inline the
> function, even when compiling without optimizations.  Here is the
> description of the attribute from gcc's docs
> (http://gcc.gnu.org/onlinedocs/gcc-4.7.2/gcc/Function-Attributes.html)
> 
> always_inline
> Generally, functions are not inlined unless optimization is specified.
> For functions declared inline, this attribute inlines the function even
> if no optimization level was specified.
> 
> This would even appear to imply that such functions aren't even marked
> as "inline" (something I wasn't aware of until today).  The only
> mechanism I'm currently aware of to force gcc to inline a function is
> the flatten attribute (see https://lkml.org/lkml/2012/9/25/643) which
> works backwards, you declare it on the calling function, and it forces
> gcc to inline all functions (marked as inline) that it calls.

As I mentioned in the other thread, the __always_inline's in fs/namei.c
(at least) are doing exactly what we want them to do, so some more
investigation is needed here?

