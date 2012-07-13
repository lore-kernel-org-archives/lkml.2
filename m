Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934350Ab2GMBtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 21:49:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36531 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab2GMBtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 21:49:33 -0400
Date: Thu, 12 Jul 2012 22:49:27 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Hugh Dickins <hugh@veritas.com>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Badari Pulavarty <pbadari@us.ibm.com>, Nick Piggin <npiggin@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [ 66/68] mm: Hold a file reference in madvise_remove
Message-ID: <20120713014927.GD3121@herton-Z68MA-D2H-B3>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
 <20120712175041.247517998@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120712175041.247517998@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 04:02:40PM -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
> 
> 3.0-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Andy Lutomirski <luto@amacapital.net>
> 
> commit 9ab4233dd08036fe34a89c7dc6f47a8bf2eb29eb upstream.
> 
> Otherwise the code races with munmap (causing a use-after-free
> of the vma) or with close (causing a use-after-free of the struct
> file).
> 
> The bug was introduced by commit 90ed52ebe481 ("[PATCH] holepunch: fix
> mmap_sem i_mutex deadlock")
> 
> [bwh: Backported to 3.2:
>  - Adjust context
>  - madvise_remove() calls vmtruncate_range(), not do_fallocate()]
> [luto: Backported to 3.0: Adjust context]

Didn't want to be annoying, but as I went looking sequentially,
I found missing diffs one by one... anyway this should be the last.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
[]'s
Herton
