Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab3AGXsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 18:48:25 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64768 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017Ab3AGXsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 18:48:23 -0500
Date: Mon, 7 Jan 2013 15:48:20 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu
Subject: Re: [PATCH 20/32] aio: Give shared kioctx fields their own cachelines
Message-ID: <20130107234820.GJ26407@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
 <1356573611-18590-23-git-send-email-koverstreet@google.com>
 <20130103152512.009513a1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130103152512.009513a1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 03:25:12PM -0800, Andrew Morton wrote:
> On Wed, 26 Dec 2012 17:59:59 -0800
> Kent Overstreet <koverstreet@google.com> wrote:
> 
> >  	struct {
> > -		struct mutex	ring_lock;
> > +		atomic_t	reqs_active;
> >  	} ____cacheline_aligned;
> 
> Is there a reason why this guy remains aligned on CONFIG_SMP=n?

No good one, but I see you've already fixed it in your tree.
