Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab2DBFou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 01:44:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952Ab2DBFot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 01:44:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1333312727-11428-3-git-send-email-paul.gortmaker@windriver.com>
References: <1333312727-11428-3-git-send-email-paul.gortmaker@windriver.com> <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH 02/11] ARM: mach-msm: fix compile fail from system.h fallout
Date: Mon, 02 Apr 2012 06:44:43 +0100
Message-ID: <29887.1333345483@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> To fix:
> 
>   In file included from arm/boot/compressed/misc.c:28:0:
>   arm/mach-msm/include/mach/uncompress.h: In function 'putc':
>   arch/arm/mach-msm/include/mach/uncompress.h:48:3: error: implicit
>   declaration of function 'smp_mb' [-Werror=implicit-function-declaration]
> 
> The putc does a cpu_relax which for this platform is smp_mb.
> 
> Bisect indicates the 1st failing commit as:
> 
>     commit 0195c00244dc2e9f522475868fa278c473ba7339
>     "Merge tag 'split-asm_system_h-for-linus-20120328' ..."
> 
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: David Howells <dhowells@redhat.com>
