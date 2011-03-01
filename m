Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab1CAAtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 19:49:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753543Ab1CAAtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 19:49:16 -0500
Date: Mon, 28 Feb 2011 16:48:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
Message-Id: <20110228164843.6c5b71ba.akpm@linux-foundation.org>
In-Reply-To: <4D671667.4000602@suse.com>
References: <4D671667.4000602@suse.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011 21:39:35 -0500
Jeff Mahoney <jeffm@suse.com> wrote:

>  Every kernel package trying to provide files under /lib/firmware runs
>  into problems really quickly with multiple kernels installed.
> 
>  This patch moves them to /lib/firmware/$KERNELRELEASE. udev v127's
>  firmware.sh looks there first before falling back to /lib/firmware.
> 
> ...
>
> --- a/Makefile
> +++ b/Makefile
> @@ -975,7 +975,7 @@ depend dep:
>  
>  # ---------------------------------------------------------------------------
>  # Firmware install
> -INSTALL_FW_PATH=$(INSTALL_MOD_PATH)/lib/firmware
> +INSTALL_FW_PATH=$(INSTALL_MOD_PATH)/lib/firmware/$(KERNELRELEASE)
>  export INSTALL_FW_PATH
>  
>  PHONY += firmware_install

What happens if the user is running older udev?
