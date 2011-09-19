Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab1ISVUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 17:20:55 -0400
Received: from smtp-out.google.com ([216.239.44.51]:42382 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495Ab1ISVUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 17:20:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=pJmHyiWqiHYQzy2As5tAhvABeD8WMbUPVa2JB8nKKZKC8lP+yCulHMx9U3tYJgHnn
	HFreY1oGJRk7JDyxmZXuQ==
Date: Mon, 19 Sep 2011 14:20:43 -0700
From: Andrew Morton <akpm@google.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        David Safford <safford@watson.ibm.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 2/5] lib: add error checking to hex2bin
Message-Id: <20110919142043.83684050.akpm@google.com>
In-Reply-To: <1316177430-13167-2-git-send-email-zohar@linux.vnet.ibm.com>
References: <1316177430-13167-1-git-send-email-zohar@linux.vnet.ibm.com>
	<1316177430-13167-2-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Sep 2011 08:50:27 -0400
Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> --- a/lib/hexdump.c
> +++ b/lib/hexdump.c
> @@ -38,14 +38,17 @@ EXPORT_SYMBOL(hex_to_bin);
>   * @dst: binary result
>   * @src: ascii hexadecimal string
>   * @count: result length
> + *
> + * Returns true on success, false in case of bad input.
>   */
> -void hex2bin(u8 *dst, const char *src, size_t count)
> +bool hex2bin(u8 *dst, const char *src, size_t count)
>  {
>  	while (count--) {
> -		*dst = hex_to_bin(*src++) << 4;
> -		*dst += hex_to_bin(*src++);
> -		dst++;
> +		if (!unpack_hex_byte(dst++, src))
> +			return false;
> +		src += 2;
>  	}
> +	return true;
>  }
>  EXPORT_SYMBOL(hex2bin);

Again, this is very unconventional for kernel code, and it's for no good
reason.  Please, stick with 0/-1 unless there's a good reason to diverge
from that.
