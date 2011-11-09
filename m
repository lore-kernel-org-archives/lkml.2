Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406Ab1KIAX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 19:23:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933174Ab1KIAX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 19:23:57 -0500
Date: Wed, 9 Nov 2011 01:23:55 +0100
From: Jan Kara <jack@suse.cz>
To: =?iso-8859-1?B?R+Fib3IgTOlu4XJ0?= <lgb@lgb.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: barrier-based sync failed - disabling barriers
Message-ID: <20111109002355.GC21318@quack.suse.cz>
References: <20111018081159.GA21728@vega.lgb.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111018081159.GA21728@vega.lgb.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Tue 18-10-11 10:11:59, Gábor Lénárt wrote:
> I have a kernel log entry I've never seen before:
> 
> JBD: barrier-based sync failed on cciss!c0d0p3-8 - disabling barriers
> JBD: barrier-based sync failed on cciss!c0d0p1-8 - disabling barriers
> 
> Should I worry? Can it be blamed for the poor I/O performance? How can I
> solve this problem? Even if it doesn't mean too much (what I should
> worry about), it's a bit annoying (as always) to see odd messages.
> 
> The ext4 filesystems were created by the installer of an older (ubuntu)
> distribution, I guess, it can cause problems after the upgrade. Can I
> convert/modify the filesystem (like with tune2fs) not to have these messages
> and problem?
  You didn't choose the best list for this question -
linux-ext4@vger.kernel.org would be a better fit. LKML has far too big
traffic and things get lost... That's why I'm answering your email that
late as well.

  The messages about barriers are normal with the HW. They say that the
hardware (or the storage driver) does not support cache flush command.
Generally, if the array has battery backed write caches (or is otherwise
protected from power failure), you don't have to use barriers anyway (and
you can gain some performance boost by that). If you don't want to see
those messages in the log, use nobarrier mount option.

  These messages can only have positive effect on performance so if you
have some performance problems, it's something else...

								Honza
