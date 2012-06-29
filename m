Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350Ab2F2QIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:08:09 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43345 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751336Ab2F2QII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:08:08 -0400
Message-ID: <1340986086.6562.36.camel@joe2Laptop>
Subject: Re: [RFC][PATCH 1/2] lib: printf: append support of '%*p[Mm][FR]'
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: proski@gnu.org, Andrei Emeltchenko <andrei.emeltchenko@intel.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 29 Jun 2012 09:08:06 -0700
In-Reply-To: <1340985513-15655-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <20110930115306.3bc105cb@mj>
	 <1340985513-15655-1-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-29 at 18:58 +0300, Andy Shevchenko wrote:
> There are many places in the kernel where the drivers print small buffers as a
> hex string. This patch adds a support of the variable width buffer to print it
> as a hex string with a delimiter. The idea came from Pavel Roskin here:
> http://www.digipedia.pl/usenet/thread/18835/17449/

Seems sensible, but one stack caveat below

> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]
> @@ -655,11 +655,12 @@ char *resource_string(char *buf, char *end, struct resource *res,
>  }
>  
>  static noinline_for_stack
> -char *mac_address_string(char *buf, char *end, u8 *addr,
> -			 struct printf_spec spec, const char *fmt)
> +char *hex_string(char *buf, char *end, u8 *addr, struct printf_spec spec,
> +		 const char *fmt)
>  {
> -	char mac_addr[sizeof("xx:xx:xx:xx:xx:xx")];
> -	char *p = mac_addr;
> +	char hex_str[64*3];	/* support up to 64 bytes to print */

Might be too much stack though.


