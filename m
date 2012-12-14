Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab2LNBsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 20:48:12 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:64952 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862Ab2LNBsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 20:48:09 -0500
Message-ID: <50CA8556.7030905@mit.edu>
Date: Thu, 13 Dec 2012 17:48:06 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Darrick J. Wong" <darrick.wong@oracle.com>
CC: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
        viro@zeniv.linux.org.uk, rminnich@sandia.gov, tytso@mit.edu,
        martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
        Zheng Liu <gnehzuil.liu@gmail.com>, linux-kernel@vger.kernel.org,
        hch@infradead.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
        v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 4/4] block: Optionally snapshot page contents to provide
 stable pages during write
References: <20121213080740.23360.16346.stgit@blackbox.djwong.org> <20121213080811.23360.98131.stgit@blackbox.djwong.org>
In-Reply-To: <20121213080811.23360.98131.stgit@blackbox.djwong.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 12:08 AM, Darrick J. Wong wrote:
> Several complaints have been received regarding long file write latencies when
> memory pages must be held stable during writeback.  Since it might not be
> acceptable to stall programs for the entire duration of a page write (which may
> take many milliseconds even on good hardware), enable a second strategy wherein
> pages are snapshotted as part of submit_bio; the snapshot can be held stable
> while writes continue.
> 
> This provides a band-aid to provide stable page writes on jbd without needing
> to backport the fixed locking scheme in jbd2.  A mount option is added to ext4
> to allow administrators to enable it there.

I'm a bit confused as to what it has to do with ext3.  Wouldn't this be
useful as a mount option everywhere, though?

If this becomes widely used, would it be better to snapshot on
wait_for_stable_page instead of on io submission?

FWIW, I'm about to pound pretty hard on this whole patchset on a box
that doesn't need stable pages.  I'll let you know how it goes.

--Andy
