Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab2JJXWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:22:03 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:54908 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669Ab2JJXV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:21:58 -0400
Date: Wed, 10 Oct 2012 19:21:51 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Zach Brown <zab@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [PATCH 2/5] aio: kiocb_cancel()
Message-ID: <20121010232151.GC11468@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Zach Brown <zab@redhat.com>,
	Kent Overstreet <koverstreet@google.com>,
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@redhat.com
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-2-git-send-email-koverstreet@google.com>
 <20121009182625.GM26187@lenny.home.zabbo.net>
 <20121009213700.GF29494@google.com>
 <20121010110356.GA11468@thunk.org>
 <20121010212051.GD6371@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121010212051.GD6371@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 02:20:51PM -0700, Zach Brown wrote:
> 
> I sympathize, but the reality is that the current infrastructure
> is very bad and no one is using it.
> 
> It's not like we're getting rid of the syscall.  I'll be behaving
> exactly as it does today: returning the error code that indicates that
> cancellation failed because it lost the race with completion.  Every
> caller has to cope with that to use cancel safely.

Yes, I realize it doesn't work today.  But hopefully we'll be able to
reimplement it in a cleaner way.  That's why I said, I hope we don't
give up on the functionality of aio_cancel --- not that I'm against
removing what we currently have.

Cheers,

					- Ted
