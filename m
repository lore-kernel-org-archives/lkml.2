Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab2CWUx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 16:53:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41214 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab2CWUx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 16:53:57 -0400
Date: Fri, 23 Mar 2012 13:53:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] swapon: check validity of swap_flags
Message-Id: <20120323135356.6b2376d6.akpm@linux-foundation.org>
In-Reply-To: <alpine.LSU.2.00.1203231346500.1940@eggly.anvils>
References: <alpine.LSU.2.00.1203231346500.1940@eggly.anvils>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2012 13:48:35 -0700 (PDT)
Hugh Dickins <hughd@google.com> wrote:

> Most system calls taking flags first check that the flags passed in are
> valid, and that helps userspace to detect when new flags are supported.
> 
> But swapon never did so: start checking now, to help if we ever want to
> support more swap_flags in future.
> 
> It's difficult to get stray bits set in an int, and swapon is not widely
> used, so this is most unlikely to break any userspace; but we can just
> revert if it turns out to do so.

It would be safer to emit a nasty message then let the swapon proceed
as before.

