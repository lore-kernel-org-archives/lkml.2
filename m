Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514Ab1EZUfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:35:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab1EZUfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:35:22 -0400
Date: Thu, 26 May 2011 16:35:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Dan Rosenberg <rosenberg@vsecurity.com>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, penberg@kernel.org,
        hpa@zytor.com, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        Ingo Molnar <mingo@elte.hu>, pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110526203502.GK29496@redhat.com>
References: <1306269105.21443.20.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306269105.21443.20.camel@dan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 04:31:45PM -0400, Dan Rosenberg wrote:
> This introduces CONFIG_RANDOMIZE_BASE, which randomizes the address at
> which the kernel is decompressed at boot as a security feature that
> deters exploit attempts relying on knowledge of the location of kernel
> internals.  The default values of the kptr_restrict and dmesg_restrict
> sysctls are set to (1) when this is enabled, since hiding kernel
> pointers is necessary to preserve the secrecy of the randomized base
> address.

What happens to /proc/iomem interface which gives us the physical memory
location where kernel is loaded. kexec-tools relies on that interface
heavily so we can not take it away. And if we can not take it away then
I think somebody should be easibly be able to calculate this randomized
base address.

Thanks
Vivek
