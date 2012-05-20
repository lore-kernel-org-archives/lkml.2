Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab2ETP6h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 11:58:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:18249 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab2ETP6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 11:58:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="102128810"
Message-ID: <4FB914A6.2000809@linux.intel.com>
Date: Sun, 20 May 2012 08:58:30 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Arthur Marsh <arthur.marsh@internode.on.net>
CC: Jarkko Sakkinen <jarkko.sakkinen@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: commit 6520fe5564acf07ade7b18a1272db1184835c487 "x86, realmode:
 16-bit real-mode code support for relocs tool" breaks cross-compilation from
 x86-64 -> x86-32
References: <4FB8D7A8.60900@internode.on.net>
In-Reply-To: <4FB8D7A8.60900@internode.on.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2012 04:38 AM, Arthur Marsh wrote:
> Hi, I normally use the make-kpkg script on Debian unstable on an AMD64
> machine to rebuild 32-bit x86 kernels via the following command line:
> 
> CONCURRENCY_LEVEL=8 DEB_HOST_ARCH=i386 \
> MAKEFLAGS="CC=gcc-4.7 LD=ld.gold" make-kpkg \
> --initrd --config menuconfig --arch i386 \
> --cross-compile - linux-image
> 
> This failed recently with the output:
> 
> 
> Is this a problem with the Debian mk-kpkg command from kernel-package or
> the kernel's own build system?
> 

Neither.  It means you have exposed a linker bug.  It was believed to be
only in GNU ld, but apparently it is in gold as well (building the
kernel with gold has always been iffy.)

The bisect isn't very useful, because you really want the result from
two patches later.

Let me emphasize: these patches only *detect* the failure, turning it
from silent corruption to an error message.

	-hpa


