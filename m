Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab2JOMOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 08:14:36 -0400
Received: from smtp-out-102.synserver.de ([212.40.185.102]:1030 "EHLO
	smtp-out-102.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab2JOMOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 08:14:35 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 16195
Message-ID: <507BFE70.9020601@metafoo.de>
Date: Mon, 15 Oct 2012 14:15:44 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        uclinux-dev@uclinux.org
Subject: Re: [PATCH 4/4] FRV: Fix linux/elf-fdpic.h
References: <20121015114343.1042.81528.stgit@warthog.procyon.org.uk> <20121015114404.1042.75225.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121015114404.1042.75225.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2012 01:44 PM, David Howells wrote:
> It seems I accidentally switched the guard on linux/elf-fdpic.h from #ifdef
> __KERNEL__ to #ifndef __KERNEL__ when attempting to expand the guarded region
> to cover the elf_fdpic_params struct when doing the UAPI split - with the
> result that the struct became unavailable to kernel code.
> 
> Move incorrectly guarded bits back to the kernelspace header.
> 
> Whilst we're at it, the __KERNEL__ guards can be deleted as they're no longer
> necessary.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Reported-by: Lars-Peter Clausen <lars@metafoo.de>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Fengguang Wu <fengguang.wu@intel.com>
> cc: Lars-Peter Clausen <lars@metafoo.de>
> cc: uclinux-dev@uclinux.org
> ---
> 
>  include/uapi/linux/elf-fdpic.h |   42 +++-------------------------------------

>  1 file changed, 3 insertions(+), 39 deletions(-)

The second part of the patch adding it back to include/linux/elf-fdpic.h
seems to be missing.


Thanks,
- Lars
