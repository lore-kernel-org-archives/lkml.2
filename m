Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab0FTXLB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 19:11:01 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:59152 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755410Ab0FTXLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 19:11:00 -0400
Date: Mon, 21 Jun 2010 09:10:17 +1000
From: Dave Chinner <david@fromorbit.com>
To: Michael Rubin <mrubin@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, jack@suse.cz, akpm@linux-foundation.org, hch@lst.de,
       axboe@kernel.dk
Subject: Re: [PATCH 0/3] writeback visibility
Message-ID: <20100620231017.GI6590@dastard>
References: <1276907415-504-1-git-send-email-mrubin@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276907415-504-1-git-send-email-mrubin@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 05:30:12PM -0700, Michael Rubin wrote:
> Debugging writeback issues and tuning an application's writeback activity is
> easier when the activity is visible.  With large clusters, classifying
> and root causing writeback problems has been a big headache. This patch
> series contains a series of patches that our team has been using to start
> getting a handle on writeback behaviour. These changes should be helpful
> for single system maintainers also. It's still a big headache.
> 
> Once these changes are reviewed I will make sure the Documentation files
> are updated, but I expect some back and forth first.
> 
> Michael Rubin (3):
>   writeback: Creating /sys/kernel/mm/writeback/writeback
>   writeback: per bdi monitoring
>   writeback: tracking subsystems causing writeback

I'm not sure we want to export statistics that represent internal
implementation details into a fixed userspace API. Who, other than
developers, are going to understand and be able to make use of this
information?

FWIW, I've got to resend the writeback tracing patches to Jens that I
have that give better visibility into the writeback behaviour.
Perhaps those tracing events are a better basis for tracking down
writeback problems - the bugs I found with the tracing could not
have been found with these statistics...

That's really why I'm asking - if the stats are just there to help
development and debugging, then I think that improving the writeback
tracing is a better approach to improving visibility of writeback
behaviour...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
