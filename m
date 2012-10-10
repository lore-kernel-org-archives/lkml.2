Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab2JJQd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 12:33:58 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:54649 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755488Ab2JJQdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 12:33:55 -0400
Date: Wed, 10 Oct 2012 11:33:24 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Subject: Re: [PATCH] TPM: Let the tpm char device be openable multiple times
Message-ID: <20121010163324.GB5013@ennui.austin.ibm.com>
References: <20120930233345.GJ30637@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120930233345.GJ30637@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12101016-9360-0000-0000-00000B93BA43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2012 at 05:33:45PM -0600, Jason Gunthorpe wrote:
> How to use the TPM is really a user space policy choice, if the
> environment wants to use middleware then fine, but it is possible to
> make correct TPM apps without using middleware.

  I'm not sure how I feel about this. The single open rule doesn't
prevent replacement of the middleware, it just requires a open()/close()
around any use of the device node. That seems simple enough to me. In
places where you do want TSS to be the sole opener, it can't enforce
that rule itself, so I think we need to preserve the option of a single
open at a minimum.

Kent

> So, remove the kernel restriction that only one process may open the TPM.
> - TPM low level functions (in kernel users) are already locked proprely
>   and can run in parallel with the user space interface anyhow.
> - Move the user space data buffer and related goop into a
>   struct tpm_file, create one struct tpm_file per open file.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> ---
>  drivers/char/tpm/tpm.c |   97 +++++++++++++++++++++---------------------------
>  drivers/char/tpm/tpm.h |   23 ++++++-----
>  2 files changed, 55 insertions(+), 65 deletions(-)
> 
> This is rebase, retest, resend of a patch I sent two years ago. The
> discussion on that earlier patch fizzled out. Resending incase there
> is renewed interest :)
> 

