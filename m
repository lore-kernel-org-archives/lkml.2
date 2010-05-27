Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110Ab0E0JJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 05:09:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35310 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400Ab0E0JJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 05:09:03 -0400
Date: Thu, 27 May 2010 10:08:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nick Piggin <npiggin@suse.de>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCHv4 17/17] writeback: lessen sync_supers wakeup count
Message-ID: <20100527090859.GB31073@ZenIV.linux.org.uk>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
 <1274795352-3551-18-git-send-email-dedekind1@gmail.com>
 <20100527065041.GA31073@ZenIV.linux.org.uk>
 <20100527072240.GM22536@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527072240.GM22536@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 05:22:40PM +1000, Nick Piggin wrote:
> Yeah, we definitely don't want to add global cacheline writes in the
> common case. Also I don't know why you do the strange -1 value. I
> couldn't seem to find where you defined bdi_arm_supers_timer();

bdi_arm_supers_timer() is in the mainline; basically, it's "schedule
timer that'll wake sync_supers_tsk in $INTERVAL from now".
