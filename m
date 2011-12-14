Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215Ab1LNVQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 16:16:58 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58934 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab1LNVQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 16:16:54 -0500
Date: Wed, 14 Dec 2011 21:16:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: t cheney <cdmalord@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Add process memory layout to coredump file
Message-ID: <20111214211652.GO2203@ZenIV.linux.org.uk>
References: <CAE04G=Bu4WnU9SYU9u3-ap6OrBEjWONK8TA8bYBy5OSCCzzDqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE04G=Bu4WnU9SYU9u3-ap6OrBEjWONK8TA8bYBy5OSCCzzDqg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 10, 2011 at 10:37:02PM +0800, t cheney wrote:
> This patch just add memory layout(same as /proc/pid/maps) to
> coredump file. The layout is appended to corenote segment with
> flag NT_MAPS=7.
 
> +		len = sprintf(buf, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu",
> +			start,
> +			end,
> +			flags & VM_READ ? 'r' : '-',
> +			flags & VM_WRITE ? 'w' : '-',
> +			flags & VM_EXEC ? 'x' : '-',
> +			flags & VM_MAYSHARE ? 's' : 'p',
> +			pgoff,
> +			MAJOR(dev), MINOR(dev), ino);

Device numbers may be wider than 16 bits.

> +			p = d_path(&vma->vm_file->f_path, s, maps_size-1);

What if somebody renames the file (or, better yet, its parent directory)
between two calls of that thing?
