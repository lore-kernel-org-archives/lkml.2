Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965538Ab2EXVcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 17:32:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64107 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965511Ab2EXVcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 17:32:02 -0400
Date: Thu, 24 May 2012 14:31:58 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, tj@kernel.org,
        axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v2 09/14] block: Add an explicit bio flag for bios that
 own their bvec
Message-ID: <20120524213158.GB22664@google.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
 <1337817771-25038-10-git-send-email-koverstreet@google.com>
 <4FBE687E.1030605@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBE687E.1030605@panasas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 07:57:34PM +0300, Boaz Harrosh wrote:
> How do you insure that the original bio which owns the
> bvec is not freed before the split-out bio.
> 
> Perhaps calling code needs to make sure by taking an extra
> ref on the original bio, or something. If so a big fat comment
> at bio_split is do.

Yeah, just added that.

> 
> And I understand you did not like my suggestion of negating
> the meaning of the flag, so the default is zero?
> Please say why?

I liked it at first, but I think I prefer having the flag be set
if bio_free() must take some action; i.e. you set the flag when you
allocate bi_io_vec. Also, I think bio_alloc_bioset() getting
reimplemented is less likely than people open coding bio splitting or
something that shares bi_io_vec in the future, so it's slightlry less
likely to be used wrong this way.
