Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933296Ab1CYMAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 08:00:42 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:30381 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab1CYMAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 08:00:38 -0400
Message-ID: <4D8C83D1.2060902@snapgear.com>
Date: Fri, 25 Mar 2011 22:00:17 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: <linux-m68k@vger.kernel.org>, <uclinux-dev@uclinux.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/1] m68k: merge m68k and m68knommu arch directories
References: <1300768985-902-1-git-send-email-gerg@snapgear.com>
In-Reply-To: <1300768985-902-1-git-send-email-gerg@snapgear.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I am ready to send a request to Linus to pull this in.
Anyone not ready for this to happen?

Regards
Greg


On 22/03/11 14:43, gerg@snapgear.com wrote:
> The following patch merges the m68k and m68knommu arch directories.
> This patch has been trimmed for review purposes - the automated file
> moving and mergeing carried out by the script contained in this email
> has been removed. Only the manually required changes after running the
> script are shown as the patch. (So to end up with the final required
> change you need to run this script then apply the patch).
>
> This change is available as the only commit on the m68knommu git tree,
> for-linux branch:
>
> The following changes since commit a952baa034ae7c2e4a66932005cbc7ebbccfe28d:
>    Linus Torvalds (1):
>          Merge branch 'for-linus' of git://git.kernel.org/.../dtor/input
>
> are available in the git repository at:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus
>
> Greg Ungerer (1):
>        m68k: merge m68k and m68knommu arch directories
>
>
> It is also on the for-next branch in that tree, so will get some testing
> in the next tree for the next few days.
>
> I have done some testing on both MMU and non-MMU targets, and they
> worked fine. I tried a few ColdFire non-MMU builds, and I built and
> ran the Atari target in the AranyM emulator. Other than some option
> re-ordering the configs produced are the same.
>
> If everyone is happy I would like to ask Linus to pull this before the
> end of the current merge window.
>
> Regards
> Greg
>
>
> -----
>
> #!/bin/bash
>
> mergefile() {
> 	BASE=${1%.?}
> 	EXT=${1#${BASE}}
> 	git mv ${TARGET}/$1 ${TARGET}/${BASE}_mm${EXT}
> 	git mv ${SOURCE}/$1 ${TARGET}/${BASE}_no${EXT}
> 	cat<<-EOF>  ${TARGET}/$1
> 	#ifdef CONFIG_MMU
> 	#include "${BASE}_mm${EXT}"
> 	#else
> 	#include "${BASE}_no${EXT}"
> 	#endif
> 	EOF
> 	git add ${TARGET}/$1
> }
>
> mergedir() {
> 	TARGET=arch/m68k/$1
> 	SOURCE=arch/m68knommu/$1
> 	files=${1}_MERGE_FILES
> 	MERGE_FILES=${!files}
>
> 	echo "merging files in $1"
> 	for F in $MERGE_FILES ; do
> 		mergefile $F
> 	done
>
> 	files=${1}_NOMERGE_FILES
> 	NOMERGE_FILES=${!files}
>
> 	echo "moving files in $1"
> 	for F in $NOMERGE_FILES ; do
> 		git mv ${SOURCE}/$F ${TARGET}/$F
> 	done
>
> 	files=${1}_REMOVE_FILES
> 	REMOVE_FILES=${!files}
>
> 	echo "removing common files in $1"
> 	for F in $REMOVE_FILES ; do
> 		git rm ${SOURCE}/$F
> 	done
>
> 	if [ -e ${SOURCE}/Makefile ]; then
> 		git mv ${TARGET}/Makefile ${TARGET}/Makefile_mm
> 		git mv ${SOURCE}/Makefile ${TARGET}/Makefile_no
> 		cat<<-EOF>  ${TARGET}/Makefile
> 		ifdef CONFIG_MMU
> 		include ${TARGET}/Makefile_mm
> 		else
> 		include ${TARGET}/Makefile_no
> 		endif
> 		EOF
> 		git add ${TARGET}/Makefile
> 	fi
> }
>
> configs_MERGE_FILES=""
> configs_NOMERGE_FILES="m5208evb_defconfig \
> 			m5272c3_defconfig \
> 			m5307c3_defconfig \
> 			m5249evb_defconfig \
> 			m5275evb_defconfig \
> 			m5407c3_defconfig"
> configs_REMOVE_FILES=""
> kernel_MERGE_FILES="asm-offsets.c \
> 			dma.c entry.S \
> 			m68k_ksyms.c \
> 			module.c \
> 			process.c \
> 			ptrace.c \
> 			setup.c \
> 			signal.c \
> 			sys_m68k.c \
> 			time.c \
> 			traps.c \
> 			vmlinux.lds.S"
> kernel_NOMERGE_FILES="init_task.c \
> 			irq.c \
> 			syscalltable.S"
> kernel_REMOVE_FILES=""
> lib_MERGE_FILES="checksum.c \
> 			muldi3.c"
> lib_NOMERGE_FILES="delay.c \
> 			divsi3.S \
> 			memcpy.c \
> 			memmove.c \
> 			memset.c \
> 			modsi3.S \
> 			mulsi3.S \
> 			udivsi3.S \
> 			umodsi3.S"
> lib_REMOVE_FILES="ashldi3.c \
> 			ashrdi3.c \
> 			lshrdi3.c"
> mm_MERGE_FILES="init.c kmap.c"
> mm_NOMERGE_FILES=""
> mm_REMOVE_FILES=""
>
> DIRS="configs kernel lib mm"
>
> echo "STARTing merge"
> for dir in $DIRS ; do
> 	echo "merging $dir..."
> 	mergedir $dir
> done
> echo "moving platform"
> git mv arch/m68knommu/platform arch/m68k/
> git rm arch/m68knommu/defconfig
>
> echo "merging master Makefile"
> git mv arch/m68k/Makefile arch/m68k/Makefile_mm
> git mv arch/m68knommu/Makefile arch/m68k/Makefile_no
> cat<<-EOF>  arch/m68k/Makefile
> ifdef CONFIG_MMU
> include arch/m68k/Makefile_mm
> else
> include arch/m68k/Makefile_no
> endif
> EOF
> git add arch/m68k/Makefile
>
> echo "removing remaining m68knommu dirs"
> git rm -r arch/m68knommu
> rm -r arch/m68knommu
> exit 0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-m68k" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
