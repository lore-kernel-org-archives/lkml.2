Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab1KWUbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 15:31:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab1KWUbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 15:31:51 -0500
Date: Wed, 23 Nov 2011 12:31:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8] readahead: replace ra->mmap_miss with ra->ra_flags
Message-Id: <20111123123150.8a1ac462.akpm@linux-foundation.org>
In-Reply-To: <20111123124745.GB7174@localhost>
References: <20111121091819.394895091@intel.com>
	<20111121093846.378529145@intel.com>
	<20111121150116.094cf194.akpm@linux-foundation.org>
	<20111123124745.GB7174@localhost>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011 20:47:45 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> > should be ulong, which is compatible with the bitops.h code.
> > Or perhaps we should use a bitfield and let the compiler do the work.
> 
> What if we do
> 
>         u16     mmap_miss;
>         u16     ra_flags;
> 
> That would get rid of this patch. I'd still like to pack the various
> flags as well as pattern into one single ra_flags, which makes it
> convenient to pass things around (as one single parameter).

I'm not sure that this will improve things much...

Again, how does the code look if you use a bitfield and let the
compiler do the worK?
