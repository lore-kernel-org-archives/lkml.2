Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab1IBXu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 19:50:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751459Ab1IBXu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 19:50:56 -0400
Date: Fri, 2 Sep 2011 16:50:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bob Pearson <rpearson@systemfabricworks.com>
Cc: linux-kernel@vger.kernel.org, fzago@systemfabricworks.com,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        George Spelvin <linux@horizon.com>
Subject: Re: [PATCH v6 05/10] crc32-misc-cleanup.diff
Message-Id: <20110902165047.6aaec238.akpm@linux-foundation.org>
In-Reply-To: <4E5EB5F4.6010105@systemfabricworks.com>
References: <20110831213729.395283830@systemfabricworks.com>
	<4E5EB5F4.6010105@systemfabricworks.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Aug 2011 17:30:12 -0500
Bob Pearson <rpearson@systemfabricworks.com> wrote:

> Misc cleanup of lib/crc32.c and related files
> 	- removed unnecessary header files.
> 	- straightened out some convoluted ifdef's
> 	- rewrote some references to 2 dimensional arrays as 1 dimensional
> 	  arrays to make them correct. I.e. replaced tab[i] with tab[0][i].
> 	- a few trivial whitespace changes
> 	- fixed a warning in gen_crc32tables.c caused by a mismatch in the
> 	  type of the pointer passed to output table. Since the table is
> 	  only used at kernel compile time, it is simpler to make the table
> 	  big enough to hold the largest column size used. One cannot make the
> 	  column size smaller in output_table because it has to be used by
> 	  both the le and be tables and they can have different column sizes.
>
> ...
>
> --- for-next.orig/lib/crc32.c
> +++ for-next/lib/crc32.c
> @@ -23,13 +23,10 @@
>  /* see: Documentation/crc32.txt for a description of algorithms */
>  
>  #include <linux/crc32.h>
> -#include <linux/kernel.h>
>  #include <linux/module.h>
> -#include <linux/compiler.h>
>  #include <linux/types.h>
> -#include <linux/init.h>
> -#include <asm/atomic.h>
>  #include "crc32defs.h"

I don't like this bit much.  Surely there's _something_ in here which
needs kernel.h, and crc32_init() is marked __init so init.h is
certainly needed.

Sure, these these things may be accidentally dragged in via nested
includes but it's bad to depend upon that - such things regularly cause
breakage when configs are changed.


