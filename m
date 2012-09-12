Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab2ILTK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 15:10:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38966 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2ILTK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 15:10:56 -0400
Date: Wed, 12 Sep 2012 12:10:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dave@gnu.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] lib: gcd: prevent possible div by 0
Message-Id: <20120912121055.bd417043.akpm@linux-foundation.org>
In-Reply-To: <1347287719.2561.14.camel@offbook>
References: <1347287719.2561.14.camel@offbook>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2012 16:35:19 +0200
Davidlohr Bueso <dave@gnu.org> wrote:

> Account for all properties when a and/or b are 0:
> gcd(0, 0) = 0
> gcd(a, 0) = a
> gcd(0, b) = b
> 
> Cc: stable@vger.kernel.org

Why cc:stable?  If this patch fixes some known problem in the current
kernel then that really really should have been described in the
changelog.  Always.  Please.

> ...
> --- a/lib/gcd.c
> +++ b/lib/gcd.c
> @@ -9,6 +9,9 @@ unsigned long gcd(unsigned long a, unsigned long b)
>  
>  	if (a < b)
>  		swap(a, b);
> +
> +	if (!b)
> +		return a;
>  	while ((r = a % b) != 0) {
>  		a = b;
>  		b = r;
> -- 
> 1.7.9.5
> 
> 
