Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab1CJBVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 20:21:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34652 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab1CJBVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 20:21:45 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=XbqWoAS_rckA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=QyXUC8HyAAAA:8 a=meVymXHHAAAA:8 a=IJlZ1Zyr6yCxRPQNMmYA:9 a=1IemOzciALP8efYMduzlxaTV7DYA:4 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH trace-cmd 3/3] Revert "trace-cmd: Use conditional
 assignment of CC and AR"
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com,
        Darren Hart <dvhart@linux.intel.com>
In-Reply-To: <1299715137-22768-3-git-send-email-dhsharp@google.com>
References: <1299715137-22768-1-git-send-email-dhsharp@google.com>
	 <1299715137-22768-3-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 09 Mar 2011 20:21:42 -0500
Message-ID: <1299720102.15854.269.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 15:58 -0800, David Sharp wrote:
> This reverts commit 6c696cec3f264a9399241b6e648f58bc97117d49.
> 
> Make has default values CC and AR of 'cc' and 'ar' respectively. This means
> that "CC ?= anything" will never have effect, because CC is always already set.
> Because of this, 6c696cec makes setting CROSS_COMPILE from the command line or
> environment useless.

Darren, can you verify this, as you were the one to make the original
change. I never had to cross compile it, I always did it natively.

David, Thanks! I'll go ahead and apply patch 1 and 2, and I'll wait for
a reply from Darren for this patch.

-- Steve

> 
> Signed-off-by: David Sharp <dhsharp@google.com>
> Cc: Darren Hart <dvhart@linux.intel.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  Makefile |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 169fcbc..fa37df5 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -13,8 +13,8 @@ FILE_VERSION = 6
>  
>  MAKEFLAGS += --no-print-directory
>  
> -CC ?= $(CROSS_COMPILE)gcc
> -AR ?= $(CROSS_COMPILE)ar
> +CC = $(CROSS_COMPILE)gcc
> +AR = $(CROSS_COMPILE)ar
>  EXT = -std=gnu99
>  INSTALL = install
>  


