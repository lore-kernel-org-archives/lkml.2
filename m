Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab0EXLiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 07:38:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755542Ab0EXLiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 07:38:24 -0400
Date: Mon, 24 May 2010 12:38:16 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Will Drewry <wad@chromium.org>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, snitzer@redhat.com
Subject: Re: [dm-devel] [PATCH v3 3/3] dm: lookup devices by path with
	name_to_dev_t
Message-ID: <20100524113815.GX3991@agk-dp.fab.redhat.com>
Mail-Followup-To: Will Drewry <wad@chromium.org>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org, snitzer@redhat.com
References: <1274294304-30606-1-git-send-email-wad@chromium.org> <1274294304-30606-3-git-send-email-wad@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274294304-30606-3-git-send-email-wad@chromium.org>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 01:38:24PM -0500, Will Drewry wrote:
> Replace major:minor parsing with name_to_dev_t.  This
> maintains the current functionality (as the code was the same),
> but adds support for the hexadecimal dev as well as device lookup
> before the root filesystem is available.  The latter is the motivation
> for this change.
> 
> It still falls back to lookup_bdev() for cases where the inode
> on disk provides more information than the name (and the path exceeds
> the length handled by name_to_dev_t).
 
I'll apply this, but anyone debugging problems in future should note the
functional change here: the standard in-kernel device names will now take
precedence over the inodes in /dev if the two don't match and this might
confuse people.  As it's technically an interface change, I'll bump
the version number so userspace can detect this if it ever needs to.

Alasdair

