Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab0JVCOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 22:14:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751311Ab0JVCOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 22:14:46 -0400
Date: Thu, 21 Oct 2010 19:14:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Lameter <cl@linux.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu_counter : add percpu_counter_add_fast()
Message-Id: <20101021191425.b94b0942.akpm@linux-foundation.org>
In-Reply-To: <20101022015845.GA6265@amd>
References: <20100930061039.GX5665@dastard>
	<20101016075510.GH19147@amd>
	<1287217748.2799.68.camel@edumazet-laptop>
	<20101016020744.366bd9c6.akpm@linux-foundation.org>
	<1287221475.2799.123.camel@edumazet-laptop>
	<1287238754.2799.376.camel@edumazet-laptop>
	<20101021153719.c8bde251.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1010211807280.3431@router.home>
	<20101021174536.26213ab7.akpm@linux-foundation.org>
	<20101021185516.be13a83f.akpm@linux-foundation.org>
	<20101022015845.GA6265@amd>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010 12:58:45 +1100 Nick Piggin <npiggin@kernel.dk> wrote:

> > But what's really alarming is that the compiler (4.0.2) is cheerily
> > ignoring the inline directives and was generating out-of-line versions
> > of most of the percpu_counter.h functions into lib/proportions.s. 
> > That's rather a worry.
> 
> You you have the "ignore inlining"

# CONFIG_OPTIMIZE_INLINING is not set

> and "compile for size" turned on?

CONFIG_CC_OPTIMIZE_FOR_SIZE=y

> They often suck.

Everything sucks.  Are they any use?

With

# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_OPTIMIZE_INLINING=y

my kernel/built-in.o text went from 563638 bytes to 659852. 
That's rather a lot.

I haven't looked at this stuff in years.  Has anyone dug into it?
