Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab2KGHV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:21:59 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:30146 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab2KGHV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:21:58 -0500
X-IronPort-AV: E=Sophos;i="4.80,727,1344211200"; 
   d="scan'208";a="213699955"
Message-ID: <1352272794.12977.17.camel@hastur.hellion.org.uk>
Subject: Re: [Xen-devel] [PATCH 1/2] xen/generic: Disable fallback build on
 ARM.
From: Ian Campbell <ian.campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Date: Wed, 7 Nov 2012 08:19:54 +0100
In-Reply-To: <1352239982-17389-2-git-send-email-konrad.wilk@oracle.com>
References: <1352239982-17389-1-git-send-email-konrad.wilk@oracle.com>
	 <1352239982-17389-2-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-06 at 22:13 +0000, Konrad Rzeszutek Wilk wrote:
> As there is no need for it (the fallback code is for older
> hypervisors and they won't run under ARM), 

I think more specifically they won't run on anything other than x86.

[...]
> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index 46de6cd..273d2b9 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -1,8 +1,8 @@
>  ifneq ($(CONFIG_ARM),y)
> -obj-y	+= manage.o balloon.o
> +obj-y	+= manage.o balloon.o fallback.o
>  obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
>  endif

I think :
  obj-$(CONFIG_X86) += fallback.o
would better reflect what is going on here.


