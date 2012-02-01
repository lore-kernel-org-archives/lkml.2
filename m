Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab2BAXmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 18:42:17 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58566 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab2BAXmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 18:42:16 -0500
Date: Thu, 2 Feb 2012 02:42:08 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [06/20] crypto: sha512 - reduce stack usage to safe number
Message-ID: <20120201234208.GA28700@p183.telecom.by>
References: <20120201210055.GA25374@kroah.com>
 <20120201201531.599621544@clark.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120201201531.599621544@clark.kroah.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 12:14:08PM -0800, Greg KH wrote:
> @@ -87,38 +87,48 @@ sha512_transform(u64 *state, const u8 *i
>  	u64 a, b, c, d, e, f, g, h, t1, t2;
>  
>  	int i;
> -	u64 W[80];
> +	u64 W[16];

This needs 3rd companion patch which does stack reduction even on i386.
Patch which removes excessive loop unrolling and thus fixes the problem
has been posted. Maybe there is some other way to maintain low stack
space on i386 but I haven't found it.

http://marc.info/?l=linux-netdev&m=132768692525017&w=4

If you apply only 2, original bug will be fixed, but on at least i386
stack usage could go in 900-byte region.
