Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab2G0HET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 03:04:19 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:55595 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab2G0HES convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:1>);
	Fri, 27 Jul 2012 03:04:18 -0400
Message-Id: <5012598C0200007800090DB9@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 27 Jul 2012 08:04:12 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        <linux-kernel@vger.kernel.org>
Cc: <catalin.marinas@arm.com>, <arnd@arndb.de>, <Ian.Campbell@citrix.com>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <tim@xen.org>
Subject: Re: [Xen-devel] [PATCH 17/24] xen: allow privcmd for HVM
 guests
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
 <1343316846-25860-17-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1343316846-25860-17-git-send-email-stefano.stabellini@eu.citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 26.07.12 at 17:33, Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> In order for privcmd mmap to work correctly, xen_remap_domain_mfn_range
> needs to be implemented for HVM guests.
> If it is not, mmap is going to fail later on.

Somehow, for me at least, this description doesn't connect to the
actual change.

> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  drivers/xen/privcmd.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
> index ccee0f1..85226cb 100644
> --- a/drivers/xen/privcmd.c
> +++ b/drivers/xen/privcmd.c
> @@ -380,10 +380,6 @@ static struct vm_operations_struct privcmd_vm_ops = {
>  
>  static int privcmd_mmap(struct file *file, struct vm_area_struct *vma)
>  {
> -	/* Unsupported for auto-translate guests. */
> -	if (xen_feature(XENFEAT_auto_translated_physmap))
> -		return -ENOSYS;
> -

Is this safe on x86?

Jan

>  	/* DONTCOPY is essential for Xen because copy_page_range doesn't know
>  	 * how to recreate these mappings */
>  	vma->vm_flags |= VM_RESERVED | VM_IO | VM_DONTCOPY | VM_PFNMAP;


