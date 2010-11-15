Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089Ab0KOSOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 13:14:54 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:47958 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062Ab0KOSOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:14:53 -0500
Date: Mon, 15 Nov 2010 10:14:06 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86, mrst: The shutdown for MRST requires the SCU IPC
 mechanism
Message-Id: <20101115101406.77e072ef.randy.dunlap@oracle.com>
In-Reply-To: <20101115173110.6877.83958.stgit@localhost.localdomain>
References: <20101115173110.6877.83958.stgit@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010 17:31:19 +0000 Alan Cox wrote:

> From: Alan Cox <alan@linux.intel.com>
> 
> Fix the build failure reported by Randy Dunlap
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  arch/x86/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 9e71608..afe50ec 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -387,6 +387,7 @@ config X86_MRST
>  	select APB_TIMER
>  	select I2C
>  	select SPI
> +	select INTEL_SCU_IPC
>  	---help---
>  	  Moorestown is Intel's Low Power Intel Architecture (LPIA) based Moblin
>  	  Internet Device(MID) platform. Moorestown consists of two chips:

Hi,
Additionally using this line from my patch:

+	select X86_PLATFORM_DEVICES

will avoid this warning (with your patch applied):

warning: (X86_MRST && PCI && PCI_GOANY && X86_32 && X86_EXTENDED_PLATFORM && X86_IO_APIC) selects INTEL_SCU_IPC which has unmet direct dependencies 
(X86 && X86_PLATFORM_DEVICES && X86_MRST)

which is due to the hierarchical menu structure.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
