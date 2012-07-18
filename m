Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab2GRL6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 07:58:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60299 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab2GRL6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 07:58:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] Revert "KVM: Export asm-generic/kvm_para.h"
Date: Wed, 18 Jul 2012 11:58:06 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <1342607393-32254-1-git-send-email-will.deacon@arm.com>
In-Reply-To: <1342607393-32254-1-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207181158.07236.arnd@arndb.de>
X-Provags-ID: V02:K0:S3v5n7hAWOsSnbfHcxl4QlxhYdkU7WF2hQO46aANmgk
 ZIanygYcBoTWIGm+8Ff9YZQtvFg88VzmzlVB8zFkOytNiQxksy
 rrS/oYoIjcOOqao70FDM+nql2crlAI+CiEVTfjzl35nJlNJS5/
 1p8trfG+QgioywZkq1hAZM4v08hQ2aXLu8S2jNcpnCAKfJGY2S
 pqVKxQ/itofVSkmMngivXhcKyRjNODxKaHb3Hk8laB/9ohSJkA
 TI6fWmJl4etYPaC015/6u3tGmOPJXKJt8579yTAepSAW4Phv5P
 LkSqzQp7inPrJ6+lbHBaD1gWbdtTj8wLtqTBxKOBBg0wE4zA8p
 jLFy+BWdGI7pf2fIQY20=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 July 2012, Will Deacon wrote:
> This reverts commit 56457f38f212344fb38b250cfa7e7311c065022f.
> 
> For architectures without asm/kvm_para.h, asm-generic/Kbuild
> unconditionally tries to export the non-existent header file, resulting
> in failure to build the user headers. Since the logic in
> asm-generic/Kbuild.asm will only export the file if it exists (which in
> turn causes linux/kvm_para.h to be exported), we can just remove the
> unconditional header export.

This doesn't look right.

> I'm not sure what specific problem the original commit was fixing, so we
> may need to solve this another way if there's something I've missed.
> 
>  include/asm-generic/Kbuild |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
> index 2c85a0f..53f91b1 100644
> --- a/include/asm-generic/Kbuild
> +++ b/include/asm-generic/Kbuild
> @@ -8,7 +8,6 @@ header-y += int-ll64.h
>  header-y += ioctl.h
>  header-y += ioctls.h
>  header-y += ipcbuf.h
> -header-y += kvm_para.h
>  header-y += mman-common.h
>  header-y += mman.h
>  header-y += msgbuf.h

include/asm-generic/Kbuild lists the header files in the asm-generic
directory, and the asm-generic/kvm_para.h always exists, it's
not architecture specific.

arch/arm/include/asm/kvm_para.h also always exists, it was added
in 3b5d56b93 "kvmclock: Add functions to check if the host has
stopped the vm", although it should have added that to the generated
header files listed in arch/arm/include/asm/Kbuild.

I'm still not sure what you are actually trying to fix here.

	Arnd
