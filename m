Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab2BMPDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 10:03:35 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:35157 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756786Ab2BMPDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 10:03:33 -0500
X-Sasl-enc: zOtcR0253F6cRnyKhTpAEAPNOjqkS2iro57+OBdQUm1+ 1329145412
Date: Mon, 13 Feb 2012 07:03:09 -0800
From: Greg KH <greg@kroah.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>
Subject: Re: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-ID: <20120213150309.GA10009@kroah.com>
References: <20120213171949.262e0c12e8d8883e90216df1@canb.auug.org.au>
 <20120213064508.GD28617@kroah.com>
 <4F3922A5.5030502@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3922A5.5030502@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 08:48:05AM -0600, Seth Jennings wrote:
> On 02/13/2012 12:45 AM, Greg KH wrote:
> > On Mon, Feb 13, 2012 at 05:19:49PM +1100, Stephen Rothwell wrote:
> >> Hi ,
> >>
> >> After merging the final tree, today's linux-next build (powerpc allyesconfig)
> >> failed like this:
> >>
> >> drivers/staging/zsmalloc/zsmalloc-main.c: In function 'zs_cpu_notifier':
> >> drivers/staging/zsmalloc/zsmalloc-main.c:451:3: error: implicit declaration of function 'alloc_vm_area' [-Werror=implicit-function-declaration]
> >> drivers/staging/zsmalloc/zsmalloc-main.c:451:12: warning: assignment makes pointer from integer without a cast [enabled by default]
> >> drivers/staging/zsmalloc/zsmalloc-main.c:459:4: error: implicit declaration of function 'free_vm_area' [-Werror=implicit-function-declaration]
> >> drivers/staging/zsmalloc/zsmalloc-main.c: In function 'zs_map_object':
> >> drivers/staging/zsmalloc/zsmalloc-main.c:705:3: error: implicit declaration of function 'set_pte' [-Werror=implicit-function-declaration]
> >> drivers/staging/zsmalloc/zsmalloc-main.c:709:27: error: dereferencing pointer to incomplete type
> >> drivers/staging/zsmalloc/zsmalloc-main.c: In function 'zs_unmap_object':
> >> drivers/staging/zsmalloc/zsmalloc-main.c:739:3: error: implicit declaration of function '__flush_tlb_one' [-Werror=implicit-function-declaration]
> >>
> >> Caused by commit 61989a80fb3a ("staging: zsmalloc: zsmalloc memory
> >> allocation library").  This needs to include linux/vmalloc.h at least.  I
> >> couldn't find set_pte at all or __flush_tlb_one for powerpc.
> >>
> >> This was too hard to revert, so I have left powerpc allyesconfig broken
> >> for today.  I may revert it (and some dependent commits) tomorrow.
> > 
> > Nitin, please send me a patch to fix this as soon as possible.
> 
> Sending a patch now.  Adds linux/vmalloc.h to zsmalloc-main.c. On a less ideal
> note, it also adds an X86 dependency since set_pte and __flush_tlb_one are
> x86 only.  I'm working to find portable replacements for these functions.

Thanks for the patch, I'll queue it up.

greg k-h
