Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab1LSI1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 03:27:47 -0500
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:55916
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751713Ab1LSI1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 03:27:44 -0500
Message-ID: <4EEEF570.2040502@compulab.co.il>
Date: Mon, 19 Dec 2011 10:27:28 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.17) Gecko/20110824 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
CC: Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Fix cross compilation broken by failing size command
References: <Message-ID: <20111214215815.GP32251@atomide.com> <1324032146-723-1-git-send-email-jkrzyszt@tis.icnet.pl>
In-Reply-To: <1324032146-723-1-git-send-email-jkrzyszt@tis.icnet.pl>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Janusz,

On 12/16/11 12:42, Janusz Krzysztofik wrote:
> Since commit 5ffb04f6690d71fab241b3562ebf52b893ac4ff1, "ARM: zImage:
> make sure appended DTB doesn't get overwritten by kernel .bss", the
> native 'size' command, which is now always used for calculation of the
> kernel bss size, may break in selected cross compilation environments
> with error messages like:
> 
> size: arch/arm/boot/compressed/../../../../vmlinux: File format is ambiguous
> size: Matching formats: elf32-littlearm elf32-littlearm-symbian elf32-littlearm-vxworks
> 
> As a consequence, the KBSS_SZ variable extracted from the size output is
> empty, and the the final linker command, provided with incorrectly
> formatted arguments, also fails:
> 
>   LD      arch/arm/boot/compressed/vmlinux
>   arm-angstrom-linux-uclibcgnueabi-ld:--defsym _kernel_bss_size=: syntax error
> 
> Don't append the '_kernel_bss_size=$(KBSS_SZ)' argument to the linker
> command line if that variable is empty because of the failing size
> command. Moreover, use $(CROSS_COMPILE)size if available instead of
> native size.
> 
> Created and tested against linux-3.2-rc5.
> 
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
> ---

Tested-by: Igor Grinberg <grinberg@compulab.co.il>

Thanks for the patch, it fixes the build for me, so you are
not the only one having this issue...
I currently, use CodeSourcery 2010q1, but have multiple
cross tool chains installed.


-- 
Regards,
Igor.
