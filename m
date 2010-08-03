Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab0HCW2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 18:28:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755997Ab0HCW22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 18:28:28 -0400
Date: Tue, 3 Aug 2010 15:28:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ben Woodard <bwoodard@llnl.gov>, Brian Behlendorf <behlendorf1@llnl.gov>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Mark Grondona <mgrondona@llnl.gov>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial, document that div64_u64() is not precise on
 32bit platforms
Message-Id: <20100803152812.210439dc.akpm@linux-foundation.org>
In-Reply-To: <20100802160951.GA13385@redhat.com>
References: <20100802160951.GA13385@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Aug 2010 18:09:51 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> We have a bugreport which blames div64_u64() on 32bit platforms.
> 
> However, the code obviously doesn't even try to pretend it can do
> the 64bit division precisely. If there is something in the high
> word of divisor, div64_u64() just shifts both arguments and throws
> out the low bits.
> 
> Add a small comment to avoid the confusion.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
> 
>  lib/div64.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> --- a/lib/div64.c
> +++ b/lib/div64.c
> @@ -77,7 +77,10 @@ s64 div_s64_rem(s64 dividend, s32 diviso
>  EXPORT_SYMBOL(div_s64_rem);
>  #endif
>  
> -/* 64bit divisor, dividend and result. dynamic precision */
> +/*
> + * 64bit divisor, dividend and result. Dynamic precision, unless
> + * divisor fits in u32 result is not exactly correct.
> + */
>  #ifndef div64_u64
>  u64 div64_u64(u64 dividend, u64 divisor)
>  {

Well that was a bit lazy of us - I wonder how hard it is to fix.

At present people will test their code on 64-bit only to find out later
that it doesn't work correctly on 32-bit.  Bad.  Perhaps we should
similarly break the 64-bit version :)

