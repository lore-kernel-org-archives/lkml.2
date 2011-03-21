Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab1CUXBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:01:08 -0400
Received: from tundra.namei.org ([65.99.196.166]:32776 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754506Ab1CUXBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:01:05 -0400
Date: Tue, 22 Mar 2011 10:01:00 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Peter Huewe <huewe.external.infineon@googlemail.com>
Subject: Re: [GIT PULL] TPM driver robustness fixes
In-Reply-To: <4D81708D.5090607@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.1103220956350.14837@tundra.namei.org>
References: <4D81708D.5090607@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Mar 2011, Rajiv Andrade wrote:

> Hi James,
> 
> 
> The following changes since commit 2e270d84223262a38d4755c61d55f5c73ea89e56:
> 
>   Merge branch 'for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6 (2011-03-16
> 13:26:17 -0700)
> 
> are available in the git repository at:
> 
>   git://tpmdd.git.sourceforge.net/gitroot/tpmdd/tpmdd/ for-james
> 
> Peter Huewe (3):
> 
>       This patch changes the call of tpm_transmit by supplying the size of the
> userspace buffer instead of TPM_BUFSIZE
> 
>       This patch fixes information leakage to the userspace by initializing
> the data buffer to zero
> 
>       Since the buffer might contain security related data it might be a good
> idea to zero the buffer after we have copied it to userspace.

These patches don't have proper subjects.

Also:

                if (copy_to_user(buf, chip->data_buffer, ret_size))
                        ret_size = -EFAULT;
+               memset(chip->data_buffer, 0, ret_size);


Consider what happens in memset if copy_to_user fails.

One of the patches is flagged with "Discussion needed ...", without any 
evidence of that the discussion happened.



- James
-- 
James Morris
<jmorris@namei.org>
