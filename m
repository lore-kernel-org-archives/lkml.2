Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab2CWVU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 17:20:59 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36746 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab2CWVU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 17:20:58 -0400
Date: Fri, 23 Mar 2012 14:20:27 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] swapon: check validity of swap_flags
In-Reply-To: <20120323135356.6b2376d6.akpm@linux-foundation.org>
Message-ID: <alpine.LSU.2.00.1203231416260.2235@eggly.anvils>
References: <alpine.LSU.2.00.1203231346500.1940@eggly.anvils> <20120323135356.6b2376d6.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2012, Andrew Morton wrote:
> On Fri, 23 Mar 2012 13:48:35 -0700 (PDT)
> Hugh Dickins <hughd@google.com> wrote:
> 
> > Most system calls taking flags first check that the flags passed in are
> > valid, and that helps userspace to detect when new flags are supported.
> > 
> > But swapon never did so: start checking now, to help if we ever want to
> > support more swap_flags in future.
> > 
> > It's difficult to get stray bits set in an int, and swapon is not widely
> > used, so this is most unlikely to break any userspace; but we can just
> > revert if it turns out to do so.
> 
> It would be safer to emit a nasty message then let the swapon proceed
> as before.

Safer, I suppose, but I really don't expect that case to arise (we'll
have been doing those lovely runtime discards without asking for a year
now if so).  And it does spoil the checking of supported flags.

Hugh
