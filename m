Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab2FTVUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 17:20:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49604 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758101Ab2FTVT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 17:19:58 -0400
Date: Wed, 20 Jun 2012 14:19:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] Docs: printk-formats: add description for %pMR
Message-Id: <20120620141957.d865133a.akpm@linux-foundation.org>
In-Reply-To: <1340189089-20257-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
References: <1338210316-12299-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	<1340189089-20257-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2012 13:44:49 +0300
Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com> wrote:

> From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
> 
> Add information about new specifier %pMR for Bluetooth addresses.
> 
> ...
>
> --- a/Documentation/printk-formats.txt
> +++ b/Documentation/printk-formats.txt
> @@ -56,6 +56,7 @@ Struct Resources:
>  MAC/FDDI addresses:
>  
>  	%pM	00:01:02:03:04:05
> +	%pMR	05:04:03:02:01:00
>  	%pMF	00-01-02-03-04-05
>  	%pm	000102030405
>  
> @@ -67,6 +68,10 @@ MAC/FDDI addresses:
>  	the 'M' specifier to use dash ('-') separators instead of the default
>  	separator.
>  
> +	For Bluetooth addresses the 'R' specifier shall be used after the 'M'
> +	specifier to use reversed byte order suitable for visual interpretation
> +	of Bluetooth addresses which are in the little endian order.
> +

huh, I didn't know about that file, or I forgot about it.  I wonder if
it is otherwise up to date.

Do we really need it?  If we can sufficiently document the printk
formats in lib/vsprintf.c then let's remove
Documentation/printk-formats.txt.  Otherwise, I shall do this:


--- a/lib/vsprintf.c
+++ a/lib/vsprintf.c
@@ -1297,6 +1297,8 @@ qualifier:
  *   case.
  * %n is ignored
  *
+ * ** Please update Documentation/printk-formats.txt when making changes **
+ *
  * The return value is the number of characters which would
  * be generated for the given input, excluding the trailing
  * '\0', as per ISO C99. If you want to have the exact
_

