Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402Ab1C3Wlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:41:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62631 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab1C3Wli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:41:38 -0400
Date: Wed, 30 Mar 2011 15:41:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: MTD list <linux-mtd@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] UBIFS: do not select KALLSYMS_ALL
Message-Id: <20110330154130.e62e04e0.randy.dunlap@oracle.com>
In-Reply-To: <1301474416-8202-2-git-send-email-dedekind1@gmail.com>
References: <1301474416-8202-1-git-send-email-dedekind1@gmail.com>
	<1301474416-8202-2-git-send-email-dedekind1@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D93B19C.0163:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011 11:40:15 +0300 Artem Bityutskiy wrote:

> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> All UBIFS needs is to make sure we stacktraces when UBIFS debugging
> is enabled. It is enough to select KALLSYMS for this, KALLSYMS_ALL
> is not necessary. Moreover, Randy Dunlap reported that UBIFS causes
> the following Kconfig dependency warning:
> 
> warning: (UBIFS_FS_DEBUG && LOCKDEP && LATENCYTOP) selects KALLSYMS_ALL
> which has unmet direct dependencies (DEBUG_KERNEL && KALLSYMS)
> 
> The reason is that KALLSYMS_ALL requires DEBUG_KERNEL and KALLSYMS, so
> ideally, to select KALLSYMS_ALL we'd need to select DEBUG_KERNEL and
> KALLSYMS first.
> 
> This seems to be too much to select. The easiest way to go is to forget
> about KALLSYMS_ALL and just select KALLSYMS when UBIFS debugging is
> enabled - that should be enough for stackdumps.
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> ---
>  fs/ubifs/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ubifs/Kconfig b/fs/ubifs/Kconfig
> index d744090..f8b0160 100644
> --- a/fs/ubifs/Kconfig
> +++ b/fs/ubifs/Kconfig
> @@ -47,7 +47,7 @@ config UBIFS_FS_DEBUG
>  	bool "Enable debugging support"
>  	depends on UBIFS_FS
>  	select DEBUG_FS
> -	select KALLSYMS_ALL
> +	select KALLSYMS
>  	help
>  	  This option enables UBIFS debugging support. It makes sure various
>  	  assertions, self-checks, debugging messages and test modes are compiled
> -- 

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
