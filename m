Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab1CJB1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 20:27:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:3504 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab1CJB1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 20:27:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,293,1297065600"; 
   d="scan'208";a="611070360"
Message-ID: <4D7828F9.7000906@linux.intel.com>
Date: Wed, 09 Mar 2011 17:27:21 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: David Sharp <dhsharp@google.com>
CC: linux-kernel@vger.kernel.org, rostedt@goodmis.org, mrubin@google.com
Subject: Re: [PATCH trace-cmd 3/3] Revert "trace-cmd: Use conditional assignment
 of CC and AR"
References: <1299715137-22768-1-git-send-email-dhsharp@google.com> <1299715137-22768-3-git-send-email-dhsharp@google.com>
In-Reply-To: <1299715137-22768-3-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2011 03:58 PM, David Sharp wrote:
> This reverts commit 6c696cec3f264a9399241b6e648f58bc97117d49.
>
> Make has default values CC and AR of 'cc' and 'ar' respectively. This means
> that "CC ?= anything" will never have effect, because CC is always already set.
> Because of this, 6c696cec makes setting CROSS_COMPILE from the command line or
> environment useless.

The problem with this approach is it prevents the user from setting CC 
explicitly with the environment which is a very common way of using a 
specific version of gcc (for example). It also places restrictions on 
the filename of the compiler (it must end in gcc - so gcc-4.5.1 cannot 
work), this isn't acceptable.

You could use CC=your-cross-compiler, and if that doesn't work for you, 
you could prepare a patch that conditionally sets CC only if 
CROSS_COMPILE is set, but please do not simply revert this patch which 
solved a real problem with the Makefile.

--
Darren

> Signed-off-by: David Sharp<dhsharp@google.com>
> Cc: Darren Hart<dvhart@linux.intel.com>
> Cc: Steven Rostedt<rostedt@goodmis.org>
> ---
>   Makefile |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index 169fcbc..fa37df5 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -13,8 +13,8 @@ FILE_VERSION = 6
>
>   MAKEFLAGS += --no-print-directory
>
> -CC ?= $(CROSS_COMPILE)gcc
> -AR ?= $(CROSS_COMPILE)ar
> +CC = $(CROSS_COMPILE)gcc
> +AR = $(CROSS_COMPILE)ar
>   EXT = -std=gnu99
>   INSTALL = install
>


-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
