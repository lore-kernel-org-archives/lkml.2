Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab0EOQlR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 12:41:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752708Ab0EOQlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 12:41:15 -0400
Date: Sat, 15 May 2010 09:39:08 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, gregkh@suse.de,
       alan@lxorguk.ukuu.org.uk, tytso@mit.edu, iws@ovro.caltech.edu
Subject: Re: [PATCH 4/4] add example files to the kernel sample directory
Message-Id: <20100515093908.54290762.akpm@linux-foundation.org>
In-Reply-To: <1273930418.32082.12.camel@wall-e.seibold.net>
References: <1273654167-31067-1-git-send-email-stefani@seibold.net>
	<1273654167-31067-5-git-send-email-stefani@seibold.net>
	<20100514134609.54e05968.akpm@linux-foundation.org>
	<1273930418.32082.12.camel@wall-e.seibold.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 May 2010 15:33:38 +0200 Stefani Seibold <stefani@seibold.net> wrote:

> Hi,
> 
> is the patch 0003-replace-the-old-non-generic-API.patch correct applied?
> 
> This patch renames the files created by patch 
> 
> 0002-add-the-new-generic-kfifo-API.patch 
> 
> from 
> kernel/kfifo-new.c into kernel/kfifo.c
> and
> include/linux/kfifo-new.h into include/linux/kfifo.h.
> 
> Both destination files still exists, so git must overwrite them.

oh, doh, no.  This stuff:

: diff --git a/include/linux/kfifo-new.h b/include/linux/kfifo.h
: similarity index 100%
: rename from include/linux/kfifo-new.h
: rename to include/linux/kfifo.h
: diff --git a/kernel/kfifo-new.c b/kernel/kfifo.c
: similarity index 100%
: rename from kernel/kfifo-new.c
: rename to kernel/kfifo.c

is git-specific and doesn't mean anything to patch(1).  I'll fix it.

> This
> was done in request by Greg, not to break the kernel build at this point
> in the patch sequence.

Well, there can be no build problem here (joining two
non-build-breaking patches will yield a non-build-breaking patch!) but
if the add-new-api and replace-old-api patches were folded into a
single patch, the diff would be quite unreadable.

