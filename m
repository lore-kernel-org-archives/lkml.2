Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934257Ab0D3TIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:08:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932701Ab0D3TH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 15:07:59 -0400
Date: Fri, 30 Apr 2010 12:07:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] lib: introduce common method to convert hex
 digits
Message-Id: <20100430120703.ffab0258.akpm@linux-foundation.org>
In-Reply-To: <d5c4e26cc74458dd77102c4274d3260149717328.1272617852.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
	<d5c4e26cc74458dd77102c4274d3260149717328.1272617852.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Apr 2010 12:34:00 +0300
Andy Shevchenko <ext-andriy.shevchenko@nokia.com> wrote:

>  /**
> + * hex_to_bin - convert a hex digit to its real value
> + * @ch: ascii character represents hex digit
> + *
> + * hex_to_bin() converts one hex digit to its actual value or -1 in case of bad
> + * input.
> + */
> +int hex_to_bin(char ch)
> +{
> +	if ((ch >= 'a') && (ch <= 'f'))
> +		return ch - 'a' + 10;
> +	if ((ch >= '0') && (ch <= '9'))
> +		return ch - '0';
> +	if ((ch >= 'A') && (ch <= 'F'))
> +		return ch - 'A' + 10;
> +	return -1;
> +}
> +EXPORT_SYMBOL(hex_to_bin);

I had to fiddle with it:

- use tolower(), saving 3 bytes!

- test the more common case first - it's quicker.

diff -puN lib/hexdump.c~lib-introduce-common-method-to-convert-hex-digits-fix lib/hexdump.c
--- a/lib/hexdump.c~lib-introduce-common-method-to-convert-hex-digits-fix
+++ a/lib/hexdump.c
@@ -24,12 +24,11 @@ EXPORT_SYMBOL(hex_asc);
  */
 int hex_to_bin(char ch)
 {
-	if ((ch >= 'a') && (ch <= 'f'))
-		return ch - 'a' + 10;
+	ch = tolower(ch);
 	if ((ch >= '0') && (ch <= '9'))
 		return ch - '0';
-	if ((ch >= 'A') && (ch <= 'F'))
-		return ch - 'A' + 10;
+	if ((ch >= 'a') && (ch <= 'f'))
+		return ch - 'a' + 10;
 	return -1;
 }
 EXPORT_SYMBOL(hex_to_bin);
_


Yielding

int hex_to_bin(char ch)
{
	ch = tolower(ch);
	if ((ch >= '0') && (ch <= '9'))
		return ch - '0';
	if ((ch >= 'a') && (ch <= 'f'))
		return ch - 'a' + 10;
	return -1;
}

