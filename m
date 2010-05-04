Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666Ab0EDUOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:14:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933608Ab0EDUOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:14:10 -0400
Date: Tue, 4 May 2010 13:13:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org, mjt@tls.msk.ru,
       stable@kernel.org
Subject: Re: [PATCH 0/2] aio: fix the vectored aio routines
Message-Id: <20100504131353.adf8c186.akpm@linux-foundation.org>
In-Reply-To: <1272660540-6567-1-git-send-email-jmoyer@redhat.com>
References: <1272660540-6567-1-git-send-email-jmoyer@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Apr 2010 16:48:58 -0400
Jeff Moyer <jmoyer@redhat.com> wrote:

> Hi,
> 
> It was reported[1] that 32 bit readv and writev AIO operations were
> not functioning properly.  It turns out that the code to convert the
> 32bit io vectors to 64 bits was never written.  The results of that
> can be pretty bad, but in my testing, it mostly ended up in generating
> EFAULT as we walked off the list of I/O vectors provided.
> 
> This patch set fixes the problem in my environment.  Comments, as always,
> are greatly appreciated.
> 
> Cheers,
> Jeff
> 
> [1] http://lkml.org/lkml/2010/3/8/309
> 
> [PATCH 1/2] compat: factor out compat_rw_copy_check_uvector from compat_do_readv_writev
> [PATCH 2/2] aio: fix the compat vectored operations

The patches are large(ish) and we're at -rc6.  I'm inclined to merge
these into 2.6.35-rc1 with a -stable tag so they get backported into 2.6.34.1
after a bit of mainline testing, OK?

