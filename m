Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab0JAGXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 02:23:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752349Ab0JAGXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 02:23:08 -0400
Date: Thu, 30 Sep 2010 23:23:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/17] fs: icache lock i_count
Message-Id: <20100930232339.32ed3b38.akpm@linux-foundation.org>
In-Reply-To: <20101001061602.GA19107@infradead.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	<1285762729-17928-6-git-send-email-david@fromorbit.com>
	<20100929215229.160c7bce.akpm@linux-foundation.org>
	<20101001055536.GD32349@infradead.org>
	<20100930230416.868e6468.akpm@linux-foundation.org>
	<20101001061602.GA19107@infradead.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Oct 2010 02:16:02 -0400 Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Sep 30, 2010 at 11:04:16PM -0700, Andrew Morton wrote:
> > No, we've run into problems *frequently*.  A common case is where we
> > convert a mutex to a spinlock or vice versa.  If you don't rename the
> > lock, the code still compiles (with warnings) and crashes horridly at
> > runtime.
> 
> Sorry, if you run code with that obvious warnings you beg for trouble.
> If you really believe your advanced users arw too stupid to read
> compiler warnings enforcing -Werror is for sure better than obsfucating
> the code.

Well, it has happened, fairly regularly.  A common scenario is where
someone has done a conversion in one tree and someone else has touched
overlapping code in another tree and when the two meet in linux-next,
splat.  Renaming the field simply eliminates this.

Of course, the warnings don't get noticed because of the enormous
warning storm which a kernel build produces (generally much worse on
non-x86, btw).

Another reason for remaining a field is when we desire that it
henceforth be accessed via accessor functions - renaming it will
reliably break any unconverted code.
