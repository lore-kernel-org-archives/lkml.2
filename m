Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab0KIVHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:07:24 -0500
Received: from thunk.org ([69.25.196.29]:38598 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab0KIVHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:07:21 -0500
Date: Tue, 9 Nov 2010 16:07:15 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Rik van Riel <riel@redhat.com>
Cc: Jeff Layton <jlayton@redhat.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, esandeen@redhat.com, jmoyer@redhat.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] clear PageError bit in msync & fsync
Message-ID: <20101109210715.GJ3099@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Rik van Riel <riel@redhat.com>,
	Jeff Layton <jlayton@redhat.com>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, esandeen@redhat.com, jmoyer@redhat.com,
	linux-fsdevel@vger.kernel.org
References: <20101109114422.3918e7f6@annuminas.surriel.com>
 <20101109142109.224267d0@corrin.poochiereds.net>
 <4CD9A209.6070807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD9A209.6070807@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 02:33:29PM -0500, Rik van Riel wrote:
> 
> There are essentially two possibilities:
> 1) the VM can potentially be filled up with uncleanable dirty pages, or
> 2) pages that hit an IO error are left in a clean state, so they can
>    be reclaimed under memory pressure
> 
> Alternative 1 could cause the entire system to deadlock, while
> option 2 puts the onus on userland apps to rewrite the data
> from a failed msync/fsync.
> 
> Currently the VM has behaviour #2 which is preserved with my
> patch.
> 
> The only difference with my patch is, we won't keep returning
> -EIO on subsequent, error free, msync or fsync calls to files
> that had an IO error at some previous point in the past.

Do we guarantee that the application will get EIO at least once?  I
thought there were issues where the error bit could get lost if the
page writeback was triggered by sync() run by a third-party
application.


     	       	   	     		- Ted
