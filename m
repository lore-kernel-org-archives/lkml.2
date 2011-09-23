Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab1IWUS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 16:18:27 -0400
Received: from smtp-out.google.com ([74.125.121.67]:7566 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab1IWUS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 16:18:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=eB/S6gaXZ0RW9oxZNkCRpBSovZGYHIfvQ3ZDN6T0i5+gv2XvXiIy08w9R7mOt72PW
	ALXyc5EPfFOl+z30l49vA==
Date: Fri, 23 Sep 2011 13:18:19 -0700
From: Andrew Morton <akpm@google.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kernel.h: rename pack_hex_byte to hex_pack_byte
Message-Id: <20110923131819.fdaed4ab.akpm@google.com>
In-Reply-To: <fa146966b0ce1e7f04d59eb27cc0e968f51b22de.1316774801.git.andriy.shevchenko@linux.intel.com>
References: <20110919232602.ac450450.akpm00@gmail.com>
	<fa146966b0ce1e7f04d59eb27cc0e968f51b22de.1316774801.git.andriy.shevchenko@linux.intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Sep 2011 13:47:26 +0300
Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> As suggested by Andrew Morton in [1] there is better to have most significant
> part first in the function name.
> 
> [1] https://lkml.org/lkml/2011/9/20/22
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  include/linux/kernel.h |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 46ac9a5..5022158 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -374,13 +374,18 @@ extern const char hex_asc[];
>  #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
>  #define hex_asc_hi(x)	hex_asc[((x) & 0xf0) >> 4]
>  
> -static inline char *pack_hex_byte(char *buf, u8 byte)
> +static inline char *hex_byte_pack(char *buf, u8 byte)
>  {
>  	*buf++ = hex_asc_hi(byte);
>  	*buf++ = hex_asc_lo(byte);
>  	return buf;
>  }
>  
> +static inline char * __deprecated pack_hex_byte(char *buf, u8 byte)
> +{
> +	return hex_byte_pack(buf, byte);
> +}
> +

err, no thanks.  That's just going to hit everyone with great
screenfuls of compile warnings while waiting for someone else to fix
them up.

