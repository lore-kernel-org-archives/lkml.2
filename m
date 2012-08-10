Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab2HJGHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 02:07:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15651 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab2HJGHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 02:07:39 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-4f-5024a52910e8
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        "'Ben Dooks'" <ben-linux@fluff.org>
References: <1344461278-28245-1-git-send-email-arnd@arndb.de>
 <1344461278-28245-9-git-send-email-arnd@arndb.de>
In-reply-to: <1344461278-28245-9-git-send-email-arnd@arndb.de>
Subject: RE: [PATCH 08/10] ARM: s3c24xx: enable CONFIG_BUG for tct_hammer
Date: Fri, 10 Aug 2012 15:07:37 +0900
Message-id: <0dd301cd76be$7101a750$5304f5f0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac11rLtABXA3eLUrTm+Uu/O9fvWgRwBEUcKQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jAV3NpSoBBlenaFpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M5jNHWQuui1Xcmv+IvYHxgVAXIyeHhICJxN4jP9ggbDGJC/fW
	A9lcHEICixglzkycwwjhzGOSuL//OFgVm4CGxOH3z9hBbBEBT4kzJxewgNjMAqESR0+8AasR
	EiiUaJ/RCBbnFLCT2HHyJSOILQxU3zrvAGsXIwcHi4CqxJQvGiBhXgFbie8nHrFC2IISPybf
	gxqpJbF+53EmCFteYvOat8wgrRIC6hKP/upCXGAk0bb6HyNEiYjEvhfvGCcwCs1CMmkWkkmz
	kEyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgMH4mtYNxZYPFIUYBDkYlHt5E
	XpUAIdbEsuLK3EOMEhzMSiK8KS+UA4R4UxIrq1KL8uOLSnNSiw8xSnOwKInzGnt/9RcSSE8s
	Sc1OTS1ILYLJMnFwSjUwLiuo2/t+gqxw48Til4b9gvw3Wf9vPntJwPxi3tPjJueNjsjvOX55
	27Mf5/+sWcN5c+H+4OyfWYceRm7Y59G4lEckM1rikXXQ8ZMrbibNnfKRT/7OtsZwqdMlHEer
	N/fXK00wWMSar32xbYkHe9dfk32X6jmny1SvTFdLOzmFebHxO5e5Fe7VFkosxRmJhlrMRcWJ
	AOTd6xxfAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> Disabling CONFIG_BUG creates an insane amount of build warnings, which
> makes it useless to check for building defconfigs to see if new
> warnings show up.
> 
> Without this patch, building tct_hammer_defconfig results in:
> 
> net/packet/af_packet.c: In function 'tpacket_rcv':
> net/packet/af_packet.c:1889:30: warning: 'hdrlen' may be used
> uninitialized in this function [-Wuninitialized]
> net/core/ethtool.c: In function 'ethtool_get_feature_mask':
> net/core/ethtool.c:213:1: warning: control reaches end of non-void
> function [-Wreturn-type]
> block/cfq-iosched.c: In function 'cfq_async_queue_prio':
> block/cfq-iosched.c:2914:1: warning: control reaches end of non-void
> function [-Wreturn-type]
> mm/bootmem.c: In function 'mark_bootmem':
> mm/bootmem.c:352:1: warning: control reaches end of non-void function [-
> Wreturn-type]
> net/core/dev.c: In function 'skb_warn_bad_offload':
> net/core/dev.c:1904:33: warning: unused variable 'null_features' [-
> Wunused-variable]
> drivers/mtd/chips/cfi_probe.c: In function 'cfi_chip_setup':
> include/linux/mtd/cfi.h:489:3: warning: 'r.x[0]' may be used uninitialized
> in this function [-Wuninitialized]
> include/linux/mtd/map.h:394:11: note: 'r.x[0]' was declared here
> include/linux/mtd/cfi.h:489:3: warning: 'r.x[0]' may be used uninitialized
> in this function [-Wuninitialized]
> (and many more)
> 
> The size of vmlinux increases by 1.78% because of this:
> 
> size obj-arm/vmlinux.nobug
>    text    data     bss     dec     hex filename
>    2108474  116916   55352 2280742  22cd26 obj-arm/vmlinux
> size obj-arm/vmlinux.bug
>    text    data     bss     dec     hex filename
>    2150804  116916   53696 2321416  236c08 obj-arm/vmlinux
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Kukjin Kim <kgene.kim@samsung.com>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

BTW, I'm not sure we should still keep the tct_hammer_defconfig because
s3c2410_defconfig is including MACH_TCT_HAMMER, its selection are different
though.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.


> Cc: Ben Dooks <ben-linux@fluff.org>
> ---
>  arch/arm/configs/tct_hammer_defconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/configs/tct_hammer_defconfig
> b/arch/arm/configs/tct_hammer_defconfig
> index 1d24f84..71277a1 100644
> --- a/arch/arm/configs/tct_hammer_defconfig
> +++ b/arch/arm/configs/tct_hammer_defconfig
> @@ -7,7 +7,7 @@ CONFIG_SYSFS_DEPRECATED_V2=y
>  CONFIG_BLK_DEV_INITRD=y
>  CONFIG_EXPERT=y
>  # CONFIG_KALLSYMS is not set
> -# CONFIG_BUG is not set
> +# CONFIG_BUGVERBOSE is not set
>  # CONFIG_ELF_CORE is not set
>  # CONFIG_SHMEM is not set
>  CONFIG_SLOB=y
> --
> 1.7.10

