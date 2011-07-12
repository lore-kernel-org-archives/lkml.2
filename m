Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab1GLVxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 17:53:01 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60861 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab1GLVxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 17:53:00 -0400
From: "Patrick J. LoPresti" <lopresti@gmail.com>
To: Andrea Righi <andrea@betterlinux.com>
Subject: Re: [PATCH v3 0/2] fadvise: support POSIX_FADV_NOREUSE
In-Reply-To: <20110627123946.GB1658@thinkpad>
References: <1308923350-7932-1-git-send-email-andrea@betterlinux.com> <4E07F349.2040900@jp.fujitsu.com> <20110627071139.GC1247@thinkpad> <4E0858CF.6070808@draigBrady.com> <20110627102933.GA1282@thinkpad> <4E086F51.50403@draigBrady.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Date: Tue, 12 Jul 2011 14:52:49 -0700
Message-ID: <8762n7kvym.fsf@cmungerjr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> IIUC, NOREUSE means "the application will use this range of the file
> once". It's something that we do _before_ accessing the file.  And the
> kernel needs to remember the ranges of NOREUSE data for each file, so
> that page cache can be immediately dropped after the data has been
> accessed (if possible).

I am no expert on the Linux page cache, but my applications have a great
interest in exercising some control over it...

Could NOREUSE be as simple as setting a bit on the page that means
"never mark this page active"?

Or more conservatively, "clear this bit before marking the page active"?

So POSIX_FADV_NOREUSE would set the bit on the page.  Then any operation
that would normally mark the page active would instead merely clear the
bit.  This would keep the page on the inactive list _after_ the first
read and allow it to be reclaimed, which is at least in the "spirit" of
NOREUSE.

 - Pat
