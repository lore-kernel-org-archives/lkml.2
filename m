Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab2DBFqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 01:46:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183Ab2DBFp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 01:45:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1333312727-11428-2-git-send-email-paul.gortmaker@windriver.com>
References: <1333312727-11428-2-git-send-email-paul.gortmaker@windriver.com> <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH 01/11] irq_work: fix compile failure on MIPS from system.h split
Date: Mon, 02 Apr 2012 06:45:51 +0100
Message-ID: <29947.1333345551@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> Builds of the MIPS platform ip32_defconfig fails as of
> commit 0195c00244dc2e9f522475868fa278c473ba7339
> 
>     "Merge tag 'split-asm_system_h-for-linus-20120328' ..."
> 
> because MIPS xchg() macro uses BUILD_BUG_ON and it was moved
> in commit b81947c646bfefdf98e2fde5d7d39cbbda8525d4
> 
>     "Disintegrate asm/system.h for MIPS"
> 
> The root cause is that the system.h split wasn't tested on
> a baseline with commit 6c03438edeb5c359af35f060ea016ca65671c269
> 
>     "kernel.h: doesn't explicitly use bug.h, so don't include it."
> 
> Since this file uses BUG code in several other places besides
> the xchg call, simply make the inclusion explicit.
> 
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: David Howells <dhowells@redhat.com>
