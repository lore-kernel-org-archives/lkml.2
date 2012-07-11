Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946Ab2GKQHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 12:07:20 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:17575 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824Ab2GKQHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 12:07:17 -0400
Message-ID: <4FFDA4B5.9060005@tilera.com>
Date: Wed, 11 Jul 2012 12:07:17 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <davem@davemloft.net>, <chris@zankel.net>, <catalin.marinas@arm.com>,
        <arnd@arndb.de>, <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] ipc: allow compat IPC version field parsing if !ARCH_WANT_OLD_COMPAT_IPC
References: <1342020741-12758-1-git-send-email-will.deacon@arm.com> <1342020741-12758-3-git-send-email-will.deacon@arm.com>
In-Reply-To: <1342020741-12758-3-git-send-email-will.deacon@arm.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/11/2012 11:32 AM, Will Deacon wrote:
> Commit 48b25c43 ("[PATCH v3] ipc: provide generic compat versions of IPC
> syscalls") added a new ARCH_WANT_OLD_COMPAT_IPC config option for
> architectures to select if their compat target requires the old IPC
> syscall interface.
>
> For architectures (such as AArch64) that do not require the internal
> calling conventions provided by this option, but have a compat target
> where the C library passes the IPC_64 flag explicitly,
> compat_ipc_parse_version no longer strips out the flag before calling
> the native system call implementation, resulting in unknown SHM/IPC
> commands and -EINVAL being returned to userspace.
>
> This patch separates the selection of the internal calling conventions
> for the IPC syscalls from the version parsing, allowing architectures to
> select __ARCH_WANT_COMPAT_IPC_PARSE_VERSION if they want to use version
> parsing whilst retaining the newer syscall calling conventions.
>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  include/linux/compat.h |    1 +
>  ipc/compat.c           |    2 +-
>  2 files changed, 2 insertions(+), 1 deletions(-)
>

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com



