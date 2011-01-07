Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab1AGOJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 09:09:58 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:56394 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1AGOJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 09:09:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
Subject: Re: [PATCHv1 01/12] unicore32 core architecture: build infrastructure
Date: Fri, 7 Jan 2011 01:18:41 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <00c601cba463$69533750$3bf9a5f0$@mprc.pku.edu.cn>
In-Reply-To: <00c601cba463$69533750$3bf9a5f0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Message-Id: <201101070118.41900.arnd@arndb.de>
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:ePbXrzOanPfZCj9IxN1nOwU8gONkafCNQrWzR+DMB8o
 1U9+BrPoW3qU7hY+6P2X8tfKGjOdaE0iAm4oiLsrPY8rXd2Dwp
 /4Q/PKLV0EXYKgUuArLWQaXS8K4gyGeO3jCeZmupFRcEuSNzNf
 poAWXD8XZEOQQ9aDXn3cujEWNe0YsOsZ6Ir63BAmhVlp8fvaiI
 eJ3XJ2wb7c+r986qQ3lKg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 December 2010, Guan Xuetao wrote:
> From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> 
> This patch implements build infrastructure.

Sorry for the late reply, I was planning to do the new review earlier, but didn't
get to it before the Christmas break.

Overall, I can see that there has been a lot of good progress in the code since
the original versions that I looked at, very nice!

> diff --git a/arch/unicore32/.gitignore b/arch/unicore32/.gitignore
> new file mode 100644
> index 0000000..f0fc866
> --- /dev/null
> +++ b/arch/unicore32/.gitignore
> @@ -0,0 +1,70 @@
> +#
> +# Generated include files
> +#
> +include/asm/atomic.h
> +include/asm/auxvec.h
> +include/asm/bitsperlong.h
> +include/asm/bug.h
> +include/asm/bugs.h
> +include/asm/cputime.h
> +include/asm/current.h
> +include/asm/device.h
> +include/asm/emergency-restart.h
> +include/asm/errno.h
> +include/asm/fb.h
> +include/asm/fcntl.h
> +include/asm/hardirq.h
> ...

Maybe it would be better to put these files into a separate directory, like
arch/unicore32/include/generated/asm, to make it easier to separate them
from the other files and avoid listing them all in .gitignore besides the
other places.

It's certainly good to see so many of these files.

> +config GENERIC_GPIO
> +	def_bool y
> +
> +config GENERIC_CLOCKEVENTS
> +	bool
> +
> +config NO_IOPORT
> +	bool
> +
> +config GENERIC_HARDIRQS
> +	bool
> +	default y

You are somewhat inconsistent with "def_bool", "default y" and "select FOO",
which all have the same effect. I would recommend using def_bool y where
possible.

> +config REALMODE
> +	bool

I don't see this being used anywhere. Is it just a leftover from an earlier
version, or did I miss something?

> +choice
> +	prompt "PKUnity system type"
> +	default ARCH_PUV3
> +
> +	config ARCH_PUV3
> +	bool "PKUnity v3 (SuperK)"
> +	select CPU_UCV2
> +	select GENERIC_CLOCKEVENTS
> +	select HAVE_CLK
> +	select ARCH_REQUIRE_GPIOLIB
> +	select ARCH_HAS_CPUFREQ
> +
> +endchoice

As long as there is only one option, you can drop the entire "choice"
statement.

> +config DEBUG_USER
> +	bool "Verbose user fault messages"
> +	help
> +	  When a user program crashes due to an exception, the kernel can
> +	  print a brief message explaining what the problem was. This is
> +	  sometimes helpful for debugging but serves no purpose on a
> +	  production system. Most people should say N here.
> +
> +	  In addition, you need to pass user_debug=N on the kernel command
> +	  line to enable this feature.  N consists of the sum of:
> +
> +	      1 - undefined instruction events
> +	      2 - system calls
> +	      4 - invalid data aborts
> +	      8 - SIGSEGV faults
> +	     16 - SIGBUS faults

We already have four architectures doing this using the "exception-trace"
sysctl and the show_unhandled_signals variable. Please follow what those
architectures are doing, or remove the option and all code depending on
it.


	Arnd

