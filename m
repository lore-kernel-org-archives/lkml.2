Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab2DSXhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 19:37:21 -0400
Received: from na3sys010aog112.obsmtp.com ([74.125.245.92]:49057 "HELO
	na3sys010aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753314Ab2DSXhT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 19:37:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120419114811.9e77accb.akpm@linux-foundation.org>
References: <1334859173-9446-1-git-send-email-roland@kernel.org> <20120419114811.9e77accb.akpm@linux-foundation.org>
From: Roland Dreier <roland@kernel.org>
Date: Thu, 19 Apr 2012 16:36:56 -0700
X-Google-Sender-Auth: aYl04qIAH0IgfmOwm-X8Sesk6ws
Message-ID: <CAL1RGDXQ9NPKaNxBcNAYKknpSSScwXVa+gr8jXOFFU4ZjjSJ=A@mail.gmail.com>
Subject: Re: [PATCH] dma-debug: Fix deadlock with netconsole or other drivers
 that use the DMA API
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 11:48 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> So *any* printk can deadlock if free_entries_lock is held and
> global_disable==false?

apparently.

> In that case we're going to need much sterner fixes.  Any list_head
> operation can do a printk if list_head debugging is enabled.
> dma_debug_resize_entries() does a kfree() under free_entries_lock(!).
>
> Methinks we need a more general fix?

sigh... no good deed goes unpunished.

OK, will look at it.  Just to make things even more fun, all the
err_printk() stuff can potentially deadlock on the hash bucket
lock, although that requires enough bad luck a collision to happen.

 - R.
